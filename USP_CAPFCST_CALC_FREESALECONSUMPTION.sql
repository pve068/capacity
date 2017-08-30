USE [CapInvRepository]
GO
/****** Object:  StoredProcedure [dbo].[USP_CAPFCST_CALC_FREESALECONSUMPTION]    Script Date: 01-08-2017 10:52:23 ******/
IF ( OBJECT_ID('DBO.USP_CAPINV_CALC_REMAINING_CAPACITY', 'P') IS NOT NULL ) 
   DROP PROCEDURE DBO.USP_CAPINV_CALC_REMAINING_CAPACITY
GO

CREATE PROCEDURE [dbo].USP_CAPINV_CALC_REMAINING_CAPACITY
/****************************************************************************************************
* COPYRIGHT REVENUE ANALYTICS 2017
* ALL RIGHTS RESERVED
*
* CREATED BY: DATA ENGINEERING
* FILENAME:   USP_CAPFCST_CALC_FREESALECONSUMPTION.SQL
* DATE:       04/07/2017
*
* APPLICATION:  CALCULATES FREESALE
*               
* PARAMETERS:   @V_RUNDATE = DATE OF THE RUN
*				@V_PARENT_PROCESS_ID == PARENT OR CALLING PROCESS ID
*				@V_ERROR_CODE		== RETURNED ERROR CODE
*  				
* ASSUMPTIONS: ROCKS, COMS, DISPLACEMENT, COMMITMENT AND CONSUMPTION TABLES REFRESH
* 
* INPUTS:		ANALYTICSDATAMART.DBO.AD_ROCKS
*				ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE
*				ANALYTICSDATAMART.DBO.ML_ALLOCATIONS
*				ANALYTICSDATAMART.DBO.AD_DISPLACEMENT_OOG
* OUTPUTS:		DBO.AD_CAPFCST_FREESALE_UBOAT
*				
* EXAMPLE CALL: DECLARE	@return_value int,
*						@V_ERROR_CODE int
*
*				EXEC	@return_value = [dbo].[USP_CAPFCST_CALC_FREESALECONSUMPTION]
*						@V_RUNDATE = '2017-04-01',
						@V_PARENT_PROCESS_ID = 0,
*						@V_ERROR_CODE = @V_ERROR_CODE OUTPUT
*****************************************************************************************************
* NOTES:
*  NAME					CREATED        LAST MOD			COMMENTS
*  DE\ELM               4/17/2017						PROCEDURE CREATED
****************************************************************************************************/
	 @V_RUNDATE DATE
	,@V_PARENT_PROCESS_ID INT
	,@V_ERROR_CODE INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON 
	--DECLARE VARIABLES
	DECLARE @V_ERRORMESSAGE NVARCHAR(4000)  
	DECLARE @V_MSG  NVARCHAR(4000)
	DECLARE @V_NOTE  NVARCHAR(4000)
	DECLARE @V_ERRORSEVERITY INT  

	DECLARE @V_PROCESS_ID INT = NEXT VALUE FOR DBO.SEQ_LOG_PROCESS_ID
	DECLARE @V_PROCESS_NAME VARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
	DECLARE @V_FIANLERROR INT
	DECLARE @V_SYSTEM_USER NVARCHAR(255) = SYSTEM_USER
	DECLARE @V_SYSTEMTIME DATETIME = GETUTCDATE()
	DECLARE @V_RECORD_CNT INT

	DECLARE @V_STEP_ID TINYINT
	DECLARE @V_STEP_NAME VARCHAR(255)
	DECLARE @V_AUDITVERSIONID INT
	
	--ASSIGN TODAYS DATE IF RUNDATE IS NULL
	SET @V_RUNDATE = CAST(COALESCE(@V_RUNDATE, GETUTCDATE()) AS DATE)
	SET @V_PARENT_PROCESS_ID = COALESCE(@V_PARENT_PROCESS_ID,0)
	--GET AUDIT VERSION ID
	EXEC @V_AUDITVERSIONID = ANALYTICSDATAMART.DBO.USP_GETAUDITVERSIONID NULL, @V_AUDITVERSIONID OUTPUT


	select @V_RUNDATE 
	select @V_AUDITVERSIONID

	BEGIN TRY
		--LOG PROCESS		
		EXEC DBO.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = @V_SYSTEMTIME
							, @V_END_DT = NULL
							, @V_STATUS = 'RUNNING'
							, @V_ACTION = 1
							, @V_PARENT_PROCESS_ID = @V_PARENT_PROCESS_ID
							, @V_NOTE = 'PROCESS TO CALCULATE FREESALE CONSUMPTION'
							, @V_START_STEP = 1;

		/******************************************************************
						EMPTIES -- AGGREGATE OF ROCK DATA
		*******************************************************************/
		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'DISTRIBUTE ROCK DATA AT THE LEG LEVEL'
		SET @V_NOTE = 'DISTRIBUTE ROCK DATA AT THE LEG LEVEL'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		SELECT A.VESSELCODE,A.VOYAGE, A.SERVICECODE, A.DEPARTUREPORT,MIN(B.SCHEDULEID) AS FIRSTSCHEDULEID
		INTO #TMP_ROCKS_MIN
		FROM ANALYTICSDATAMART.DBO.AD_ROCKS A (NOLOCK)
		INNER JOIN ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE B (NOLOCK)
		ON A.VESSELCODE = B.VESSELCODE
		--AND A.VOYAGE = B.VOYAGE --Removed becasue you want to we want leg across voyages
		AND A.SERVICECODE = B.SERVICECODE
		AND A.DEPARTUREPORT = B.DEPARTUREPORT
		GROUP BY A.VESSELCODE,A.VOYAGE, A.SERVICECODE, A.DEPARTUREPORT

	
		SELECT	A.VESSELCODE,A.VOYAGE, A.SERVICECODE
				, A.DEPARTUREPORT
				, A.ARRIVALPORT
				,gg.FIRSTSCHEDULEID
				,MIN(B.SCHEDULEID)  AS LASTSCHEDULEID
		INTO #TMP_ROCKS_ROUTE_SEQ
		FROM ANALYTICSDATAMART.DBO.AD_ROCKS (NOLOCK) A
		INNER JOIN #TMP_ROCKS_MIN GG
		ON A.VESSELCODE = GG.VESSELCODE
		AND A.SERVICECODE = GG.SERVICECODE
		AND A.VOYAGE = GG.VOYAGE
		AND A.DEPARTUREPORT = GG.DEPARTUREPORT
		INNER JOIN ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE B
		ON A.VESSELCODE = B.VESSELCODE
		AND A.SERVICECODE = B.SERVICECODE
		AND A.ARRIVALPORT = B.ARRIVALPORT
		AND B.SCHEDULEID >= GG.FIRSTSCHEDULEID
		GROUP BY A.VESSELCODE,A.VOYAGE, A.SERVICECODE
		, A.DEPARTUREPORT
				, A.ARRIVALPORT
				,gg.FIRSTSCHEDULEID

		IF OBJECT_ID('DBO.TMP_ROCK_LEGSEQUENCE', 'U') IS NOT NULL
		  DROP TABLE DBO.TMP_ROCK_LEGSEQUENCE;

		SELECT KK.[VESSELCODE]
			  ,KK.[VOYAGE]
			  ,KK.[SERVICECODE]
			  ,KK.[DEPARTUREPORT]
			  ,KK.[ARRIVALPORT]
			  ,KK.[DEPARTUREDATE]
			  ,KK.[ARRIVALDATE]
			  ,KK.[VESSELOPERATOR]
			  ,KK.[TOTALEMPTYCONTAINER]
			  ,KK.[TOTALEMPTYTEU]
			  ,KK.[TOTALEMPTYTONS]
			  ,LL.FIRSTSCHEDULEID
			  ,LL.LASTSCHEDULEID
		INTO DBO.TMP_ROCK_LEGSEQUENCE
		FROM ANALYTICSDATAMART.DBO.AD_ROCKS KK
		INNER JOIN #TMP_ROCKS_ROUTE_SEQ LL
		ON KK.VESSELCODE = LL.VESSELCODE
		AND KK.VOYAGE = LL.VOYAGE
		AND KK.SERVICECODE = LL.SERVICECODE
		AND KK.DEPARTUREPORT = LL.DEPARTUREPORT
		AND KK.ARRIVALPORT = LL.ARRIVALPORT;

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = SYSDATETIME()

		--	LOG PROCESS DETAIL
		SET @V_NOTE = @V_STEP_NAME + ' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;

		SET @V_STEP_ID = 15
		SET @V_STEP_NAME = 'AGGREGATE ROCKS DATA AT THE LEG LEVEL'
		SET @V_NOTE = 'AGGREGATE ROCKS DATA AT THE LEG LEVEL'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

			--BUILD FINAL EMPTIES AGG TABLE
			IF OBJECT_ID('DBO.TMP_AGG_EMPTY', 'U') IS NOT NULL
			  DROP TABLE DBO.TMP_AGG_EMPTY;

			SELECT  A.VESSELCODE
				   , A.VOYAGE
				   , A.SERVICECODE
				   , B.DEPARTUREPORT
				   , B.ARRIVALPORT
				   , B.LEGSEQID
				   , SUM(TOTALEMPTYCONTAINER) AS TOTALEMPTYCONTAINER
				   , SUM(TOTALEMPTYTEU) AS TOTALEMPTYTEU
				   , SUM(TOTALEMPTYTONS) AS TOTALEMPTYTONS
			INTO DBO.TMP_AGG_EMPTY 
			FROM DBO.TMP_ROCK_LEGSEQUENCE A
			INNER JOIN ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE B
			ON A.SERVICECODE = B.SERVICECODE
			AND A.VESSELCODE = B.VESSELCODE
			AND A.VOYAGE = B.VOYAGE
			AND B.SCHEDULEID BETWEEN A.FIRSTSCHEDULEID AND A.LASTSCHEDULEID
			GROUP BY A.VESSELCODE
				   , A.VOYAGE
				   , A.SERVICECODE
				   , B.DEPARTUREPORT
				   , B.ARRIVALPORT
				   , B.LEGSEQID;

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = SYSDATETIME()

		--	LOG PROCESS DETAIL
		SET @V_NOTE = @V_STEP_NAME + ' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;
		/*****************************************************************
				COMBINE ALLOCATIONS AND EMPTIES
		******************************************************************/	
		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'AGGREGATE CONSUMPTION DATA'
		SET @V_NOTE = 'AGGREGATE CONSUMPTION DATA'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;


select top 10 * from CAPINVREPOSITORY.DBO.CAPFCST_AD_CONSUMPTION

		IF OBJECT_ID('DBO.TMP_AGG_CAPFCST_FREESALECONSUMPTION', 'U') IS NOT NULL
		  DROP TABLE DBO.TMP_AGG_CAPFCST_FREESALECONSUMPTION;

		--CREATE FREE SALE CONSUMPTIONS
		WITH DATA AS
		(
			SELECT  NT.VESSEL
					,NT.VOYAGE
					,NT.SERVICECODE
					, NT.FROMLEGSITECODE AS DEPARTUREPORT
					, NT.TOLEGSITECODE AS ARRIVALPORT
					, NT.LEGSEQID
					, NT.DEPARTUREDATE
					, NT.ARRIVALDATE
					, NT.serviceCodeDirection
					--FREESALE
					, SUM(CASE WHEN NT.ISFREESALE = 1 THEN NT.TEU ELSE 0 END) AS CONSUMPTIONTEU
					, SUM(CASE WHEN NT.ISFREESALE = 1 THEN GROSSWEIGHTKG /1000.0 ELSE 0 END) AS CONSUMPTIONGROSSWEIGHTTONS
					, SUM(CASE WHEN NT.ISFREESALE = 1 THEN NT.PLUGS ELSE 0 END) AS CONSUMPTIONPLUGS
					--DISPLACEMENTS
					, SUM(COALESCE(DP.DISPLACEMENTFFE,0)) AS DISPLACEMENTFFE
					, SUM(COALESCE(DP.DISPLACEMENTTEU,0)) AS DISPLACEMENTTEU
					, SUM(COALESCE(DP.FFE, 0)) AS OOGFFE
					, SUM(COALESCE(DP.TEU,0)) AS OOGTEU
					, SUM(COALESCE(DP.FFEWITHOOG,0)) AS FFEWITHOOG
					, SUM(COALESCE(DP.TEUWITHOOG,0) * 2) AS TEUWITHOOG
					--COMMITMENT
					, SUM(CASE WHEN NT.ISFREESALE = 0 THEN NT.TEU ELSE 0 END) AS COMMITMENTTEU
					, SUM(CASE WHEN NT.ISFREESALE = 0 THEN GROSSWEIGHTKG /1000.0 ELSE 0 END) AS COMMITMENTGROSSWEIGHTTONS
					, SUM(CASE WHEN NT.ISFREESALE = 0 THEN NT.PLUGS ELSE 0 END) AS COMMITMENTPLUGS
			FROM CAPINVREPOSITORY.DBO.CAPFCST_AD_CONSUMPTION  NT (NOLOCK)
			LEFT JOIN ANALYTICSDATAMART.DBO.AD_DISPLACEMENT_OOG DP (NOLOCK)
			ON NT.SHIPMENT_NO_X = DP.SHIPMENT_NO 
			AND NT.SHIPMENT_VRSN_ID_X = DP.SHIPMENTVERSIONID
			AND NT.SERVICECODE = DP.SERVICECODE
			GROUP BY	NT.VESSEL
						,NT.VOYAGE
						,NT.SERVICECODE
						, NT.FROMLEGSITECODE
						, NT.TOLEGSITECODE
						, NT.LEGSEQID
						, NT.DEPARTUREDATE
						, NT.ARRIVALDATE
						, NT.serviceCodeDirection
		)
		SELECT VESSEL
			,VOYAGE
			,SERVICECODE
			, DEPARTUREPORT
			, ARRIVALPORT
			, DEPARTUREDATE
			, ARRIVALDATE
			, serviceCodeDirection
			, LEGSEQID
			, CONSUMPTIONTEU
			, CONSUMPTIONTEU AS CUMMTEU
			, CONSUMPTIONGROSSWEIGHTTONS
			, CONSUMPTIONGROSSWEIGHTTONS AS CUMMGROSSWEIGHTTONS
			, CONSUMPTIONPLUGS
			, CONSUMPTIONPLUGS AS CUMMPLUGS
			, DISPLACEMENTFFE
			, DISPLACEMENTTEU
			, OOGFFE
			, OOGTEU
			, FFEWITHOOG
			, TEUWITHOOG
			, COMMITMENTTEU
			, COMMITMENTTEU AS CUMMCOMMITMENTTEU
			, COMMITMENTGROSSWEIGHTTONS
			, COMMITMENTGROSSWEIGHTTONS AS CUMMCOMMITMENTTONS
			, COMMITMENTPLUGS
			, COMMITMENTPLUGS AS CUMMCOMMITMENTPLUGS
		INTO DBO.TMP_AGG_CAPFCST_FREESALECONSUMPTION
		FROM DATA;

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = SYSDATETIME()

		--	LOG PROCESS DETAIL
		SET @V_NOTE = @V_STEP_NAME + ' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;
		/***************************************************************
					BUILD FINAL TABLE
		****************************************************************/	
		SET @V_STEP_ID = 25
		SET @V_STEP_NAME = 'DELETE EXISTING RUN DATA'
		SET @V_NOTE = 'DELETE EXISTING RUN DATA'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		DELETE FROM ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT_TMP
		WHERE rundate = cast(@V_RUNDATE as daTE);

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = SYSDATETIME()

		--	LOG PROCESS DETAIL
		SET @V_NOTE = @V_STEP_NAME + ' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;

		--LOG DETAIL
		SET @V_STEP_ID = 30
		SET @V_STEP_NAME = 'CREATE UBOAT DATA TABLE'
		SET @V_NOTE = 'AGGREGATE CONSUMPTION DATA AT THE RUNID/VESSELCODE/VOYAGE/SERVICECODE/DEPARTUREPORT/ARRIVALPORT LEVEL'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;
		
		INSERT INTO ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT_TMP
           ([ID]
           ,[RUNID]
           ,[RUNDATE]
           ,[VOYAGE]
           ,[VESSELCODE]
           ,[SERVICECODE]
           ,[LEGSEQID]
           ,[SERVICECODEDIRECTION]
           ,[DEPARTUREPORT]
           ,[ARRIVALPORT]
           ,[VESSELOPERATOR]
           ,[DEPARTUREDATE]
           ,[ARRIVALDATE]
           ,[INTAKETEU]
           ,[INTAKETONS]
           ,[INTAKEPLUGS]
           ,[ALLOCATIONTEU]
           ,[ALLOCATIONTONS]
           ,[ALLOCATIONPLUGS]
           ,[TOTALEMPTYTEU]
           ,[TOTALCOMMITFILINGSTEU]
           ,[FREESALEALLOCATIONTEU]
           ,[OVERBOOKTEU]
		   ,OVERBOOKPCT
           ,[FREESALE_AVAILABLETEU]
           ,[FREESALECONSUMPTIONTEU]
           ,[FREESALEDISPLACEMENTTEU]
           ,[DISPLACEMENTFFE]
           ,[CONSUMPTIONDISPLACEMENTTEU]
           ,[REMAINING_FREESALEDISPLACEMENTTEU]
           ,[REMAINING_FREESALETEU]
           ,[REMAINING_FREESALEDISPLACEMENTNOOVERBOOKTEU]
           ,[REMAINING_FREESALENOOVERBOOKTEU]
           ,[REMAINING_FREESALEDISPLACEMENTFFE]
           ,[REMAINING_FREESALEFFE]
           ,[TOTALEMPTYTONS]
           ,[TOTALCOMMITFILINGSTONS]
           ,[FREESALEALLOCATIONTONS]
           ,[OVERBOOKTONS]
           ,[FREESALE_AVAILABLETONS]
           ,[FREESALE_AVAILABLENOOVERBOOKTONS]
           ,[FREESALECONSUMPTIONTONS]
           ,[REMAINING_FREESALETONS]
           ,[REMAINING_FREESALENOOVERBOOKTONS]
           ,[TOTALCOMMITFILINGSPLUGS]
           ,[FREESALEALLOCATIONPLUGS]
           ,[OVERBOOKPLUGS]
           ,[FREESALE_AVAILABLEPLUGS]
           ,[FREESALE_AVAILABLENOOVERBOOKPLUGS]
           ,[FREESALECONSUMPTIONPLUGS]
           ,[REMAINING_FREESALEPLUGS]
           ,[REMAINING_FREESALENOOVERBOOKPLUGS])
		SELECT ROW_NUMBER() OVER(ORDER BY a.voyage) AS ID 
				, @V_AUDITVERSIONID AS RUNID
				, @V_RUNDATE AS RUNDATE
				,A.VOYAGE
				,A.VESSELCODE	
				,A.SERVICECODE	
				, A.LEGSEQID
				, CON.SERVICECODEDIRECTION as SERVICECODEDIRECTION
				,A.DEPARTUREPORT	
				,A.ARRIVALPORT
				,A.VESSELOPERATOR	
				,CON.DEPARTUREDATE	
				,CON.ARRIVALDATE
				,A.INTAKETEU	
				,A.INTAKETONS	
				,A.INTAKEPLUGS	
				,A.ALLOCATIONTEU	
				,A.ALLOCATIONTONS	
				,A.ALLOCATIONPLUGS

				, COALESCE(B.TOTALEMPTYTEU,0) AS TOTALEMPTYTEU
				, COALESCE(CON.CUMMCOMMITMENTTEU,0) AS TOTALCOMMITFILINGSTEU
		
				--AVAILABLE --NO OVERBOOK		
				, A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0) AS FREESALEALLOCATIONTEU
				, ROUND(( (0.0)* ( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))),0) AS OVERBOOKTEU
				,cast(0.0 as numeric(10,5)) as OVERBOOKPCT
				
				--OVerbooking Pct
				--FREESALE_AVAILABLETEU = FREESALEALLOCATIONTEU + OVERBOOKTEU
				, ( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))
					 + ROUND(( (0.0)* ( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))),0) AS FREESALE_AVAILABLETEU
				, COALESCE(CON.CUMMTEU,0) AS FREESALECONSUMPTIONTEU
				, COALESCE(DISPLACEMENTTEU,0) AS FREESALEDISPLACEMENTTEU
				, COALESCE(CON.DISPLACEMENTFFE,0) AS DISPLACEMENTFFE
				, COALESCE(CON.CUMMTEU,0) + COALESCE(DISPLACEMENTTEU,0) AS CONSUMPTIONDISPLACEMENTTEU
				, (( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))
					 + ROUND(( (0.0)* ( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))),0) ) - COALESCE(CON.CUMMTEU,0) - COALESCE(CON.DISPLACEMENTTEU,0) AS REMAINING_FREESALEDISPLACEMENTTEU
				, (( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))
					 + ROUND(( (0.0)* ( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))),0) ) - COALESCE(CON.CUMMTEU,0) AS REMAINING_FREESALETEU
				--REMAINING TEU WITH NO OVERBOOK
				, (( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0)))
					 - COALESCE(CON.CUMMTEU,0) - COALESCE(CON.DISPLACEMENTTEU,0) AS REMAINING_FREESALEDISPLACEMENTNOOVERBOOKTEU
				, (( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))) - COALESCE(CON.CUMMTEU,0) AS REMAINING_FREESALENOOVERBOOKTEU
				--REMAINING CAPACITY FFE
				, ((( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))
					 + ROUND(( (0.0)* ( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))),0) ) - COALESCE(CON.CUMMTEU,0) - COALESCE(CON.DISPLACEMENTTEU,0)) / 2.00 AS REMAINING_FREESALEDISPLACEMENTFFE
				, ((( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))
					 + ROUND(( (0.0)* ( A.ALLOCATIONTEU - COALESCE(B.TOTALEMPTYTEU,0) - COALESCE(CON.CUMMCOMMITMENTTEU,0))),0) ) - COALESCE(CON.CUMMTEU,0)) / 2.00 AS REMAINING_FREESALEFFE
				--EMPTIES AND TONS
				, COALESCE(B.TOTALEMPTYTONS,0) AS TOTALEMPTYTONS
				, COALESCE(CON.CUMMCOMMITMENTTONS,0) AS TOTALCOMMITFILINGSTONS
				--FREE SALES ALLOCATION TONS 
				, A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0) AS FREESALEALLOCATIONTONS
				,  ((0.0)* ( A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0))) AS OVERBOOKTONS
				,( A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0))
					 + ( (0.0)* ( A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0))) AS FREESALE_AVAILABLETONS
				--AVAILABLE TONS -- NO OVERBOOKING
				,( A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0))  AS FREESALE_AVAILABLENOOVERBOOKTONS
				, COALESCE(CON.CUMMGROSSWEIGHTTONS,0) AS FREESALECONSUMPTIONTONS
				, (( A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0))
					 + ( (0.0)* ( A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0))) ) - COALESCE(CON.CUMMGROSSWEIGHTTONS,0) AS REMAINING_FREESALETONS
				--TONS WITH NO OVER BOOKING
				, (( A.ALLOCATIONTONS - COALESCE(B.TOTALEMPTYTONS,0) - COALESCE(CON.CUMMCOMMITMENTTONS,0))) - COALESCE(CON.CUMMGROSSWEIGHTTONS,0) AS REMAINING_FREESALENOOVERBOOKTONS
				---PLUGS
				, COALESCE(CON.CUMMCOMMITMENTPLUGS,0) AS TOTALCOMMITFILINGSPLUGS
				, A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0) AS FREESALEALLOCATIONPLUGS
				,  ROUND(((0.0)* ( A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0))),0) AS OVERBOOKPLUGS
				,( A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0))
					 + ROUND(((0.0)* ( A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0))),0) AS FREESALE_AVAILABLEPLUGS
				--AVAILABLE PLUGS - NO OVERBOOKING
				,( A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0)) AS FREESALE_AVAILABLENOOVERBOOKPLUGS

				, COALESCE(CON.CUMMPLUGS,0) AS FREESALECONSUMPTIONPLUGS
				, ROUND((( A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0))
					 + ROUND(((0.0)* ( A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0))),0) ) - COALESCE(CON.CUMMPLUGS,0),0) AS REMAINING_FREESALEPLUGS
				--PLUGS --NO OVERBOOKING
				, ROUND((( A.ALLOCATIONPLUGS - COALESCE(CON.CUMMCOMMITMENTPLUGS,0))) - COALESCE(CON.CUMMPLUGS,0),0) AS REMAINING_FREESALENOOVERBOOKPLUGS
		FROM  ANALYTICSDATAMART.DBO.AD_ML_ALLOCATIONS A
		LEFT JOIN DBO.TMP_AGG_EMPTY B
		ON A.VESSELCODE = B.VESSELCODE
		AND A.VOYAGE = B.VOYAGE
		AND A.SERVICECODE = B.SERVICECODE
		AND A.DEPARTUREPORT = B.DEPARTUREPORT
		AND A.ARRIVALPORT = B.ARRIVALPORT
		INNER JOIN DBO.TMP_AGG_CAPFCST_FREESALECONSUMPTION CON
		ON A.VESSELCODE = CON.VESSEL
		AND A.VOYAGE = CON.VOYAGE
		AND A.SERVICECODE = CON.SERVICECODE
		AND A.DEPARTUREPORT = CON.DEPARTUREPORT
		AND A.ARRIVALPORT = CON.ARRIVALPORT
		WHERE A.SERVICECODE IN (SELECT DISTINCT SERVICECODE FROM DBO.TMP_AGG_CAPFCST_FREESALECONSUMPTION);

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = SYSDATETIME()

		--	LOG PROCESS DETAIL
		SET @V_NOTE = @V_STEP_NAME + ' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;

		SET @V_NOTE = @V_PROCESS_NAME + ' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = NULL
							, @V_END_DT = @V_SYSTEMTIME
							, @V_STATUS = 'COMPLETED'
							, @V_ACTION = 2
							, @V_PARENT_PROCESS_ID = NULL
							, @V_NOTE = @V_NOTE
							, @V_START_STEP = 1;

		SET @V_ERROR_CODE = 0
		RETURN @V_ERROR_CODE
	END TRY
	BEGIN CATCH
		SET @V_MSG = COALESCE(ERROR_PROCEDURE() +' LINE:'+CAST(ERROR_LINE() AS VARCHAR(10))+' MESSAGE:' +ERROR_MESSAGE(),'')
		SET @V_ERRORMESSAGE = 'PROCESS TO REFRESH UBOAT DATA FAILED: ERR:' + @V_MSG
		SET @V_ERRORSEVERITY = ERROR_SEVERITY()  
		SET @V_SYSTEMTIME = GETUTCDATE()
		
		--UPDATE DETAIL 
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'FAILED'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 2
  					, @V_NOTE = @V_ERRORMESSAGE
  					;

		--UPDATE PROCESS --COMPLETE PROCESS
		EXEC DBO.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = NULL
							, @V_END_DT = @V_SYSTEMTIME
							, @V_STATUS = 'FAILED'
							, @V_ACTION = 2
							, @V_PARENT_PROCESS_ID = NULL
							, @V_NOTE =  @V_ERRORMESSAGE
							, @V_START_STEP = 1
							;  

		SET @V_ERROR_CODE = -1
		RETURN @V_ERROR_CODE
	END CATCH
END


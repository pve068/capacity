USE [CAPINVREPOSITORY]
GO

IF ( OBJECT_ID('DBO.USP_CAPINV_UI_DATA_UPDATE', 'P') IS NOT NULL ) 
   DROP PROCEDURE DBO.USP_CAPINV_UI_DATA_UPDATE
GO

CREATE PROCEDURE [DBO].USP_CAPINV_UI_DATA_UPDATE
/****************************************************************************************************
* COPYRIGHT REVENUE ANALYTICS 2017
* ALL RIGHTS RESERVED
*
* CREATED BY: DATA ENGINEERING
* FILENAME:   USP_CAPINV_UI_DATA_UPDATE.SQL
* DATE:       09/14/2017
*
* APPLICATION:  UPDATE UI TABLES WITH RECENT DATA
*               
* PARAMETERS:   @V_PARENT_PROCESS_ID == PARENT OR CALLING PROCESS ID
*				@V_ERROR_CODE		== RETURNED ERROR CODE
*  				
* ASSUMPTIONS: TABLE AD_CAPFCST_FREESALE_UBOAT UPDATED WITH RECENT DATA
* 
* INPUTS:		ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT
*				ANALYTICSDATAMART.DBO.CAPINVUDF_APP_PARAMETER
*				ANALYTICSDATAMART.DBO.VWVESSELS
*				ANALYTICSDATAMART.DBO.VWPORTCITIES
*				ANALYTICSDATAMART.DBO.DIM_DATE
*				ANALYTICSDATAMART.DBO.DIM_SERVICE
*
* OUTPUTS:		ANALYTICSDATAMART.DBO.CAPINV_UI_AGG_FREESALE_UBOAT
*				ANALYTICSDATAMART.DBO.CAPINV_UI_FREESALE_UBOAT_CURRENT
*				
* EXAMPLE CALL: DECLARE	@RETURN_VALUE INT,
*						@V_ERROR_CODE INT
*
*				EXEC	@RETURN_VALUE = [DBO].[USP_CAPINV_UI_DATA_UPDATE]
						@V_PARENT_PROCESS_ID = 0,
*						@V_ERROR_CODE = @V_ERROR_CODE OUTPUT
*****************************************************************************************************
* NOTES:
*  NAME					CREATED        LAST MOD			COMMENTS
*  DE\ELM               4/17/2017						PROCEDURE CREATED
****************************************************************************************************/
	@V_PARENT_PROCESS_ID INT
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
	DECLARE @V_PROCESSMASTER INT = (SELECT CAST(PARAMVALUE AS INT) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'CAPPROCESSMASTER' AND PROCESSNAME = 'CAPINV')
	DECLARE @V_RUNDATE DATE = CAST((Select distinct RUNDATE from ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT
								Where runid = (Select PublishedRunID from ANALYTICSDATAMART.DBO.[ProcessPublish] where ProcessMasterID = @V_PROCESSMASTER)
								) AS DATE)
	DECLARE @V_UI_RUNDATE_FCST_LOOKBACK INT = (SELECT CAST(PARAMVALUE AS INT) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'UI_RUNDATE_FCST_LOOKBACK' AND PROCESSNAME = 'CAPINV') 

	--ASSIGN TODAYS DATE IF RUNDATE IS NULL
	SET @V_PARENT_PROCESS_ID = COALESCE(@V_PARENT_PROCESS_ID,0)

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
							, @V_NOTE = 'UPDATE UI TABLES WITH RECENT DATA'
							, @V_START_STEP = 1;

		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'BUILD TUBE MAP DATA TABLE'
		SET @V_NOTE = 'BUILD THE TUBE MAP DATA TABLE AT THE ISC=LEAD LEVEL'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		IF OBJECT_ID('CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_AGG_FREESALE_UBOAT', 'U') IS NOT NULL
		  DROP TABLE CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_AGG_FREESALE_UBOAT;

		;WITH UI_AGG_DATA AS
		(
			SELECT      [RUNID]
					   ,[RUNDATE]
					   ,[VOYAGE]
					   ,[VESSELCODE]
					   ,[SERVICECODE]
					   ,[LEGSEQID]
					   ,[SERVICECODEDIRECTION]
					   ,[DEPARTUREPORT]
					   ,[ARRIVALPORT]
					   ,[VESSELOPERATOR]
					   ,MAX([DEPARTUREDATE]) as [DEPARTUREDATE]
					   ,MAX([ARRIVALDATE]) AS [ARRIVALDATE]
					   ,isnull(SUM([INTAKETEU]),0) AS [INTAKETEU]
					   ,isnull(SUM([INTAKETONS]),0) AS [INTAKETONS]
					   ,isnull(SUM([INTAKEPLUGS]),0) AS [INTAKEPLUGS]
					   ,isnull(SUM([ALLOCATIONTEU]),0) AS [ALLOCATIONTEU]
					   ,isnull(SUM([ALLOCATIONTONS]),0) AS [ALLOCATIONTONS]
					   ,isnull(SUM([ALLOCATIONPLUGS]),0) AS [ALLOCATIONPLUGS]
					   ,isnull(SUM([TOTALEMPTYTEU]),0) AS [TOTALEMPTYTEU]
					   ,isnull(SUM([TOTALCOMMITFILINGSTEU]),0) AS [TOTALCOMMITFILINGSTEU]
					   ,isnull(SUM(TOTALCOMMITCONSUMPTIONTEU),0) AS TOTALCOMMITCONSUMPTIONTEU
					   ,isnull(SUM([FREESALEALLOCATIONTEU]),0) AS [FREESALEALLOCATIONTEU]
					   ,isnull(SUM([OVERBOOKTEU]),0) AS [OVERBOOKTEU]
					   ,isnull(CAST(0 AS NUMERIC(15,4)),0) AS OVERBOOKPCT
					   ,isnull(SUM([FREESALE_AVAILABLETEU]),0) AS [FREESALE_AVAILABLETEU]
					   ,isnull(SUM([FREESALECONSUMPTIONTEU]),0) AS [FREESALECONSUMPTIONTEU]
					   ,isnull(SUM([FREESALEDISPLACEMENTTEU]),0) AS [FREESALEDISPLACEMENTTEU]
					   ,isnull(SUM([DISPLACEMENTFFE]),0) AS [DISPLACEMENTFFE]
					   ,isnull(SUM([CONSUMPTIONDISPLACEMENTTEU]),0) AS [CONSUMPTIONDISPLACEMENTTEU]
					   ,isnull(SUM([REMAINING_FREESALEDISPLACEMENTTEU]),0) AS [REMAINING_FREESALEDISPLACEMENTTEU]
					   ,isnull(SUM([REMAINING_FREESALETEU]),0) AS [REMAINING_FREESALETEU]
					   ,isnull(SUM([REMAINING_FREESALEDISPLACEMENTNOOVERBOOKTEU]),0) AS [REMAINING_FREESALEDISPLACEMENTNOOVERBOOKTEU]
					   ,isnull(SUM([REMAINING_FREESALENOOVERBOOKTEU]),0) AS [REMAINING_FREESALENOOVERBOOKTEU]
					   ,isnull(SUM([REMAINING_FREESALEDISPLACEMENTFFE]),0) AS [REMAINING_FREESALEDISPLACEMENTFFE]
					   ,isnull(SUM([REMAINING_FREESALEFFE]),0) AS [REMAINING_FREESALEFFE]
					   ,isnull(SUM([TOTALEMPTYTONS]),0) AS [TOTALEMPTYTONS]
					   ,isnull(SUM([TOTALCOMMITFILINGSTONS]),0) AS [TOTALCOMMITFILINGSTONS]
					   ,isnull(SUM(TOTALCOMMITCONSUMPTIONTONS),0) AS TOTALCOMMITCONSUMPTIONTONS
					   ,isnull(SUM([FREESALEALLOCATIONTONS]),0) AS [FREESALEALLOCATIONTONS]
					   ,isnull(SUM([OVERBOOKTONS]),0) AS [OVERBOOKTONS]
					   ,isnull(SUM([FREESALE_AVAILABLETONS]),0) AS [FREESALE_AVAILABLETONS]
					   ,isnull(SUM([FREESALE_AVAILABLENOOVERBOOKTONS]),0) AS [FREESALE_AVAILABLENOOVERBOOKTONS]
					   ,isnull(SUM([FREESALECONSUMPTIONTONS]),0) AS [FREESALECONSUMPTIONTONS]
					   ,isnull(SUM([REMAINING_FREESALETONS]),0) AS [REMAINING_FREESALETONS]
					   ,isnull(SUM([REMAINING_FREESALENOOVERBOOKTONS]),0) AS [REMAINING_FREESALENOOVERBOOKTONS]
					   ,isnull(SUM([TOTALCOMMITFILINGSPLUGS]),0) AS [TOTALCOMMITFILINGSPLUGS]
					   ,isnull(SUM(TOTALCOMMITCONSUMPTIONPLUGS),0) AS TOTALCOMMITCONSUMPTIONPLUGS
					   ,isnull(SUM([FREESALEALLOCATIONPLUGS]),0) AS [FREESALEALLOCATIONPLUGS]
					   ,isnull(SUM([OVERBOOKPLUGS]),0) AS [OVERBOOKPLUGS]
					   ,isnull(SUM([FREESALE_AVAILABLEPLUGS]),0) AS [FREESALE_AVAILABLEPLUGS]
					   ,isnull(SUM([FREESALE_AVAILABLENOOVERBOOKPLUGS]),0) AS [FREESALE_AVAILABLENOOVERBOOKPLUGS]
					   ,isnull(SUM([FREESALECONSUMPTIONPLUGS]),0) AS [FREESALECONSUMPTIONPLUGS]
					   ,isnull(SUM([REMAINING_FREESALEPLUGS]),0) AS [REMAINING_FREESALEPLUGS]
					   ,isnull(SUM([REMAINING_FREESALENOOVERBOOKPLUGS]),0) AS [REMAINING_FREESALENOOVERBOOKPLUGS]
					   ,CAST('LEAD' AS VARCHAR(10)) AS [ISC]
			FROM ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT (NOLOCK)
			WHERE RUNDATE BETWEEN DATEADD(DAY,-@V_UI_RUNDATE_FCST_LOOKBACK,@V_RUNDATE) AND @V_RUNDATE
			GROUP BY [RUNID]
					   ,[RUNDATE]
					   ,[VOYAGE]
					   ,[VESSELCODE]
					   ,[SERVICECODE]
					   ,[LEGSEQID]
					   ,[SERVICECODEDIRECTION]
					   ,[DEPARTUREPORT]
					   ,[ARRIVALPORT]
					   ,[VESSELOPERATOR]
		),
		SUMDATA AS
		(
			SELECT ROW_NUMBER() OVER(ORDER BY VOYAGE) AS ID
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
					   ,TOTALCOMMITCONSUMPTIONTEU
					   ,[FREESALEALLOCATIONTEU]
					   ,analyticsdatamart.dbo.udf_greatest([OVERBOOKTEU],0) as [OVERBOOKTEU]
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
					   ,TOTALCOMMITCONSUMPTIONTONS
					   ,[FREESALEALLOCATIONTONS]
					   ,analyticsdatamart.dbo.udf_greatest([OVERBOOKTONS],0) AS [OVERBOOKTONS]
					   ,[FREESALE_AVAILABLETONS]
					   ,[FREESALE_AVAILABLENOOVERBOOKTONS]
					   ,[FREESALECONSUMPTIONTONS]
					   ,[REMAINING_FREESALETONS]
					   ,[REMAINING_FREESALENOOVERBOOKTONS]
					   ,[TOTALCOMMITFILINGSPLUGS]
					   ,TOTALCOMMITCONSUMPTIONPLUGS
					   ,[FREESALEALLOCATIONPLUGS]
					   ,analyticsdatamart.dbo.udf_greatest([OVERBOOKPLUGS],0) AS [OVERBOOKPLUGS]
					   ,[FREESALE_AVAILABLEPLUGS]
					   ,[FREESALE_AVAILABLENOOVERBOOKPLUGS]
					   ,[FREESALECONSUMPTIONPLUGS]
					   ,[REMAINING_FREESALEPLUGS]
					   ,[REMAINING_FREESALENOOVERBOOKPLUGS]
					   ,[ISC]
				FROM UI_AGG_DATA
		)
		SELECT
				   A.ID, A.RUNID, A.RUNDATE, A.VESSELCODE AS VESSEL,A.VOYAGE, A.SERVICECODE AS SERVICE, A.SERVICECODEDIRECTION AS [SERVICE CODE DIRECTION],
				LEFT(A.DEPARTUREPORT, 5) AS [DEPARTURE PORTCALL],PC1.SITENAME AS [DEPARTURE PORTCITY], LEFT(A.ARRIVALPORT, 5) AS [ARRIVAL PORTCALL],PC2.SITENAME AS [ARRIVAL PORTCITY],
					  A.LEGSEQID, CAST(A.DEPARTUREDATE AS DATE) AS DEPARTURE, DT.INT_YEARWEEK AS WEEK_OF_YEAR,
				CAST(A.ARRIVALDATE AS DATE) AS ARRIVAL, A.ALLOCATIONTEU AS [MSK ALLOCATION TEU], A.ALLOCATIONTONS AS [MSK ALLOCATION MTS],
				A.ALLOCATIONPLUGS AS [MSK ALLOCATION PLUGS], CAST(ROUND(A.TOTALEMPTYTEU, 0) AS INT) AS [EMPTY ALLOCATION TEU], CAST(ROUND(A.TOTALEMPTYTONS, 0) AS INT)
				AS [EMPTY ALLOCATION MTS]
				, CAST(A.TOTALCOMMITFILINGSTEU AS INT) AS [COMMITMENT ALLOCATION TEU]
				, CAST(ROUND(A.TOTALCOMMITFILINGSTONS, 0) AS INT) AS [COMMITMENT ALLOCATION MTS]
				, CAST(A.TOTALCOMMITFILINGSPLUGS AS INT) AS [COMMITMENT ALLOCATION PLUGS]
				, CAST(A.TOTALCOMMITCONSUMPTIONTEU AS INT)	AS [COMMITMENT CONSUMPTION TEU]
				, CAST(ROUND(A.TOTALCOMMITCONSUMPTIONTONS, 0) AS INT) AS [COMMITMENT CONSUMPTION MTS]
				, CAST(A.TOTALCOMMITCONSUMPTIONPLUGS AS INT) AS [COMMITMENT CONSUMPTION PLUGS]
				, CAST(A.FREESALEALLOCATIONTEU AS INT) AS [FREESALE AVAILABLE TEU - BEFORE OVERBOOKING]
				, CAST(ROUND(A.FREESALE_AVAILABLENOOVERBOOKTONS, 0) AS INT) AS [FREESALE AVAILABLE MTS - BEFORE OVERBOOKING], CAST(A.FREESALE_AVAILABLENOOVERBOOKPLUGS AS INT)
				AS [FREESALE AVAILABLE PLUGS - BEFORE OVERBOOKING], CAST(A.FREESALE_AVAILABLETEU AS INT) AS [FREESALE AVAILABLE TEU - INCL.  OVERBOOKING],
				CAST(ROUND(A.FREESALE_AVAILABLETONS, 0) AS INT) AS [FREESALE AVAILABLE MTS - INCL.  OVERBOOKING], CAST(A.FREESALE_AVAILABLEPLUGS AS INT)
				AS [FREESALE AVAILABLE PLUGS - INCL.  OVERBOOKING], CAST(A.FREESALECONSUMPTIONTEU AS INT) AS [FREESALE CONSUMPTION TEU], CAST(A.FREESALEDISPLACEMENTTEU AS INT)
				AS [OOG DISPLACEMENT TEU], CAST(A.CONSUMPTIONDISPLACEMENTTEU AS INT) AS [FREESALE CONSUMPTION AND DISPLACEMENT TEU TOTAL],
				CAST(ROUND(A.FREESALECONSUMPTIONTONS, 0) AS INT) AS [FREESALE CONSUMPTION MTS], CAST(A.FREESALECONSUMPTIONPLUGS AS INT) AS [FREESALE CONSUMPTION PLUGS],
				CAST(A.REMAINING_FREESALETEU AS INT) AS [REMAINING CAPACITY TEU - BEFORE OOG DISPLACEMENT], CAST(A.REMAINING_FREESALEDISPLACEMENTTEU AS INT)
				AS [REMAINING CAPACITY TEU - INCL. OOG DISPLACEMENT], CAST(ROUND(A.REMAINING_FREESALETONS, 0) AS INT) AS [REMAINING CAPACITY MTS],
				CAST(A.REMAINING_FREESALEPLUGS AS INT) AS [REMAINING CAPACITY PLUGS], ISC AS [ISC INDICATOR (LEAD TRADE / ISC1)],
				SVC.SERVICENAME, VSL.VESSELNAME
		INTO CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_AGG_FREESALE_UBOAT 
		FROM   SUMDATA A
			   INNER JOIN  ANALYTICSDATAMART.DBO.DIM_DATE AS DT (NOLOCK)
		ON
			   CAST(A.DEPARTUREDATE AS DATE) = CAST(DT.DATE AS DATE)
		INNER JOIN ANALYTICSDATAMART.DBO.DIM_SERVICE SVC (NOLOCK)
		ON
			   A.SERVICECODE = SVC.SERVICECD
		LEFT OUTER JOIN ANALYTICSDATAMART.DBO.VWVESSELS VSL
		ON
			   A.VESSELCODE = VSL.VESSELCODE
		LEFT OUTER JOIN ANALYTICSDATAMART.DBO.VWPORTCITIES PC1
		ON
			   A.DEPARTUREPORT = PC1.SITE_CD
		LEFT OUTER JOIN ANALYTICSDATAMART.DBO.VWPORTCITIES PC2
		ON
			   A.ARRIVALPORT = PC2.SITE_CD
		WHERE
			   LEFT(A.DEPARTUREPORT, 5) <> LEFT(A.ARRIVALPORT,5) AND A.SERVICECODEDIRECTION IS NOT NULL
		OPTION (MAXDOP 8);

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
		SET @V_STEP_NAME = 'REFRESH TUBE MAP DATA TABLE'
		SET @V_NOTE = 'REFRESH THE TUBE MAP DATA TABLE AT THE ISC=LEAD LEVEL'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

			TRUNCATE TABLE ANALYTICSDATAMART.[DBO].[CAPINV_UI_AGG_FREESALE_UBOAT];

			INSERT INTO ANALYTICSDATAMART.[DBO].[CAPINV_UI_AGG_FREESALE_UBOAT]
					   ([ID]
					   ,[RUNID]
					   ,[RUNDATE]
					   ,[VESSEL]
					   ,[VOYAGE]
					   ,[SERVICE]
					   ,[SERVICE CODE DIRECTION]
					   ,[DEPARTURE PORTCALL]
					   ,[DEPARTURE PORTCITY]
					   ,[ARRIVAL PORTCALL]
					   ,[ARRIVAL PORTCITY]
					   ,[LEGSEQID]
					   ,[DEPARTURE]
					   ,[WEEK_OF_YEAR]
					   ,[ARRIVAL]
					   ,[MSK ALLOCATION TEU]
					   ,[MSK ALLOCATION MTS]
					   ,[MSK ALLOCATION PLUGS]
					   ,[EMPTY ALLOCATION TEU]
					   ,[EMPTY ALLOCATION MTS]
					   ,[COMMITMENT ALLOCATION TEU]
					   ,[COMMITMENT ALLOCATION MTS]
					   ,[COMMITMENT ALLOCATION PLUGS]
					   ,[COMMITMENT CONSUMPTION TEU]
					   ,[COMMITMENT CONSUMPTION MTS]
					   ,[COMMITMENT CONSUMPTION PLUGS]
					   ,[FREESALE AVAILABLE TEU - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE MTS - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE PLUGS - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE TEU - INCL.  OVERBOOKING]
					   ,[FREESALE AVAILABLE MTS - INCL.  OVERBOOKING]
					   ,[FREESALE AVAILABLE PLUGS - INCL.  OVERBOOKING]
					   ,[FREESALE CONSUMPTION TEU]
					   ,[OOG DISPLACEMENT TEU]
					   ,[FREESALE CONSUMPTION AND DISPLACEMENT TEU TOTAL]
					   ,[FREESALE CONSUMPTION MTS]
					   ,[FREESALE CONSUMPTION PLUGS]
					   ,[REMAINING CAPACITY TEU - BEFORE OOG DISPLACEMENT]
					   ,[REMAINING CAPACITY TEU - INCL. OOG DISPLACEMENT]
					   ,[REMAINING CAPACITY MTS]
					   ,[REMAINING CAPACITY PLUGS]
					   ,[ISC INDICATOR (LEAD TRADE / ISC1)]
					   ,[SERVICENAME]
					   ,[VESSELNAME])
			SELECT		[ID]
					   ,[RUNID]
					   ,[RUNDATE]
					   ,[VESSEL]
					   ,[VOYAGE]
					   ,[SERVICE]
					   ,[SERVICE CODE DIRECTION]
					   ,[DEPARTURE PORTCALL]
					   ,[DEPARTURE PORTCITY]
					   ,[ARRIVAL PORTCALL]
					   ,[ARRIVAL PORTCITY]
					   ,[LEGSEQID]
					   ,[DEPARTURE]
					   ,[WEEK_OF_YEAR]
					   ,[ARRIVAL]
					   ,[MSK ALLOCATION TEU]
					   ,[MSK ALLOCATION MTS]
					   ,[MSK ALLOCATION PLUGS]
					   ,[EMPTY ALLOCATION TEU]
					   ,[EMPTY ALLOCATION MTS]
					   ,[COMMITMENT ALLOCATION TEU]
					   ,[COMMITMENT ALLOCATION MTS]
					   ,[COMMITMENT ALLOCATION PLUGS]
					   ,[COMMITMENT CONSUMPTION TEU]
					   ,[COMMITMENT CONSUMPTION MTS]
					   ,[COMMITMENT CONSUMPTION PLUGS]
					   ,[FREESALE AVAILABLE TEU - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE MTS - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE PLUGS - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE TEU - INCL.  OVERBOOKING]
					   ,[FREESALE AVAILABLE MTS - INCL.  OVERBOOKING]
					   ,[FREESALE AVAILABLE PLUGS - INCL.  OVERBOOKING]
					   ,[FREESALE CONSUMPTION TEU]
					   ,[OOG DISPLACEMENT TEU]
					   ,[FREESALE CONSUMPTION AND DISPLACEMENT TEU TOTAL]
					   ,[FREESALE CONSUMPTION MTS]
					   ,[FREESALE CONSUMPTION PLUGS]
					   ,[REMAINING CAPACITY TEU - BEFORE OOG DISPLACEMENT]
					   ,[REMAINING CAPACITY TEU - INCL. OOG DISPLACEMENT]
					   ,[REMAINING CAPACITY MTS]
					   ,[REMAINING CAPACITY PLUGS]
					   ,[ISC INDICATOR (LEAD TRADE / ISC1)]
					   ,[SERVICENAME]
					   ,[VESSELNAME]
		FROM CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_AGG_FREESALE_UBOAT (NOLOCK)
		OPTION (MAXDOP 8);

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

		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'BUILD UI ISC LEVEL DATA TABLE'
		SET @V_NOTE = 'BUILD THE ISC LEVEL DATA TABLE AT THE ISC LEVEL WITH MOST RECNT RUN DATA'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		IF OBJECT_ID('CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_FREESALE_UBOAT_CURRENT', 'U') IS NOT NULL
		  DROP TABLE CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_FREESALE_UBOAT_CURRENT;

		WITH AGG_DATA AS 
		(
			SELECT ID
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
					   ,TOTALCOMMITCONSUMPTIONTEU
					   ,[FREESALEALLOCATIONTEU]
					   ,analyticsdatamart.dbo.udf_greatest([OVERBOOKTEU],0) AS [OVERBOOKTEU]
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
					   ,TOTALCOMMITCONSUMPTIONTONS
					   ,[FREESALEALLOCATIONTONS]
					   ,analyticsdatamart.dbo.udf_greatest([OVERBOOKTONS],0) AS [OVERBOOKTONS]
					   ,[FREESALE_AVAILABLETONS]
					   ,[FREESALE_AVAILABLENOOVERBOOKTONS]
					   ,[FREESALECONSUMPTIONTONS]
					   ,[REMAINING_FREESALETONS]
					   ,[REMAINING_FREESALENOOVERBOOKTONS]
					   ,[TOTALCOMMITFILINGSPLUGS]
					   ,TOTALCOMMITCONSUMPTIONPLUGS
					   ,[FREESALEALLOCATIONPLUGS]
					   ,analyticsdatamart.dbo.udf_greatest([OVERBOOKPLUGS],0) AS [OVERBOOKPLUGS]
					   ,[FREESALE_AVAILABLEPLUGS]
					   ,[FREESALE_AVAILABLENOOVERBOOKPLUGS]
					   ,[FREESALECONSUMPTIONPLUGS]
					   ,[REMAINING_FREESALEPLUGS]
					   ,[REMAINING_FREESALENOOVERBOOKPLUGS]
					   ,[ISC]
			FROM ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT (NOLOCK)
			WHERE RUNDATE = @V_RUNDATE
		)
		SELECT
				   A.ID, A.RUNID, A.RUNDATE, A.VESSELCODE AS VESSEL,A.VOYAGE, A.SERVICECODE AS SERVICE, A.SERVICECODEDIRECTION AS [SERVICE CODE DIRECTION],
				LEFT(A.DEPARTUREPORT, 5) AS [DEPARTURE PORTCALL],PC1.SITENAME AS [DEPARTURE PORTCITY], LEFT(A.ARRIVALPORT, 5) AS [ARRIVAL PORTCALL],PC2.SITENAME AS [ARRIVAL PORTCITY],
					  A.LEGSEQID, CAST(A.DEPARTUREDATE AS DATE) AS DEPARTURE, DT.INT_YEARWEEK AS WEEK_OF_YEAR,
				CAST(A.ARRIVALDATE AS DATE) AS ARRIVAL, A.ALLOCATIONTEU AS [MSK ALLOCATION TEU], A.ALLOCATIONTONS AS [MSK ALLOCATION MTS],
				A.ALLOCATIONPLUGS AS [MSK ALLOCATION PLUGS], CAST(ROUND(A.TOTALEMPTYTEU, 0) AS INT) AS [EMPTY ALLOCATION TEU], CAST(ROUND(A.TOTALEMPTYTONS, 0) AS INT)
				AS [EMPTY ALLOCATION MTS]
				, CAST(A.TOTALCOMMITFILINGSTEU AS INT) AS [COMMITMENT ALLOCATION TEU]
				, CAST(ROUND(A.TOTALCOMMITFILINGSTONS, 0) AS INT) AS [COMMITMENT ALLOCATION MTS]
				, CAST(A.TOTALCOMMITFILINGSPLUGS AS INT) AS [COMMITMENT ALLOCATION PLUGS]
				, CAST(A.TOTALCOMMITCONSUMPTIONTEU AS INT)	AS [COMMITMENT CONSUMPTION TEU]
				, CAST(ROUND(A.TOTALCOMMITCONSUMPTIONTONS, 0) AS INT) AS [COMMITMENT CONSUMPTION MTS]
				, CAST(A.TOTALCOMMITCONSUMPTIONPLUGS AS INT) AS [COMMITMENT CONSUMPTION PLUGS]
				, CAST(A.FREESALEALLOCATIONTEU AS INT) AS [FREESALE AVAILABLE TEU - BEFORE OVERBOOKING],
				CAST(ROUND(A.FREESALE_AVAILABLENOOVERBOOKTONS, 0) AS INT) AS [FREESALE AVAILABLE MTS - BEFORE OVERBOOKING], CAST(A.FREESALE_AVAILABLENOOVERBOOKPLUGS AS INT)
				AS [FREESALE AVAILABLE PLUGS - BEFORE OVERBOOKING], CAST(A.FREESALE_AVAILABLETEU AS INT) AS [FREESALE AVAILABLE TEU - INCL.  OVERBOOKING],
				CAST(ROUND(A.FREESALE_AVAILABLETONS, 0) AS INT) AS [FREESALE AVAILABLE MTS - INCL.  OVERBOOKING], CAST(A.FREESALE_AVAILABLEPLUGS AS INT)
				AS [FREESALE AVAILABLE PLUGS - INCL.  OVERBOOKING], CAST(A.FREESALECONSUMPTIONTEU AS INT) AS [FREESALE CONSUMPTION TEU], CAST(A.FREESALEDISPLACEMENTTEU AS INT)
				AS [OOG DISPLACEMENT TEU], CAST(A.CONSUMPTIONDISPLACEMENTTEU AS INT) AS [FREESALE CONSUMPTION AND DISPLACEMENT TEU TOTAL],
				CAST(ROUND(A.FREESALECONSUMPTIONTONS, 0) AS INT) AS [FREESALE CONSUMPTION MTS], CAST(A.FREESALECONSUMPTIONPLUGS AS INT) AS [FREESALE CONSUMPTION PLUGS],
				CAST(A.REMAINING_FREESALETEU AS INT) AS [REMAINING CAPACITY TEU - BEFORE OOG DISPLACEMENT], CAST(A.REMAINING_FREESALEDISPLACEMENTTEU AS INT)
				AS [REMAINING CAPACITY TEU - INCL. OOG DISPLACEMENT], CAST(ROUND(A.REMAINING_FREESALETONS, 0) AS INT) AS [REMAINING CAPACITY MTS],
				CAST(A.REMAINING_FREESALEPLUGS AS INT) AS [REMAINING CAPACITY PLUGS], ISC AS [ISC INDICATOR (LEAD TRADE / ISC1)],
				SVC.SERVICENAME, VSL.VESSELNAME
		INTO CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_FREESALE_UBOAT_CURRENT
		FROM          
			   AGG_DATA A
			   INNER JOIN  ANALYTICSDATAMART.DBO.DIM_DATE AS DT (NOLOCK)
		ON
			   CAST(A.DEPARTUREDATE AS DATE) = CAST(DT.DATE AS DATE)
		INNER JOIN ANALYTICSDATAMART.DBO.DIM_SERVICE SVC (NOLOCK)
		ON
			   A.SERVICECODE = SVC.SERVICECD
		LEFT OUTER JOIN ANALYTICSDATAMART.DBO.VWVESSELS VSL
		ON
			   A.VESSELCODE = VSL.VESSELCODE
		LEFT OUTER JOIN ANALYTICSDATAMART.DBO.VWPORTCITIES PC1
		ON
			   A.DEPARTUREPORT = PC1.SITE_CD
		LEFT OUTER JOIN ANALYTICSDATAMART.DBO.VWPORTCITIES PC2
		ON
			   A.ARRIVALPORT = PC2.SITE_CD
		WHERE
			   LEFT(A.DEPARTUREPORT, 5) <> LEFT(A.ARRIVALPORT,5) AND A.SERVICECODEDIRECTION IS NOT NULL
		OPTION (MAXDOP 8);

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


		SET @V_STEP_ID = 25
		SET @V_STEP_NAME = 'REFRESH UI ISC LEVEL DATA TABLE'
		SET @V_NOTE = 'REFRESH THE ISC LEVEL DATA TABLE AT THE ISC LEVEL WITH MOST RECNT RUN DATA'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

			TRUNCATE TABLE ANALYTICSDATAMART.[DBO].CAPINV_UI_FREESALE_UBOAT_CURRENT;

			INSERT INTO ANALYTICSDATAMART.[DBO].CAPINV_UI_FREESALE_UBOAT_CURRENT
					   ([ID]
					   ,[RUNID]
					   ,[RUNDATE]
					   ,[VESSEL]
					   ,[VOYAGE]
					   ,[SERVICE]
					   ,[SERVICE CODE DIRECTION]
					   ,[DEPARTURE PORTCALL]
					   ,[DEPARTURE PORTCITY]
					   ,[ARRIVAL PORTCALL]
					   ,[ARRIVAL PORTCITY]
					   ,[LEGSEQID]
					   ,[DEPARTURE]
					   ,[WEEK_OF_YEAR]
					   ,[ARRIVAL]
					   ,[MSK ALLOCATION TEU]
					   ,[MSK ALLOCATION MTS]
					   ,[MSK ALLOCATION PLUGS]
					   ,[EMPTY ALLOCATION TEU]
					   ,[EMPTY ALLOCATION MTS]
					   ,[COMMITMENT ALLOCATION TEU]
					   ,[COMMITMENT ALLOCATION MTS]
					   ,[COMMITMENT ALLOCATION PLUGS]
					   ,[COMMITMENT CONSUMPTION TEU]
					   ,[COMMITMENT CONSUMPTION MTS]
					   ,[COMMITMENT CONSUMPTION PLUGS]
					   ,[FREESALE AVAILABLE TEU - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE MTS - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE PLUGS - BEFORE OVERBOOKING]
					   ,[FREESALE AVAILABLE TEU - INCL.  OVERBOOKING]
					   ,[FREESALE AVAILABLE MTS - INCL.  OVERBOOKING]
					   ,[FREESALE AVAILABLE PLUGS - INCL.  OVERBOOKING]
					   ,[FREESALE CONSUMPTION TEU]
					   ,[OOG DISPLACEMENT TEU]
					   ,[FREESALE CONSUMPTION AND DISPLACEMENT TEU TOTAL]
					   ,[FREESALE CONSUMPTION MTS]
					   ,[FREESALE CONSUMPTION PLUGS]
					   ,[REMAINING CAPACITY TEU - BEFORE OOG DISPLACEMENT]
					   ,[REMAINING CAPACITY TEU - INCL. OOG DISPLACEMENT]
					   ,[REMAINING CAPACITY MTS]
					   ,[REMAINING CAPACITY PLUGS]
					   ,[ISC INDICATOR (LEAD TRADE / ISC1)]
					   ,[SERVICENAME]
					   ,[VESSELNAME])
			SELECT  [ID]
					   ,[RUNID]
					   ,[RUNDATE]
					   ,[VESSEL]
					   ,[VOYAGE]
					   ,[SERVICE]
					   ,[SERVICE CODE DIRECTION]
					   ,[DEPARTURE PORTCALL]
					   ,[DEPARTURE PORTCITY]
					   ,[ARRIVAL PORTCALL]
					   ,[ARRIVAL PORTCITY]
					   ,[LEGSEQID]
					   ,[DEPARTURE]
					   ,[WEEK_OF_YEAR]
					   ,[ARRIVAL]
					   ,isnull([MSK ALLOCATION TEU],0)
					   ,isnull([MSK ALLOCATION MTS],0)
					   ,isnull([MSK ALLOCATION PLUGS],0)
					   ,isnull([EMPTY ALLOCATION TEU],0)
					   ,isnull([EMPTY ALLOCATION MTS],0)
					   ,isnull([COMMITMENT ALLOCATION TEU],0)
					   ,isnull([COMMITMENT ALLOCATION MTS],0)
					   ,isnull([COMMITMENT ALLOCATION PLUGS],0)
					   ,isnull([COMMITMENT CONSUMPTION TEU],0)
					   ,isnull([COMMITMENT CONSUMPTION MTS],0)
					   ,isnull([COMMITMENT CONSUMPTION PLUGS],0)
					   ,isnull([FREESALE AVAILABLE TEU - BEFORE OVERBOOKING],0)
					   ,isnull([FREESALE AVAILABLE MTS - BEFORE OVERBOOKING],0)
					   ,isnull([FREESALE AVAILABLE PLUGS - BEFORE OVERBOOKING],0)
					   ,isnull([FREESALE AVAILABLE TEU - INCL.  OVERBOOKING],0)
					   ,isnull([FREESALE AVAILABLE MTS - INCL.  OVERBOOKING],0)
					   ,isnull([FREESALE AVAILABLE PLUGS - INCL.  OVERBOOKING],0)
					   ,isnull([FREESALE CONSUMPTION TEU],0)
					   ,isnull([OOG DISPLACEMENT TEU],0)
					   ,isnull([FREESALE CONSUMPTION AND DISPLACEMENT TEU TOTAL],0)
					   ,isnull([FREESALE CONSUMPTION MTS],0)
					   ,isnull([FREESALE CONSUMPTION PLUGS],0)
					   ,isnull([REMAINING CAPACITY TEU - BEFORE OOG DISPLACEMENT],0)
					   ,isnull([REMAINING CAPACITY TEU - INCL. OOG DISPLACEMENT],0)
					   ,isnull([REMAINING CAPACITY MTS],0)
					   ,isnull([REMAINING CAPACITY PLUGS],0)
					   ,[ISC INDICATOR (LEAD TRADE / ISC1)]
					   ,[SERVICENAME]
					   ,[VESSELNAME]
		FROM CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_FREESALE_UBOAT_CURRENT (NOLOCK)
		OPTION (MAXDOP 8);

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

		IF OBJECT_ID('ANALYTICSDATAMART.DBO.CAPFCST_UI_FREESALE_UBOAT_UPTAKE', 'U') IS NOT NULL
		  DROP TABLE ANALYTICSDATAMART.DBO.CAPFCST_UI_FREESALE_UBOAT_UPTAKE;

				select nn.[ID]
					,nn.[RUNID]
					,nn.daystodeparture
					,nn.[RUNDATE]
					,nn.[VESSEL]
					,nn.[VOYAGE]
					,nn.[SERVICE]
					,nn.[SERVICE CODE DIRECTION]
					,nn.[DEPARTURE PORTCALL]
					,nn.[DEPARTURE PORTCITY]
					,nn.[ARRIVAL PORTCALL]
					,nn.[ARRIVAL PORTCITY]
					,nn.[LEGSEQID]
					,nn.[DEPARTURE]
					,nn.[WEEK_OF_YEAR]
					,nn.[ARRIVAL]
					,nn.[MSK ALLOCATION TEU]
					,nn.[MSK ALLOCATION MTS]
					,nn.[MSK ALLOCATION PLUGS]
					,nn.[EMPTY ALLOCATION TEU]
					,nn.[EMPTY ALLOCATION MTS]
					,nn.[COMMITMENT ALLOCATION TEU]
					,nn.[COMMITMENT ALLOCATION MTS]
					,nn.[COMMITMENT ALLOCATION PLUGS]
					,nn.[COMMITMENT CONSUMPTION TEU]
					,nn.[COMMITMENT CONSUMPTION MTS]
					,nn.[COMMITMENT CONSUMPTION PLUGS]
					,nn.[FREESALE AVAILABLE TEU - BEFORE OVERBOOKING]
					,nn.[FREESALE AVAILABLE MTS - BEFORE OVERBOOKING]
					,nn.[FREESALE AVAILABLE PLUGS - BEFORE OVERBOOKING]
					,nn.[FREESALE AVAILABLE TEU - INCL.  OVERBOOKING]
					,nn.[FREESALE AVAILABLE MTS - INCL.  OVERBOOKING]
					,nn.[FREESALE AVAILABLE PLUGS - INCL.  OVERBOOKING]
					,nn.[FREESALE CONSUMPTION TEU]
					,nn.[OOG DISPLACEMENT TEU]
					,nn.[FREESALE CONSUMPTION AND DISPLACEMENT TEU TOTAL]
					,nn.[FREESALE CONSUMPTION MTS]
					,nn.[FREESALE CONSUMPTION PLUGS]
					,nn.[REMAINING CAPACITY TEU - BEFORE OOG DISPLACEMENT]
					,nn.[REMAINING CAPACITY TEU - INCL. OOG DISPLACEMENT]
					,nn.[REMAINING CAPACITY MTS]
					,nn.[REMAINING CAPACITY PLUGS]
					,nn.[ISC INDICATOR (LEAD TRADE / ISC1)]
					,nn.[SERVICENAME]
					,nn.[VESSELNAME]
			into ANALYTICSDATAMART.DBO.CAPFCST_UI_FREESALE_UBOAT_UPTAKE
			from analyticsdatamart.dbo.vw_AD_CAPFCST_FREESALE_UBOAT nn

			create clustered index cdx_CAPFCST_UI_FREESALE_UBOAT_UPTAKE on ANALYTICSDATAMART.DBO.CAPFCST_UI_FREESALE_UBOAT_UPTAKE(vessel,voyage,service)

		--CLEAN UP
		IF OBJECT_ID('CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_AGG_FREESALE_UBOAT', 'U') IS NOT NULL
		  DROP TABLE CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_AGG_FREESALE_UBOAT;

		IF OBJECT_ID('CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_FREESALE_UBOAT_CURRENT', 'U') IS NOT NULL
		  DROP TABLE CAPINVREPOSITORY.DBO.TMP_CAPINV_UI_FREESALE_UBOAT_CURRENT;

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


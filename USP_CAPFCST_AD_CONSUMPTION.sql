USE [CapInvRepository]
GO

/****** Object:  StoredProcedure [dbo].[USP_CAPFCST_AD_CONSUMPTION]    Script Date: 28-12-2017 15:14:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[USP_CAPFCST_AD_CONSUMPTION]
/****************************************************************************************************
* COPYRIGHT REVENUE ANALYTICS 2017
* ALL RIGHTS RESERVED
*
* CREATED BY: DATA ENGINEERING
* FILENAME:   USP_CAPFCST_AD_CONSUMPTION.SQL
* DATE:       04/07/2017
*
* APPLICATION:  CREATES ANALYSIS DATA SET FOR CONSUMPTION DATA
*               
* PARAMETERS:   @V_PARENT_PROCESS_ID == PARENT OR CALLING PROCESS ID
*				@V_ERROR_CODE		== RETURNED ERROR CODE
*  				
* ASSUMPTIONS: BOOKING_FINAL, ROUTELINKS AND SCHEDULE TABLES UPDATED
*
* INPUT TABLE(S):	ANALYTICSDATAMART.DBO.BOOKING_FINAL
*					ANALYTICSDATAMART.DBO.ROUTELINKS
*					ANALYTICSDATAMART.DBO.SCHEDULE
*					ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE
*					ANALYTICSDATAMART.DBO.BOOKINGCOMMITMENT
* OUTPUT TABLE(S):	ANALYTICSDATAMART.DBO.CAPFCST_AD_CONSUMPTION
*
* PARAMETERS:   @V_RUNDATE = DATE OF THE RUN
*				@V_SERVICE == SERVICE TO RUN
*				@V_PARENT_PROCESS_ID == PARENT OR CALLING PROCESS ID
*				@V_ERROR_CODE		== RETURNED ERROR CODE
*
* EXAMPLE CALL: DECLARE	@RETURN_VALUE INT,@V_ERROR_CODE INT
*
*				EXEC	@RETURN_VALUE = [DBO].[USP_CAPFCST_AD_CONSUMPTION]
*						@V_RUNDATE = '2017-04-01',
						@V_SERVICE = '84K',
						@V_PARENT_PROCESS_ID = 0,
*						@V_ERROR_CODE = @V_ERROR_CODE OUTPUT
*
*****************************************************************************************************
* NOTES:
*  NAME					CREATED        LAST MOD			COMMENTS
*  DE\ELM               4/17/2017						PROCEDURE CREATED
*  EM									6/26/2017       ADDED CAPABILITY OF RUNNING 13 WEEKS DATA 
														(RUNDATE)    
* Modification History:Code modified to use/refer service codes from schedule rather from routelinks
* Modified on:2018-JAN-04, Modified by:PVE068														      
****************************************************************************************************/
	 @V_RUNDATE DATE = NULL
	,@V_SERVICE VARCHAR(10) = 'ALL'
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
	DECLARE @V_FFE_TEU_MULTIPLIER INT = (SELECT CAST(PARAMVALUE AS INT) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'FFE_TO_TEU_MULTIPLIER' AND PROCESSNAME = 'CAPINV')
	DECLARE @V_PLUGS_FOR_20 INT = (SELECT CAST(PARAMVALUE AS INT) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'PLUGS_FOR_20' AND PROCESSNAME = 'CAPINV')
	DECLARE @V_PLUGS_FOR_40 INT = (SELECT CAST(PARAMVALUE AS INT) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'PLUGS_FOR_40' AND PROCESSNAME = 'CAPINV')
	DECLARE @V_IS_VSA_F_FLAG VARCHAR(2) = (SELECT CAST(PARAMVALUE AS VARCHAR) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'IS_VSA_F_FLAG' AND PROCESSNAME = 'CAPINV')
	DECLARE @V_SHIPMENT_STATUS_FLAG VARCHAR(25) = (SELECT CAST(PARAMVALUE AS VARCHAR) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'SHIPMENT_STATUS_FLAG' AND PROCESSNAME = 'CAPINV')
	DECLARE @V_LOOKBACK_DAYS INT = (SELECT CAST(PARAMVALUE AS INT) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'LOOKBACK_DAYS' AND PROCESSNAME = 'CAPINV')
	DECLARE @V_LOOKFORWARD_DAYS INT = (SELECT CAST(PARAMVALUE AS INT) FROM ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] WHERE UPPER(PARAMNAME) = 'LOOKFORWARD_DAYS' AND PROCESSNAME = 'CAPINV')

	--ASSIGN TODAYS DATE IF RUNDATE IS NULL
	SET @V_RUNDATE = CAST(COALESCE(@V_RUNDATE, GETUTCDATE()) AS DATE)
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
							, @V_NOTE = 'PROCESS CONSUMPTION DATA'
							, @V_START_STEP = 1;

		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'COMBINE BOOKINGS AND ROUTE LINKS'
		SET @V_NOTE = 'COMBINE THE BOOKINGS AND THE SEGMENTS FOR THOSE BOOKINGS FROM THE ROUTELINKS TABLE'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		IF OBJECT_ID('CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP1', 'U') IS NOT NULL
		  DROP TABLE CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP1;

		SELECT L.[SHIPMENT_NO_X]
			  ,L.[SHIPMENT_VRSN_ID_X]
			  ,L.[BRAND]
			  ,L.[CONTAINER_SIZE_X]
			  ,L.[LOPFI]
			  ,L.[DIPLA]
			  ,L.[POD]
			  ,L.[POR]
			  ,L.[PRICE_CALC_BASE_LCL_D] AS PCD_DATE
			  ,L.[BOOKING_DATE]
			  ,L.[STRING_ID_X]
			  ,L.[ROUTE_CD]
			  ,L.[SHIPMENT_STATUS]
			  ,R.VESSELCODE
			  ,R.SERVICECODE
			  ,R.FROMSITECODE
			  ,R.TOSITECODE
			  ,R.LOCSEQX
			  ,R.DEPVOYAGEX
			  ,R.ARRVOYAGEX
			  ,L.ETD AS ETD
			  , CARGO_TYPE
			  ,SUM(L.[FFE]) AS FFE
			  ,AVG([GROSSWEIGHT]) AS GROSSWEIGHT
		INTO 
			CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP1
		FROM 	
			ANALYTICSDATAMART.[DBO].[BOOKING_FINAL] L (NOLOCK) 
				INNER JOIN ANALYTICSDATAMART.DBO.ROUTELINKS R (NOLOCK)
		ON 
			L.SHIPMENT_NO_X = R.SHIPMENT_NO_X
			AND L.SHIPMENT_VRSN_ID_X = R.SHIPMENT_VRSN_ID_X
		WHERE 	
			UPPER(L.IS_VSA_F) IN (@V_IS_VSA_F_FLAG)
			AND UPPER(L.SHIPMENT_STATUS) IN (@V_SHIPMENT_STATUS_FLAG)
			AND (CASE WHEN @V_SERVICE IS NULL OR UPPER(@V_SERVICE) = 'ALL' THEN '1' ELSE R.SERVICECODE END
						= CASE WHEN @V_SERVICE IS NULL OR UPPER(@V_SERVICE) = 'ALL' THEN '1' ELSE @V_SERVICE  END)
		GROUP BY L.[SHIPMENT_NO_X]
			  ,L.[SHIPMENT_VRSN_ID_X]
			  ,L.[BRAND]
			  ,L.[CONTAINER_SIZE_X]
			  ,L.[LOPFI]
			  ,L.[DIPLA]
			  ,L.[POD]
			  ,L.[POR]
			  ,L.[PRICE_CALC_BASE_LCL_D] 
			  ,L.[BOOKING_DATE]
			  ,L.[STRING_ID_X]
			  ,L.[ROUTE_CD]
			  ,L.[SHIPMENT_STATUS]
			  ,R.VESSELCODE
			  ,R.SERVICECODE
			  ,R.FROMSITECODE
			  ,R.TOSITECODE
			  ,R.LOCSEQX
			  ,R.DEPVOYAGEX
			  ,R.ARRVOYAGEX
			  ,L.ETD
			  ,CARGO_TYPE
		OPTION (MAXDOP 8)

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()
			
		--UPDATE DETAIL 
		SET @V_NOTE = @V_STEP_NAME +' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;
		---------------------------------------------------------
		--GET FIRST AND LAST LEG SEQUENCE ID FOR EACH SEGMENT
		---------------------------------------------------------
		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'GET THE LEGS INFORMATION FOR THE ROUTE'
		SET @V_NOTE = 'USING THE SCHEDULE GET THE FIRST AND LAST LEG SEQUENCE'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'USING THE SCHEDULE GET THE FIRST AND LAST LEG SEQUENCE';

		--Get the sequenceid for the FromSiteCode
		SELECT  A.VESSELCODE
				,A.DEPVOYAGEX AS DEPVOYAGE
				,A.ARRVOYAGEX AS ARRVOYAGE
				,B.SERVICECODE
				,A.FROMSITECODE
				,MIN(B.SCHEDULEID)  AS FIRSTSCHEDULEID
		INTO #TMP_MIN_SEQ
		FROM CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP1 A
		INNER JOIN ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE B
		ON A.VESSELCODE = B.VESSELCODE
		AND A.DEPVOYAGEX = B.VOYAGE
		--AND A.SERVICECODE = B.SERVICECODE
		AND LEFT(A.FROMSITECODE,5) = LEFT(B.DEPARTUREPORT,5)
		GROUP BY A.VESSELCODE
				,A.DEPVOYAGEX
				,A.ARRVOYAGEX
				,B.SERVICECODE
				,A.FROMSITECODE;

		--Get the Sequenceid of the last port in the segment			
		SELECT	GG.VESSELCODE
				,GG.DEPVOYAGE
				,GG.SERVICECODE
				,GG.FROMSITECODE
				,A.TOSITECODE
				,GG.FIRSTSCHEDULEID
				,MIN(B.SCHEDULEID) AS LASTSCHEDULEID
		INTO #TMP_ROUTE_SEQ
		FROM CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP1 A
		INNER JOIN #TMP_MIN_SEQ GG
		ON A.VESSELCODE = GG.VESSELCODE
		--AND A.SERVICECODE = GG.SERVICECODE
		AND (A.DEPVOYAGEX = GG.DEPVOYAGE)
		AND A.FROMSITECODE = GG.FROMSITECODE
		INNER JOIN ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE B
		ON A.VESSELCODE = B.VESSELCODE
		--AND A.SERVICECODE = B.SERVICECODE
		AND GG.SERVICECODE = B.SERVICECODE
		AND LEFT(A.TOSITECODE,5) = LEFT(B.ARRIVALPORT,5)
		AND B.SCHEDULEID >= GG.FIRSTSCHEDULEID
		GROUP BY GG.VESSELCODE
				,GG.DEPVOYAGE
				,GG.SERVICECODE
				,GG.FROMSITECODE
				,A.TOSITECODE
				,GG.FIRSTSCHEDULEID;

		IF OBJECT_ID('CAPINVREPOSITORY.DBO.TMPCONSUMPTION_LEGS', 'U') IS NOT NULL
			DROP TABLE CAPINVREPOSITORY.DBO.TMPCONSUMPTION_LEGS;

		SELECT 	  L.[SHIPMENT_NO_X]
				  ,L.[SHIPMENT_VRSN_ID_X]
				  ,L.[BRAND]
				  ,L.[CONTAINER_SIZE_X]
				  ,L.[FFE]
				  ,L.CARGO_TYPE
				  ,L.GROSSWEIGHT
				  ,L.[LOPFI]
				  ,L.[DIPLA]
				  ,L.[POD]
				  ,L.[POR]
				  ,L.PCD_DATE
				  ,L.[BOOKING_DATE]
				  ,L.[STRING_ID_X]
				  ,L.[ROUTE_CD]
				  ,L.[SHIPMENT_STATUS]
				  ,L.VESSELCODE
				  ,LL.SERVICECODE
				  ,L.FROMSITECODE
				  ,L.TOSITECODE
				  ,L.LOCSEQX
				  ,L.DEPVOYAGEX
				  ,L.ETD
				  ,LL.FIRSTSCHEDULEID
				  ,LL.LASTSCHEDULEID
		INTO CAPINVREPOSITORY.DBO.TMPCONSUMPTION_LEGS
		FROM CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP1 L
		INNER JOIN #TMP_ROUTE_SEQ LL
		ON L.VESSELCODE = LL.VESSELCODE
		AND L.DEPVOYAGEX = LL.DEPVOYAGE
		--AND L.SERVICECODE = LL.SERVICECODE
		AND L.FROMSITECODE = LL.FROMSITECODE
		AND L.TOSITECODE = LL.TOSITECODE;

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()
			
		--UPDATE DETAIL 
		SET @V_NOTE = @V_STEP_NAME +' COMPLETED SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;

		---------------------------------------------------------
		--ASSIGN LEGS TO EACH SEGMENT
		---------------------------------------------------------
		SET @V_STEP_ID = 30
		SET @V_STEP_NAME = 'ASSIGN LEGS TO EACH SEGMENT'
		SET @V_NOTE = 'USING THE SCHEDULE ASSIGN LEGS TO EACH ROUTE SEGMENTS'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		IF OBJECT_ID('CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP2', 'U') IS NOT NULL
			DROP TABLE CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP2;

		SELECT  L.[SHIPMENT_NO_X]
				,L.[SHIPMENT_VRSN_ID_X]
				,L.[BRAND]
				,L.[CONTAINER_SIZE_X]
				,L.[FFE]
				,L.CARGO_TYPE
				,L.GROSSWEIGHT
				,L.[LOPFI]
				,L.[DIPLA]
				,L.[POD]
				,L.[POR]
				,L.PCD_DATE
				,L.[BOOKING_DATE]
				,L.[STRING_ID_X]
				,L.[ROUTE_CD]
				,L.[SHIPMENT_STATUS]
				,L.VESSELCODE
				,L.SERVICECODE
				,L.FROMSITECODE
				,L.TOSITECODE
				,L.LOCSEQX
				,R.VOYAGE AS VOYAGE
				,R.ARRVOYAGE
				,L.ETD
				,R.SCHEDULEID
				,R.DEPARTUREPORT
				,R.ARRIVALPORT
				,R.ARRIVALDATE
				,R.LEGSEQID
				,R.[ORIGINAL_ETD]
				,R.[ACTUAL_ETD]
				,R.SERVICECODEDIRECTION
				,R.NEXTDEPVOYAGE
		INTO CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP2
		FROM CAPINVREPOSITORY.DBO.TMPCONSUMPTION_LEGS L 
		INNER JOIN ANALYTICSDATAMART.DBO.ROUTELEGS_SCHEDULE R 
		ON ISNULL(LTRIM(RTRIM(L.SERVICECODE)),0) = ISNULL(LTRIM(RTRIM(R.SERVICECODE)),0)
			AND ISNULL(LTRIM(RTRIM(L.VESSELCODE)),0) = ISNULL(LTRIM(RTRIM(R.VESSELCODE)),0)
				AND R.SCHEDULEID BETWEEN L.FIRSTSCHEDULEID AND L.LASTSCHEDULEID;

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()

		CREATE CLUSTERED INDEX CDX_TMPCON ON CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP2(SHIPMENT_NO_X,CARGO_TYPE,CONTAINER_SIZE_X)
			
		--UPDATE DETAIL 
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

		---------------------------------------------------------
		--THIS FINAL STEP INCORPORATES THE FREESALE FLAG BASED ON COMMITMENT DATA
		---------------------------------------------------------
		SET @V_STEP_ID = 40
		SET @V_STEP_NAME = 'BUILD CONSUMPTION ANALYSIS DATA SET'
		SET @V_NOTE = 'ADD THE FREESALE FLAG AND CREATE THE ANALYSIS DATASET'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		IF OBJECT_ID('ANALYTICSDATAMART.DBO.BOOKINGCOMMITMENT_CLEAN', 'U') IS NOT NULL
		  DROP TABLE ANALYTICSDATAMART.DBO.BOOKINGCOMMITMENT_CLEAN;
				
		SELECT DISTINCT SHIPMENT_NO_X,CARGO_TYPE,CONTAINER_SIZE_X
		INTO ANALYTICSDATAMART.DBO.BOOKINGCOMMITMENT_CLEAN
		FROM ANALYTICSDATAMART.DBO.BOOKINGCOMMITMENT
		OPTION (MAXDOP 8);
		
		IF OBJECT_ID('ANALYTICSDATAMART.DBO.CAPFCST_AD_CONSUMPTION', 'U') IS NOT NULL
		  DROP TABLE ANALYTICSDATAMART.DBO.CAPFCST_AD_CONSUMPTION;
		  
		SELECT DISTINCT L.SHIPMENT_NO_X
			,L.SHIPMENT_VRSN_ID_X
			,L.BOOKING_DATE
			,L.ROUTE_CD
			,L.SERVICECODE
			,L.STRING_ID_X
			,L.VESSELCODE AS VESSEL
			,L.VOYAGE
			,L.ARRVOYAGE
			,L.LEGSEQID
			,L.SERVICECODEDIRECTION
			,L.CONTAINER_SIZE_X
			,L.CARGO_TYPE
			,L.LOPFI
			,L.DIPLA
			,L.FROMSITECODE
			,L.TOSITECODE
			,L.SCHEDULEID
			,LTRIM(RTRIM(L.DEPARTUREPORT)) AS FROMLEGSITECODE
			,L.ARRIVALPORT AS TOLEGSITECODE
			,COALESCE(L.ORIGINAL_ETD,L.ETD) AS DEPARTUREDATE
			,L.ETD
			,L.ARRIVALDATE
			,L.FFE * @V_FFE_TEU_MULTIPLIER AS TEU
			,L.GROSSWEIGHT
			,CASE WHEN UPPER(L.CARGO_TYPE) = 'REEF' AND L.CONTAINER_SIZE_X = 20 THEN @V_PLUGS_FOR_20
				 WHEN UPPER(L.CARGO_TYPE) = 'REEF' AND L.CONTAINER_SIZE_X = 40 THEN @V_PLUGS_FOR_40
				 ELSE 0
			END AS PLUGS
			,CASE WHEN L.CONTAINER_SIZE_X = 20 THEN FFE * @V_FFE_TEU_MULTIPLIER
				 WHEN L.CONTAINER_SIZE_X = 40 THEN FFE
				 ELSE FFE
			END AS CONTAINERCOUNT
			,CAST(CASE WHEN R.CONTAINER_SIZE_X IS NOT NULL THEN 0 ELSE 1 END AS TINYINT) AS ISFREESALE
			,NEXTDEPVOYAGE
			,DT.INT_ISO_YEARWEEK
			,DT.CHAR_ISO_YEARWEEK
		INTO 
			ANALYTICSDATAMART.DBO.CAPFCST_AD_CONSUMPTION 
			FROM CAPINVREPOSITORY.DBO.TMPCONSUMPTIONSTEP2 L (NOLOCK)
			INNER JOIN ANALYTICSDATAMART.DBO.DIM_DATE DT
			ON CAST(COALESCE(L.ORIGINAL_ETD,L.ETD) AS DATE) = CAST(DT.DATE AS DATE)
		LEFT OUTER JOIN ANALYTICSDATAMART.DBO.BOOKINGCOMMITMENT_CLEAN R (NOLOCK)
		ON 
			L.SHIPMENT_NO_X = R.SHIPMENT_NO_X
			AND L.CARGO_TYPE = R.CARGO_TYPE
			AND L.CONTAINER_SIZE_X = R.CONTAINER_SIZE_X
		OPTION (MAXDOP 8);

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()
			
		--UPDATE DETAIL 
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

			CREATE CLUSTERED INDEX CDX_CAPFCST_AD_CONSUMPTION ON ANALYTICSDATAMART.DBO.CAPFCST_AD_CONSUMPTION(ETD,VESSEL,VOYAGE,SERVICECODE)
			WITH (MAXDOP = 8);

			EXEC DBO.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = @V_SYSTEMTIME
							, @V_END_DT = NULL
							, @V_STATUS = 'COMPLETED'
							, @V_ACTION = 2
							, @V_PARENT_PROCESS_ID = @V_PARENT_PROCESS_ID
							, @V_NOTE = 'PROCESS CONSUMPTION DATA COMPLETED SUCCESSFULLY'
							, @V_START_STEP = 1;

			SET @V_ERROR_CODE = 0
			RETURN @V_ERROR_CODE
	END TRY
	BEGIN CATCH
		SET @V_MSG = COALESCE(ERROR_PROCEDURE() +' LINE:'+CAST(ERROR_LINE() AS VARCHAR(10))+' MESSAGE:' +ERROR_MESSAGE(),'')
		SET @V_ERRORMESSAGE = 'PROCESS TO REFRESH CAPACITY ANALYSIS DATA SET FAILED: ERR:' + @V_MSG
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



GO
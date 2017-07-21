/****** Object:  StoredProcedure [dbo].[USP_BUILDROUTELEGSSCHEDULE]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_BUILDROUTELEGSSCHEDULE]
/****************************************************************************************************
* COPYRIGHT REVENUE ANALYTICS 2017
* ALL RIGHTS RESERVED
*
* CREATED BY: DATA ENGINEERING
* FILENAME:   USP_CAPINV_ROUTELEGS_SCHEDULE.SQL
* DATE:       04/07/2017
*
* APPLICATION:  REFRESH THE ROUTELEGS_SCHEDULE TABLE
*               
* PARAMETERS:   @V_AUDITVERSION_ID == AUDIT VERSION
*				@V_ERROR_CODE		== RETURNED ERROR CODE
*  				
* ASSUMPTIONS: SCHEDULE TABLE IS UPDATED
*
* INPUTS:  
* EXAMPLE CALL: EXEC USP_BUILDROUTELEGSSCHEDULE 0, @V_CNT OUTPUT
*
*
*****************************************************************************************************
* NOTES:
*  NAME					CREATED        LAST MOD			COMMENTS
*  DE\ELM               4/17/2017						PROCEDURE CREATED
****************************************************************************************************/
	@V_AUDITVERSION_ID INT, 
	@V_ERROR_CODE INT OUT
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

	BEGIN TRY
		--LOG PROCESS		
		EXEC DBO.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = @V_SYSTEMTIME
							, @V_END_DT = NULL
							, @V_STATUS = 'RUNNING'
							, @V_ACTION = 1
							, @V_PARENT_PROCESS_ID = 0
							, @V_NOTE = 'PROCESS ROUTE LEGS'
							, @V_START_STEP = 1;

		--CREATE BACKUP
		IF OBJECT_ID('DBO.ROUTELEGS_SCHEDULE_BAK', 'U') IS NOT NULL
		BEGIN
			DROP TABLE DBO.ROUTELEGS_SCHEDULE_BAK; 
			EXEC SP_RENAME 'ROUTELEGS_SCHEDULE', 'ROUTELEGS_SCHEDULE_BAK'
		END

		---------------------------------------------------------
		-- PRE-FILTER THE SCHEDULES DATA FOR THE 84K SERVICE CODE
		---------------------------------------------------------
		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'BUILD ROUTE LEGS SCHEDULE TABLE'
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'USING THE SCHEDULE TABLE UPDATE LEGS';

		IF OBJECT_ID('DBO.ROUTELEGS_SCHEDULE', 'U') IS NOT NULL
		  DROP TABLE DBO.ROUTELEGS_SCHEDULE;

		SELECT A.AUDITVERSIONID
			  ,ROW_NUMBER() OVER (PARTITION BY [DEPSERVICECODE], VESSEL ORDER BY [ACTDEPARTUREDATE]) AS SCHEDULEID
			  ,[DEPSERVICECODE] AS SERVICECODE
			  ,[VESSEL] AS VESSELCODE
			  ,[DEPVOYAGE] AS VOYAGE
			  ,ARRVOYAGE AS [ARRVOYAGE]
			  ,ROW_NUMBER() OVER (PARTITION BY [DEPSERVICECODE], VESSEL,[DEPVOYAGE] ORDER BY [ACTDEPARTUREDATE]) AS LEGSEQID	
			  ,[SITE_CODE] AS DEPARTUREPORT
			  ,DepServiceDir as serviceCodeDirection

			  ,LEAD(SITE_CODE) OVER (PARTITION BY [DEPSERVICECODE], VESSEL ORDER BY [ACTDEPARTUREDATE]) AS ARRIVALPORT
			  ,LEAD(DEPVOYAGE) OVER (PARTITION BY [DEPSERVICECODE], VESSEL ORDER BY [ACTDEPARTUREDATE]) AS NEXTDEPVOYAGE
			  ,LEAD(ARRVOYAGE) OVER (PARTITION BY [DEPSERVICECODE], VESSEL ORDER BY [ACTDEPARTUREDATE]) AS NEXTARRIVALVOYAGE
			  ,[SCHDEPARTUREDATE] AS ORIGINAL_ETD
			  ,[ACTDEPARTUREDATE] AS ACTUAL_ETD
			  ,LEAD([ACTARRIVALDATE]) OVER (PARTITION BY [DEPSERVICECODE], VESSEL ORDER BY [ACTDEPARTUREDATE]) AS ARRIVALDATE
			  ,LEAD([SCHARRIVALDATE]) OVER (PARTITION BY [DEPSERVICECODE], VESSEL ORDER BY [ACTDEPARTUREDATE]) AS [SCHARRIVALDATE]
			  ,LEAD([ACTARRIVALDATE]) OVER (PARTITION BY [DEPSERVICECODE], VESSEL ORDER BY [ACTDEPARTUREDATE]) AS [ACTARRIVALDATE]
		INTO DBO.ROUTELEGS_SCHEDULE
		FROM ANALYTICSDATAMART.DBO.SCHEDULE A
		WHERE LEFT([SITE_CODE],5) NOT IN ('PAPTY', 'EGSUC')
 
 		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = SYSDATETIME()

		CREATE CLUSTERED INDEX CDX_ROUTELEGS_SCHEDULE ON DBO.ROUTELEGS_SCHEDULE(SERVICECODE,VESSELCODE,VOYAGE)

		--UPDATE DETAIL 
		EXEC DBO.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;

		--UPDATE PROCESS --COMPLETE PROCESS
		SET @V_NOTE = @V_NOTE +' COMPLETELY SUCCESSFULLY'
		EXEC DBO.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = NULL
							, @V_END_DT = @V_SYSTEMTIME
							, @V_STATUS = 'COMPLETED'
							, @V_ACTION = 2
							, @V_PARENT_PROCESS_ID = NULL
							, @V_NOTE = NULL
							, @V_START_STEP = 1;

		SET @V_ERROR_CODE = 0
		RETURN @V_ERROR_CODE
	END TRY
	BEGIN CATCH
		SET @V_MSG = COALESCE(ERROR_PROCEDURE() +' LINE:'+CAST(ERROR_LINE() AS VARCHAR(10))+' MESSAGE:' +ERROR_MESSAGE(),'')
		SET @V_ERRORMESSAGE = 'PROCESS TO REFRESH ROUTE LEGS FAILED: ERR:' + @V_MSG
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
/****** Object:  StoredProcedure [dbo].[USP_capInv_ad_rocks]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
USE [CapInvRepository]

IF ( OBJECT_ID('dbo.USP_CAPFCST_RUN_FCST', 'P') IS NOT NULL ) 
   DROP PROCEDURE dbo.USP_CAPFCST_RUN_FCST
GO

CREATE PROCEDURE [DBO].[USP_CAPFCST_RUN_FCST]
/****************************************************************************************************
* COPYRIGHT REVENUE ANALYTICS 2017
* ALL RIGHTS RESERVED
*
* CREATED BY: DATA ENGINEERING
* FILENAME:   USP_CAPFCST_RUN_FCST.SQL
* DATE:       08/01/2017
*
* APPLICATION:  RUNS THE CAPACITY FORECAST
*               
* PARAMETERS:   @V_PARENT_PROCESS_ID == PARENT OR CALLING PROCESS ID
*				@V_ERROR_CODE		== RETURNED ERROR CODE
*  				
* ASSUMPTIONS: BOOKING_FINAL, ROUTELINKS AND SCHEDULE TABLES UPDATED
*
* INPUT TABLE(S):	
* OUTPUT TABLE(S):	
*
* PARAMETERS:   @V_RUNDATE = DATE OF THE RUN
*				@V_SERVICE = Service to run -- ALL to run all services
*				@V_STARTSTEP = Starting Step -- Default 0
*				@V_ENDSTEP = End Step -- Default 100,000
*				@V_PARENT_PROCESS_ID == PARENT OR CALLING PROCESS ID
*				@V_ERROR_CODE		== RETURNED ERROR CODE
*
* EXAMPLE CALL: DECLARE	@RETURN_VALUE INT,@V_ERROR_CODE INT
*
*				EXEC	@RETURN_VALUE = [DBO].[USP_CAPFCST_RUN_FCST]
*						@V_RUNDATE = '2017-04-01',
						@V_SERVICE = '84K',
						@V_STARTSTEP = 10
						@V_ENDSTEP = 20
*						@V_ERROR_CODE = @V_ERROR_CODE OUTPUT
*
*****************************************************************************************************
* NOTES:
*  NAME					CREATED        LAST MOD			COMMENTS
*  DE\ELM               4/17/2017						PROCEDURE CREATED
****************************************************************************************************/
	 @V_RUNDATE DATE = NULL
	,@V_SERVICE VARCHAR(10)
	,@V_STARTSTEP INT = 0
	,@V_ENDSTEP INT = 100000
	,@V_PARENT_PROCESS_ID INT = 0
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
	DECLARE @RETURN_VALUE INT

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
							, @V_NOTE = 'Process CapFcst'
							, @V_START_STEP = 1;

			
			set @V_SYSTEMTIME = GETUTCDATE()
												
			SET @V_STEP_ID = 10
			IF @V_STEP_ID BETWEEN @V_STARTSTEP and @V_ENDSTEP 
			BEGIN
				SET @V_STEP_NAME = 'Build consumption table -- Run Stored Proc: USP_CAPFCST_AD_CONSUMPTION'
				EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  							, @V_STEP_ID = @V_STEP_ID
  							, @V_STEP_NAME = @V_STEP_NAME
  							, @V_START_DT = @V_SYSTEMTIME
  							, @V_END_DT = NULL
  							, @V_STATUS = 'RUNNING'
  							, @V_ROWS_PROCESSED = NULL
  							, @V_ACTION = 1
  							, @V_NOTE = 'Using booking final build consumption table at the leg level';

				EXEC	@RETURN_VALUE = [DBO].[USP_CAPFCST_AD_CONSUMPTION]
									@V_RUNDATE = @V_RUNDATE,
									@V_SERVICE = @V_SERVICE,
									@V_PARENT_PROCESS_ID = @V_PROCESS_ID,
									@V_ERROR_CODE = @V_ERROR_CODE OUTPUT

				IF 	@RETURN_VALUE = 0
				BEGIN
						--UPdate Detail 
						SET @V_SYSTEMTIME = GETUTCDATE()
						SET @V_STEP_NAME = @V_STEP_NAME + ' Completed successfully'
						EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  									, @V_STEP_ID = @V_STEP_ID
  									, @V_STEP_NAME = @V_STEP_NAME
  									, @V_START_DT = NULL
  									, @V_END_DT = @V_SYSTEMTIME
  									, @V_STATUS = 'COMPLETED'
  									, @V_ROWS_PROCESSED = NULL
  									, @V_ACTION = 2
  									, @V_NOTE = NULL;
				END
			END

			SET @V_STEP_ID = 20
			IF @V_STEP_ID BETWEEN @V_STARTSTEP and @V_ENDSTEP 
			BEGIN
				SET @V_STEP_NAME = 'Generate Capacity Forecast -- Run Stored Proc: USP_CAPFCST_CALC_FREESALECONSUMPTION'
				EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  							, @V_STEP_ID = @V_STEP_ID
  							, @V_STEP_NAME = @V_STEP_NAME
  							, @V_START_DT = @V_SYSTEMTIME
  							, @V_END_DT = NULL
  							, @V_STATUS = 'RUNNING'
  							, @V_ROWS_PROCESSED = NULL
  							, @V_ACTION = 1
  							, @V_NOTE = 'Generate Capacity Forecast final table and aggregated UI outputs';

				EXEC	@RETURN_VALUE = [DBO].USP_CAPINV_CALC_REMAINING_CAPACITY
									@V_RUNDATE = @V_RUNDATE,
									@V_PARENT_PROCESS_ID = @V_PROCESS_ID,
									@V_ERROR_CODE = @V_ERROR_CODE OUTPUT

				IF 	@RETURN_VALUE = 0
				BEGIN
						--UPdate Detail 
						SET @V_SYSTEMTIME = GETUTCDATE()
						SET @V_STEP_NAME = @V_STEP_NAME + ' Completed successfully'
						EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  									, @V_STEP_ID = @V_STEP_ID
  									, @V_STEP_NAME = @V_STEP_NAME
  									, @V_START_DT = NULL
  									, @V_END_DT = @V_SYSTEMTIME
  									, @V_STATUS = 'COMPLETED'
  									, @V_ROWS_PROCESSED = NULL
  									, @V_ACTION = 2
  									, @V_NOTE = NULL;
				END
			END

			SET @V_STEP_ID = 30
			IF @V_STEP_ID BETWEEN @V_STARTSTEP and @V_ENDSTEP 
			BEGIN
				SET @V_STEP_NAME = 'Generate UI Capacity Forecast table -- Run Stored Proc: USP_CAPINV_UI_DATA_UPDATE'
				EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  							, @V_STEP_ID = @V_STEP_ID
  							, @V_STEP_NAME = @V_STEP_NAME
  							, @V_START_DT = @V_SYSTEMTIME
  							, @V_END_DT = NULL
  							, @V_STATUS = 'RUNNING'
  							, @V_ROWS_PROCESSED = NULL
  							, @V_ACTION = 1
  							, @V_NOTE = 'Generate Capacity Forecast final table for UI';

				EXEC	@RETURN_VALUE = [DBO].USP_CAPINV_UI_DATA_UPDATE
									@V_PARENT_PROCESS_ID = @V_PROCESS_ID,
									@V_ERROR_CODE = @V_ERROR_CODE OUTPUT

				IF 	@RETURN_VALUE = 0
				BEGIN
						--UPdate Detail 
						SET @V_SYSTEMTIME = GETUTCDATE()
						SET @V_STEP_NAME = @V_STEP_NAME + ' Completed successfully'
						EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  									, @V_STEP_ID = @V_STEP_ID
  									, @V_STEP_NAME = @V_STEP_NAME
  									, @V_START_DT = NULL
  									, @V_END_DT = @V_SYSTEMTIME
  									, @V_STATUS = 'COMPLETED'
  									, @V_ROWS_PROCESSED = NULL
  									, @V_ACTION = 2
  									, @V_NOTE = NULL;
				END
			END

			--Update Process --Complete Process
			SET @V_SYSTEMTIME = GETUTCDATE()
			SET @V_STEP_NAME = @V_PROCESS_NAME + ' Completed successfully'
			EXEC dbo.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
								, @V_PROCESS_NAME = @V_PROCESS_NAME
								, @V_USER_NAME = @V_SYSTEM_USER
								, @V_START_DT = NULL
								, @V_END_DT = @V_SYSTEMTIME
								, @V_STATUS = 'COMPLETED'
								, @V_ACTION = 2
								, @V_PARENT_PROCESS_ID = NULL
								, @V_NOTE = @V_STEP_NAME
								, @V_START_STEP = 1;
	END TRY
	BEGIN CATCH
		SET @V_ERRORMESSAGE = 'Process to refresh UDF Booking Analysis dataset and create forecast failed: ' + ERROR_MESSAGE()
		SET @V_ERRORSEVERITY = ERROR_SEVERITY()  
		SET @V_SYSTEMTIME = GETUTCDATE()

		--UPdate Detail 
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'FAILED'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 2
  					, @V_NOTE = @V_ERRORMESSAGE
  					;

		--Update Process --Complete Process
		EXEC dbo.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
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



/****** Object:  StoredProcedure [dbo].[USP_IngestionSchedule]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_IngestionSchedule]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   USP_IngestionSchedule.SQL
* Date:       04/07/2017
*
* Application:  Load Schedule dataset
*               
* Parameters:   @V_PARENT_PROCESS_ID == Calling Process
*				@V_ERROR_CODE		== Returned Error Code
*  				
* Assumptions: ETLRepository.dbo.stg_schedule is updated and flag in ETLDeatials enddate is updated
*
* Input table(s):	ETLRepository.dbo.stg_schedule
* Output Table(s):	AnalysisDataset.dbo.schedule
*
* EXAMPLE CALL:  DECLARE @V_ERROR_CODE INT
*				 EXEC USP_IngestionSchedule 0, @V_ERROR_CODE OUTPUT
*****************************************************************************************************
* Notes:
*  Name					CREATED        Last Mod			Comments
*  DE\ELM								06/22/2017		Procedure updated 
****************************************************************************************************/
	   @V_PARENT_PROCESS_ID INT = 0
	 , @V_ERROR_CODE INT OUTPUT
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
		--Log Process		
		EXEC dbo.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = @V_SYSTEMTIME
							, @V_END_DT = NULL
							, @V_STATUS = 'RUNNING'
							, @V_ACTION = 1
							, @V_PARENT_PROCESS_ID = 0
							, @V_NOTE = 'Process Schedule data'
							, @V_START_STEP = 1;

		---------------------------------------------------------
		--Delete existing shipment numbers
		---------------------------------------------------------
		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'Delete existing schedules'
		SET @V_NOTE = 'Delete existing schedules'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		--DELETE ROWS IF ALREADY THE DATA IS PRESENT
		DELETE FROM DBO.SCHEDULE WHERE EXISTS (
		SELECT 1 FROM [ETLREPOSITORY].DBO.STG_SCHEDULE A
		  WHERE A.VESSEL = SCHEDULE.VESSEL
		AND A.[DepServiceCode] = SCHEDULE.[DepServiceCode]
		AND A.SITE_CODE = SCHEDULE.SITE_CODE
		AND A.[DepVoyage] = SCHEDULE.[DepVoyage]);

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()
			
		--UPdate Detail 
		SET @V_NOTE = @V_NOTE +' completed successfully'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;


		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'Insert schedules data'
		SET @V_NOTE = 'Insert schedules data'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		INSERT INTO [dbo].[Schedule]
				   ([AuditVersionId]
				   ,[Vessel]
				   ,[VesselOperator]
				   ,[DepServiceCode]
				   ,[DepServiceDir]
				   ,[DepVoyage]
				   ,[Dep_Stat]
				   ,[SchDepartureDate]
				   ,[ActDepartureDate]
				   ,[SchDepartureDateUTC]
				   ,[ActDepartureDateUTC]
				   ,[Site_Code]
				   ,[ArrVoyage]
				   ,[ArrServiceDir]
				   ,[ArrServiceCode]
				   ,[Arr_Stat]
				   ,[SchArrivalDate]
				   ,[ActArrivalDate]
				   ,[SchArrivalDateUTC]
				   ,[ActArrivalDateUTC]
				   ,[Vessel_Capacity_TEU]
				   ,[TEU]     
			)
			SELECT  [AuditVersionId]
				   ,[Vessel]
				   ,[VesselOperator]
				   ,[DepServiceCode]
				   ,[DepServiceDir]
				   ,[DepVoyage]
				   ,[Dep_Stat]
				   ,[SchDepartureDate]
				   ,[ActDepartureDate]
				   ,[SchDepartureDateUTC]
				   ,[ActDepartureDateUTC]
				   ,[Site_Code]
				   ,[ArrVoyage]
				   ,[ArrServiceDir]
				   ,[ArrServiceCode]
				   ,[Arr_Stat]
				   ,[SchArrivalDate]
				   ,[ActArrivalDate]
				   ,[SchArrivalDateUTC]
				   ,[ActArrivalDateUTC]
				   ,[Vessel_Capacity_TEU]
				   ,[TEU]
		  FROM [ETLRepository].dbo.[Stg_Schedule] 

		  SET @V_RECORD_CNT = @@ROWCOUNT
		  SET @V_SYSTEMTIME = GETUTCDATE()
			
		  --UPdate Detail 
		  SET @V_NOTE = @V_NOTE +' completed successfully'
		  EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;

		SET @V_ERROR_CODE = 0
		RETURN @V_ERROR_CODE
	END TRY
	BEGIN CATCH
		SET @V_MSG = coalesce(ERROR_PROCEDURE() +' Line:'+cast(ERROR_LINE() as varchar(10))+' Message:' +ERROR_MESSAGE(),'')
		SET @V_ERRORMESSAGE = 'Process to refresh Schedues (GSIS) data failed: Err:' + @V_MSG
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


GO
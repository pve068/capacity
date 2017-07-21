
/****** Object:  StoredProcedure [dbo].[USP_IngestComsAllocation]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[USP_IngestComsAllocation]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   USP_IngestComsAllocation.SQL
* Date:       04/07/2017
*
* Application:  Load COMS Allocation data from ETLRespository
*               
*
* Parameters:   @v_AuditVersion_ID == Audit Version
*				@V_ERROR_CODE = Error Code as an Output
*  				
* Input(s):		ETLReopository.dbo.stg_coms_allocation
* Output(s):	AnalyticsDataMart.dbo.AD_ML_Allocations
*
* Assumptions: ETLReopository.dbo.stg_coms_allocation table is updated
*
* Example Call: exec USP_IngestComsAllocation 0, @v_errorcode output
*
*
*****************************************************************************************************
* Notes:
*  Name					CREATED        Last Mod			Comments
*  DE\ELM               4/7/2017						Procedure Created
****************************************************************************************************/
	@v_AuditVersion_ID INT, 
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
		--Log Process		
		EXEC dbo.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
							, @V_PROCESS_NAME = @V_PROCESS_NAME
							, @V_USER_NAME = @V_SYSTEM_USER
							, @V_START_DT = @V_SYSTEMTIME
							, @V_END_DT = NULL
							, @V_STATUS = 'RUNNING'
							, @V_ACTION = 1
							, @V_PARENT_PROCESS_ID = 0
							, @V_NOTE = 'Process Allocations'
							, @V_START_STEP = 1;

		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'Delete existinct Allocation data'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'Delete existing Allocation data';

		DELETE FROM Analyticsdatamart.dbo.AD_ML_Allocations
		WHERE EXISTS (
			SELECT 1 FROM ETLRepository.[DBO].STG_COMS_ALLOCATION (nolock) GG
			WHERE GG.VesselCode = AD_ML_Allocations.VesselCode
				AND GG.departureVoyage = AD_ML_Allocations.voyage
				AND substring(gg.serviceroute,1,CHARINDEX('/',gg.serviceroute) - 1) = AD_ML_Allocations.servicecode
				AND substring(gg.serviceroute,CHARINDEX('/',gg.serviceroute) + 1,99) = AD_ML_Allocations.route_cd
				AND GG.sitecode = AD_ML_Allocations.departureport
			)

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()
			
		--UPdate Detail 
		SET @V_NOTE = @V_NOTE +' COMPLETELY SUCCESSFULLY'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE =@V_NOTE;

		/*********************************************************************
								New Allocation table
		********************************************************************/
		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'Pull Allocation data'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'Refresh the allocation table'
  					, @V_ERROR_CODE = @V_FIANLERROR OUTPUT;

		;WITH etl_allocation as
		(
			SELECT	 a.departureVoyage as  voyage
					, a.VesselCode
					, substring(a.serviceroute,1,CHARINDEX('/',a.serviceroute) - 1) as servicecode
					, substring(a.serviceroute,CHARINDEX('/',a.serviceroute) + 1,99) as route_cd
					, a.serviceroute
					, a.sitecode as departureport
					, lead(a.SITECODE) over (partition by vesselcode,a.serviceroute order by departuredate,departuretime) as arrivalport
					, a.Operator as vesseloperator
					, departuredate
					, departuretime
					, LegIntakeTEU as IntakeTEU
					, LegIntakeMT as IntakeTons
					, LegIntakePlugs as IntakePlugs
					, AllocationMSKTeu as AllocationTEU
					, AllocationMSKMT as AllocationTons
					, AllocationMSKPlugs as AllocationPlugs
			FROM  ETLRepository.[DBO].STG_COMS_ALLOCATION a
			where AllocationMSKTeu is not null
		)
		INSERT INTO Analyticsdatamart.dbo.AD_ML_Allocations
		(
			Auditversion_ID
			,voyage
			, VesselCode
			, servicecode
			, route_cd
			, serviceroute
			, departureport
			, arrivalport
			, vesseloperator
			, departuredate
			, departuretime
			, IntakeTEU
			, IntakeTons
			, IntakePlugs
			, AllocationTEU
			, AllocationTons
			, AllocationPlugs
		)
		SELECT		@v_AuditVersion_ID
					,voyage
					, VesselCode
					, servicecode
					, route_cd
					, serviceroute
					, departureport
					, arrivalport
					, vesseloperator
					, departuredate
					, departuretime
					, IntakeTEU
					, IntakeTons
					, IntakePlugs
					, AllocationTEU
					, AllocationTons
					, AllocationPlugs
		FROM etl_allocation 
		WHERE arrivalport is not null;

		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()
			
		--UPdate Detail 
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = @V_RECORD_CNT
  					, @V_ACTION = 2
  					, @V_NOTE = NULL;

		--Update Process --Complete Process
		EXEC dbo.USP_LOG_PROCESS @V_PROCESS_ID = @V_PROCESS_ID
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
		SET @V_MSG = coalesce(ERROR_PROCEDURE() +' Line:'+cast(ERROR_LINE() as varchar(10))+' Message:' +ERROR_MESSAGE(),'')
		SET @V_ERRORMESSAGE = 'Process to refresh Consumption failed: Err:' + @V_MSG
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
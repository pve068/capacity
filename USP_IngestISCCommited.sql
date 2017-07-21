
/****** Object:  StoredProcedure [dbo].[USP_IngestISCCommited]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[USP_IngestISCCommited]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   USP_IngestISCCommited.SQL
* Date:       06/21/2017
*
* Application:  Loads ICS Commited data from ETLRespository
*               
* Parameters:   @V_PARENT_PROCESS_ID == Calling Process
*				@V_ERROR_CODE		== Returned Error Code
*
* Input(s):		ETLReopository.dbo.stg_BookingCommitment 
* Output(s):	CapInvRepository.dbo.AD_Displacement_OOG
*  				
* Assumptions: ETLReopository.dbo.stg_BookingCommitment table is updated
*
* EXAMPLE CALL:  DECLARE @V_ERROR_CODE INT
*				 EXEC [USP_IngestISCCommited] 0, @V_ERROR_CODE OUTPUT
*****************************************************************************************************
* Notes:
*  Name					CREATED        Last Mod			Comments
*  DE\ELM               6/21/2017						Procedure Created
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
							, @V_NOTE = 'Process ICS Commited data'
							, @V_START_STEP = 1;

		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'Delete existing ICS Commited data'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'Delete existing ICS Commited data';
 
 		--Delete existing data
		DELETE  
		FROM Analyticsdatamart.dbo.AD_ISC_Commited
		WHERE EXISTS (
						SELECT 1 
						FROM ETLREPOSITORY.DBO.[stg_ISC_Commited] BB (NOLOCK)
						WHERE BB.weekNo = AD_ISC_Commited.weekNo
						AND BB.servicecode = AD_ISC_Commited.servicecode
						--AND BB.vesselcode = AD_ISC_Commited.vesselcode
						--AND BB.voyage = AD_ISC_Commited.voyage
						AND isnull(BB.sellingstring,'UNK') = isnull(AD_ISC_Commited.sellingstring,'UNK')
						AND isnull(BB.buyingstring,'UNK') = isnull(AD_ISC_Commited.buyingstring,'UNK')
						AND BB.fromport = AD_ISC_Commited.fromport
						AND BB.toport = AD_ISC_Commited.toport
					);

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
  					, @V_NOTE =@V_NOTE
  					;

		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'Insert new ICS Commited data'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'Insert new ICS Commited data';


		/******************************************************************
						Empties -- Rock Data
		*******************************************************************/
		INSERT INTO Analyticsdatamart.dbo.AD_ISC_Commited
				   ([AuditVersionId]
				  ,[WeekNo]
				  ,[ServiceCode]
				  ,[SellingString]
				  ,[BuyingString]
				  ,[BuyingCompany]
				  ,[FromPort]
				  ,[ToPort]
				  ,[TEU]
				  ,[WeightKg]
		)
		select	[AuditVersionId]
			  ,[WeekNo]
			  ,[ServiceCode]
			  ,[SellingString]
			  ,[BuyingString]
			  ,[BuyingCompany]
			  ,[FromPort]
			  ,[ToPort]
			  ,[TEU]
			  ,[WeightKg]
		from [ETLRepository].[dbo].[stg_ISC_Commited];
			
		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = SYSDATETIME()
			
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
		SET @V_ERRORMESSAGE = 'Process to refresh ICS Commited data failed: ' + ERROR_MESSAGE()
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
  					, @V_NOTE = @V_ERRORMESSAGE;

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
							, @V_START_STEP = 1;  

		SET @V_ERROR_CODE = -1
		RETURN @V_ERROR_CODE
	END CATCH
END
	

GO

/****** Object:  StoredProcedure [dbo].[USP_IngestBookingFinal]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_IngestBookingFinal]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   USP_IngestBookingFinal.SQL
* Date:       04/07/2017
*
* Application:  Load booking final analysis dataset
*               
* Parameters:   @V_PARENT_PROCESS_ID == Calling Process
*				@V_ERROR_CODE		== Returned Error Code
*  				
* Assumptions: ETLRepository.dbo.stg_BookingFinal is updated and flag in ETLDeatials enddate is updated
*
* Input table(s):	ETLRepository.dbo.stg_BookingFinal 
* Output Table(s):	AnalysisDataset.dbo.booking_final 
*
* EXAMPLE CALL:  DECLARE @V_ERROR_CODE INT
*				 EXEC USP_IngestBookingFinal 0,0, @V_ERROR_CODE OUTPUT
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
							, @V_NOTE = 'Process Booking Final data'
							, @V_START_STEP = 1;

		---------------------------------------------------------
		--Delete existing shipment numbers
		---------------------------------------------------------
		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'Delete existing shipmet numbers'
		SET @V_NOTE = 'Delete existing shipments from booking final'
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
		DELETE FROM BOOKING_FINAL WHERE EXISTS (
		SELECT 1 FROM [ETLREPOSITORY].DBO.STG_BOOKINGFINAL A 
		WHERE A.SHIPMENT_NO_X = BOOKING_FINAL.SHIPMENT_NO_X);

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

			------------------------------------------------------------------
		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'Insert into data into booking final'
		SET @V_NOTE = 'Insert into data into booking final'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

			INSERT INTO [dbo].[Booking_Final]
					   ([AuditVersionID]
					   ,[SHIPMENT_NO_X]
					   ,[SHIPMENT_VRSN_ID_X]
					   ,[IS_VSA_F]
					   ,[IS_IMPORT_SHIPMENT_F]
					   ,[IS_Operational_Shipment_F]
					   ,[Brand]
					   ,[Container_Key]
					   ,[CONTAINER_NO_X]
					   ,[CONTAINER_SIZE_X]
					   ,[CONTAINER_HEIGHT_X]
					   ,[CARGO_TYPE]
					   ,[FFE]
					   ,[CONTAINER_TYPE_X]
					   ,[CargoWeightKG]
					   ,[GrossWeightKG]
					   ,[EquipmentTareWeight_Kgs]
					   ,[SHIPMENT_CARGO_DESC_X]
					   ,[CommodityCode]
					   ,[IS_HAZ_F]
					   ,[IS_OOG_F]
					   ,[IS_BREAK_BULK_F]
					   ,[DIPLA]
					   ,[LOPFI]
					   ,[POD]
					   ,[POR]
					   ,[PRICE_CALC_BASE_LCL_D]
					   ,[Booking_Date]
					   ,[Booked_By]
					   ,[Booked_By_CD]
					   ,[Price_Owner]
					   ,[Price_Owner_CD]
					   ,[PO_CUST_SEGMENT]
					   ,[Consignee]
					   ,[Consignee_CD]
					   ,[STRING_ID_X]
					   ,[STRING_DIRECTION_X]
					   ,[ROUTE_CD]
					   ,[Shipment_Status]
					   ,[BAS]
					   ,[NON_BAS]
					   ,[SURCHARGES]
					   ,[Is_Live_Reefer]
					   ,[NAC_Customer]
					   ,[NAC_Customer_CD]
					   ,[Shipper]
					   ,[Shipper_CD]
					   ,[Extract_Date])			
     		SELECT		[AuditVersionID]
						,[SHIPMENT_NO_X]
						,[SHIPMENT_VRSN_ID_X]
						,[IS_VSA_F]
						,[IS_IMPORT_SHIPMENT_F]
						,[IS_Operational_Shipment_F]
						,[Brand]
						,[Container_Key]
						,[CONTAINER_NO_X]
						,[CONTAINER_SIZE_X]
						,[CONTAINER_HEIGHT_X]
						,[CARGO_TYPE]
						,[FFE]
						,[CONTAINER_TYPE_X]
						,[CargoWeightKG]
						,[GrossWeightKG]
						,[EquipmentTareWeight_Kgs]
						,[SHIPMENT_CARGO_DESC_X]
						,[CommodityCode]
						,[IS_HAZ_F]
						,[IS_OOG_F]
						,[IS_BREAK_BULK_F]
						,[DIPLA]
						,[LOPFI]
						,[POD]
						,[POR]
						,[PRICE_CALC_BASE_LCL_D]
						,[Booking_Date]
						,[Booked_By]
						,[Booked_By_CD]
						,[Price_Owner]
						,[Price_Owner_CD]
						,[PO_CUST_SEGMENT]
						,[Consignee]
						,[Consignee_CD]
						,[STRING_ID_X]
						,[STRING_DIRECTION_X]
						,[ROUTE_CD]
						,[Shipment_Status]
						,[BAS]
						,[NON_BAS]
						,[SURCHARGES]
						,[Is_Live_Reefer]
						,[NAC_Customer]
						,[NAC_Customer_CD]
						,[Shipper]
						,[Shipper_CD]
						,[Extract_Date]
			FROM [ETLRepository].[dbo].[stg_BookingFinal] (nolock)
  
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
	
		 -----------------------------------------------------------------------
		 --Complete by updating the IsConsumed flag on the ProcessDetail table 
		 -----------------------------------------------------------------------
		SET @V_STEP_ID = 30
		SET @V_STEP_NAME = 'Update consumption flag'
		SET @V_NOTE = 'Update consumption flag in ETLDetail table'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		--exec  [ETLRepository].[dbo].spMarkProcessDetailAsComplete @ProcessID = 4

		--UPdate Detail 
		SET @V_NOTE = @V_NOTE +' completed successfully'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = NULL
  					, @V_END_DT = @V_SYSTEMTIME
  					, @V_STATUS = 'COMPLETED'
  					, @V_ROWS_PROCESSED = Null
  					, @V_ACTION = 2
  					, @V_NOTE = @V_NOTE;
 
			SET @V_ERROR_CODE = 0
			RETURN @V_ERROR_CODE
	END TRY
	BEGIN CATCH
		SET @V_MSG = coalesce(ERROR_PROCEDURE() +' Line:'+cast(ERROR_LINE() as varchar(10))+' Message:' +ERROR_MESSAGE(),'')
		SET @V_ERRORMESSAGE = 'Process to refresh Booking Final failed: Err:' + @V_MSG
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
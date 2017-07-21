
/****** Object:  StoredProcedure [dbo].[USP_IngestRouteLinks]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_IngestRouteLinks]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   USP_IngestRouteLinks.SQL
* Date:       04/07/2017
*
* Application:  Load Route Links analysis dataset
*               
* Parameters:   @V_PARENT_PROCESS_ID == Parent or Calling process id
*				@V_ERROR_CODE		== Returned Error Code
*  				
* Assumptions: ETLRepository.dbo.stg_RouteLinks is updated and flag in ETLDeatials enddate is updated
*
* Input table(s):	ETLRepository.dbo.stg_RouteLinks
* Output Table(s):	AnalysisDataset.dbo.RouteLinks 
*
* EXAMPLE CALL:  DECLARE @V_ERROR_CODE INT
*				 EXEC USP_IngestRouteLinks 0,0, @V_ERROR_CODE OUTPUT
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
							, @V_NOTE = 'Process Routelinks data'
							, @V_START_STEP = 1;

		---------------------------------------------------------
		--Delete existing shipment numbers
		---------------------------------------------------------
		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'Delete existing shipmet numbers'
		SET @V_NOTE = 'Delete existing shipments'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		--Delete rows if already the data is present
		delete from RouteLinks where exists (
		select 1 from [ETLRepository].dbo.stg_RouteLinks a where a.SHIPMENT_NO_X = RouteLinks.SHIPMENT_NO_X
		and a.SHIPMENT_VRSN_ID_X = RouteLinks.SHIPMENT_VRSN_ID_X
		and a.Booking_Date = RouteLinks.Booking_Date);

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

		--------------------------------------------------------------
		-- Pull new data into routelinks
		--------------------------------------------------------------
		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'Insert new shipments into route links'
		SET @V_NOTE = 'Insert new shipments into route links'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		INSERT INTO [dbo].[RouteLinks]
				(AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,LocSeqX
				,FromSiteCode
				,FromCityCode
				,ToSiteCode
				,ToCityCode
				,MEPCTransModeX
				,DepVoyageX
				,ArrVoyageX
				,ServiceCode
				,VesselCode
				,DepLocalExpectedDt
				,ArrLocalExpectedDt
				,DepUTCExpectedTs
				,ArrUTCExpectedTs
				,WaterLandMode_Fl
				,DIPLA
				,LOPFI
				,[Extract_Date]
				)
		SELECT  AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,BOOKING_DATE
				,ROUTE_LOC_SEQ_X           AS   LOCSEQX
				,RKST_SITE_CD_FROM         AS   FROMSITECODE
				,RKST_CITY_CD_FROM         AS   FROMCITYCODE
				,RKST_SITE_CD_TO           AS   TOSITECODE
				,RKST_CITY_CD_TO           AS   TOCITYCODE
				,MEPC_TRANS_MODE_X         AS   MEPCTRANSMODEX
				,DEP_VOYAGE_X              AS   DEPVOYAGEX
				,ARR_VOYAGE_X              AS   ARRVOYAGEX
				,SERVICE_CD                AS   SERVICECODE
				,VESSEL_CD                 AS   VESSELCODE
				,DEP_LOCAL_EXPECTED_TS     AS   DEPLOCALEXPECTEDDT
				,ARR_LOCAL_EXPECTED_TS     AS   ARRLOCALEXPECTEDDT
				,DEPUTCEXPECTEDTS		     AS   DEPUTCEXPECTEDTS
				,ARRUTCEXPECTEDTS          AS   ARRUTCEXPECTEDTS
				,WATER_LAND_MODE_F         AS   WATERLANDMODE_FL
				,DIPLA                     AS   DIPLA
				,LOPFI                     AS   LOPFI
				,[EXTRACT_DATE]
		FROM
		(
		SELECT  AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'1' LocSeqX
				,RKST_SITE_CD_FROM_1        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_1        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_1          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_1          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_1        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_1          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_1             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_1             as   ARR_VOYAGE_X
				,Service_Cd_1               as   Service_Cd
				,VESSEL_CD_1                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_1    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_1    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_1		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_1         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_1        as   WATER_LAND_MODE_F
				,DIPLA_1                    as   DIPLA
				,LOPFI_1                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
				from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'2' LocSeqX
				,RKST_SITE_CD_FROM_2        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_2        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_2          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_2          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_2        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_2          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_2             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_2             as   ARR_VOYAGE_X
				,Service_Cd_2               as   Service_Cd
				,VESSEL_CD_2                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_2    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_2    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_2		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_2         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_2        as   WATER_LAND_MODE_F
				,DIPLA_2                    as   DIPLA
				,LOPFI_2                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date 	
				from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'3' LocSeqX
				,RKST_SITE_CD_FROM_3        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_3        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_3          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_3          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_3        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_3          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_3             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_3             as   ARR_VOYAGE_X
				,Service_Cd_3               as   Service_Cd
				,VESSEL_CD_3                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_3    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_3    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_3		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_3         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_3        as   WATER_LAND_MODE_F
				,DIPLA_3                    as   DIPLA
				,LOPFI_3                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
				from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'4' LocSeqX
				,RKST_SITE_CD_FROM_4        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_4        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_4          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_4          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_4        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_4          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_4             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_4             as   ARR_VOYAGE_X
				,Service_Cd_4               as   Service_Cd
				,VESSEL_CD_4                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_4    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_4    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_4		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_4         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_4        as   WATER_LAND_MODE_F
				,DIPLA_4                    as   DIPLA
				,LOPFI_4                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
				from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'5' LocSeqX
				,RKST_SITE_CD_FROM_5        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_5        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_5          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_5          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_5        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_5          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_5             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_5             as   ARR_VOYAGE_X
				,Service_Cd_5               as   Service_Cd
				,VESSEL_CD_5                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_5    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_5    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_5		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_5         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_5        as   WATER_LAND_MODE_F
				,DIPLA_5                    as   DIPLA
				,LOPFI_5                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
				from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'6' LocSeqX
				,RKST_SITE_CD_FROM_6        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_6        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_6          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_6          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_6        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_6          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_6             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_6             as   ARR_VOYAGE_X
				,Service_Cd_6               as   Service_Cd
				,VESSEL_CD_6                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_6    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_6    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_6		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_6         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_6        as   WATER_LAND_MODE_F
				,DIPLA_6                    as   DIPLA
				,LOPFI_6                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
		from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'7' LocSeqX
				,RKST_SITE_CD_FROM_7        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_7        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_7          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_7          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_7        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_7          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_7             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_7             as   ARR_VOYAGE_X
				,Service_Cd_7               as   Service_Cd
				,VESSEL_CD_7                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_7    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_7    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_7		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_7         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_7        as   WATER_LAND_MODE_F
				,DIPLA_7                    as   DIPLA
				,LOPFI_7                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
		from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'8' LocSeqX
				,RKST_SITE_CD_FROM_8        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_8        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_8          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_8          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_8        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_8          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_8             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_8             as   ARR_VOYAGE_X
				,Service_Cd_8               as   Service_Cd
				,VESSEL_CD_8                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_8    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_8    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_8		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_8         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_8        as   WATER_LAND_MODE_F
				,DIPLA_8                    as   DIPLA
				,LOPFI_8                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
		from [ETLRepository].dbo.stg_RouteLinks
		union all
		SELECT 
				AUDITVERSIONID
				,SHIPMENT_NO_X
				,SHIPMENT_VRSN_ID_X
				,Booking_Date
				,'9' LocSeqX
				,RKST_SITE_CD_FROM_9        as   RKST_SITE_CD_FROM
				,RKST_CITY_CD_FROM_9        as   RKST_CITY_CD_FROM
				,RKST_SITE_CD_TO_9          as   RKST_SITE_CD_TO
				,RKST_CITY_CD_TO_9          as   RKST_CITY_CD_TO
				,MEPC_TRANS_MODE_X_9        as   MEPC_TRANS_MODE_X
				,ROUTE_LOC_SEQ_X_9          as   ROUTE_LOC_SEQ_X
				,DEP_VOYAGE_X_9             as   DEP_VOYAGE_X
				,ARR_VOYAGE_X_9             as   ARR_VOYAGE_X
				,Service_Cd_9               as   Service_Cd
				,VESSEL_CD_9                as   VESSEL_CD
				,DEP_LOCAL_EXPECTED_TS_9    as   DEP_LOCAL_EXPECTED_TS
				,ARR_LOCAL_EXPECTED_TS_9    as   ARR_LOCAL_EXPECTED_TS
				,DepUTCExpectedTs_9		  as   DepUTCExpectedTs
				,ArrUTCExpectedTs_9         as   ArrUTCExpectedTs
				,WATER_LAND_MODE_F_9        as   WATER_LAND_MODE_F
				,DIPLA_9                    as   DIPLA
				,LOPFI_9                    as   LOPFI
				,[Extract_Date]			  as   Extract_Date
		from [ETLRepository].dbo.stg_RouteLinks
		) as X;

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
		SET @V_STEP_NAME = 'Update flag that data for route links is consumed'
		SET @V_NOTE = 'Update flag that data for route links is consumed'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;

		--exec  [ETLRepository].[dbo].spMarkProcessDetailAsComplete @ProcessID = 6;
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
		SET @V_ERRORMESSAGE = 'Process to refresh RouteLinks failed: Err:' + @V_MSG
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

CREATE PROCEDURE [dbo].[USP_capInv_ad_rocks]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   USP_capInv_ad_rocks.SQL
* Date:       04/07/2017
*
* Application:  Loads Rocks data  from ETLRespository and creates AD_Rocks table
*               
* Parameters:   @v_AuditVersion_ID	== Audit Version
*				@V_ERROR_CODE		== Returned Error Code
*  				
* Input(s):		stg_rock
*				dim_rock_container
* Output(s):	CapInvRepository.dbo.AD_Rocks
*
* Assumptions: ETLReopository.dbo.stg_rocks table is updated
*
* Example Call: exec USP_capInv_ad_rocks 0, @V_ERROR_CODE OUTPUT
*
*
*****************************************************************************************************
* Notes:
*  Name					CREATED        Last Mod			Comments
*  DE\ELM               4/7/2017						Procedure Created
****************************************************************************************************/
	@v_AuditVersion_ID INT
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
							, @V_NOTE = 'Process Empties (ROCKS) data'
							, @V_START_STEP = 1;

		SET @V_STEP_ID = 10
		SET @V_STEP_NAME = 'Delete existinct ROCKSs data'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'Delete existing Rocks data';

		DELETE FROM Analyticsdatamart.dbo.AD_Rocks
		WHERE EXISTS (
			SELECT 1 FROM ETLRepository.dbo.stg_rocks (nolock) GG
			WHERE GG.VesselCode = AD_Rocks.VesselCode
				AND GG.voyage = AD_Rocks.voyage
				AND GG.servicecode = AD_Rocks.servicecode
				AND GG.PlaceFrom = AD_Rocks.departurePort
				AND GG.PlaceTo = AD_Rocks.arrivalport
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
		/******************************************************************
						Empties -- Rock Data
		*******************************************************************/
		SET @V_STEP_ID = 20
		SET @V_STEP_NAME = 'Pull ROCKSs data'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = 'Refresh the Empties (ROCKS) table';

		INSERT INTO Analyticsdatamart.dbo.AD_Rocks
		(
			AuditVersion_ID
			, VesselCode
			, voyage
			, servicecode
			, departurePort
			, arrivalport
			, departuredate
			, arrivaldate
			, vesseloperator
			, totalEmptyContainer
			, totalEmptyTEU
			, totalEmptyTons
		)
		SELECT @v_AuditVersion_ID
			    , VesselCode
				, a.voyage
				, a.servicecode
				, a.placefrom as departurePort
				, a.PlaceTo as arrivalport
				, cast(case when a.OriginDeparture = 'NULL' then a.toDate else a.OriginDeparture end as datetime) as departuredate
				, cast(a.ToDate as datetime) as arrivaldate
				, a.vesseloperator
				, sum(cast(ContainerAmount as float)) as totalEmptyContainer
				, sum((b.TEU) * cast(ContainerAmount as float)) as totalEmptyTEU
				, sum(cast(ContainerAmount as float) * b.emptyweightTons) as totalEmptyTons
		FROM 
		(
					SELECT row_number() over (partition by ottnumber,containertype order by updateddate, containerAmount desc) as recCnt
						  ,[OTTnumber]
						  ,[VesselOperator]
						  ,[VesselCode]
						  ,[VesselName]
						  ,[Voyage]
						  ,[ServiceCode]
						  ,[Line]
						  ,[PlaceFrom]
						  ,[FromDate]
						  ,[OriginDeparture]
						  ,[PlaceTo]
						  ,[VoyageTo]
						  ,[ToDate]
						  ,[DestinationDeparture]
						  ,[Status]
						  ,[ApprovedBy]
						  ,[ApprovedDate]
						  ,[InsertedBy]
						  ,[InsertDate]
						  ,[UpdatedBy]
						  ,[UpdatedDate]
						  ,[OTTType]
						  ,[Transport]
						  ,[COntainerType]
						  ,[ContainerStatus]
						  ,[containerAmount]
			from ETLRepository.dbo.stg_rocks (nolock) nn
			WHERE (nn.containertype like '%20%' or nn.containertype like '%40%' or nn.containertype like '%45%')
				and nn.ContainerStatus in ('A', 'S')
					AND [VesselCode] <> ''
		) a
		LEFT JOIN CapInvRepository.dbo.dim_rock_container b
		 ON a.COntainerType = b.RockcontainerSubtype
		where a.recCnt = 1
		GROUP BY a.VesselCode
				, a.voyage
				, a.servicecode
				, a.placefrom
				, a.PlaceTo
				, cast(case when a.OriginDeparture = 'NULL' then a.toDate else a.OriginDeparture end as datetime)
				, cast(a.ToDate as datetime)
				, a.vesseloperator;
			
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
		SET @V_ERRORMESSAGE = 'Process to refresh ROCKS failed: Err:' + @V_MSG
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
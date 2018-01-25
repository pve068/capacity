USE [AnalyticsDatamart]
GO

/****** Object:  StoredProcedure [dbo].[USP_IngestSchedule]    Script Date: 25-01-2018 10:39:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_IngestSchedule]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   USP_IngestSchedule.SQL
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
* Modification History:Added additional columns requested by commitment team
* Modified on:2018-JAN-25, Modified by :PVE068
****************************************************************************************************/
	 @V_AUDITVERSIONID INT = NULL
	 ,@V_PARENT_PROCESS_ID INT = 0
	 ,@V_PARENT_STEP_ID TINYINT
	 ,@V_ERROR_CODE INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON 
	--DECLARE VARIABLES
	DECLARE @V_ERRORMESSAGE NVARCHAR(4000)  
	DECLARE @V_MSG  NVARCHAR(4000)
	DECLARE @V_NOTE  NVARCHAR(4000)
	DECLARE @V_ERRORSEVERITY INT  
	DECLARE @v_ERRORSTATE INT

	DECLARE @V_PROCESS_ID INT = NEXT VALUE FOR DBO.SEQ_LOG_PROCESS_ID
	DECLARE @V_PROCESS_NAME VARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
	DECLARE @V_FIANLERROR INT
	DECLARE @V_SYSTEM_USER NVARCHAR(255) = SYSTEM_USER
	DECLARE @V_SYSTEMTIME DATETIME = GETUTCDATE()
	DECLARE @V_RECORD_CNT INT

	DECLARE @V_STEP_ID TINYINT
	DECLARE @V_STEP_NAME VARCHAR(255)

	BEGIN TRY
		-----------------------------------------------------------------------
		--Log Process		
		-----------------------------------------------------------------------
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
		SET @V_STEP_ID = @V_PARENT_STEP_ID + 1
		SET @V_STEP_NAME = 'Delete schedules with DELETE Flag'
		SET @V_NOTE = 'Delete schedules with DELETE Flag'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;
		-----------------------------------------------------------------------
		--DELETE ROWS which have delete flag
		-----------------------------------------------------------------------
		DELETE AA
		FROM DBO.SCHEDULE AA
		INNER JOIN (Select * from [ETLRepository].DBO.STG_CAP_SCHEDULE Where TransType like 'DELETE') GG
		 ON RTRIM(AA.VESSELCODE) = RTRIM(GG.VESSELCODE)
		AND RTRIM(AA.[DEPVOYAGE]) = RTRIM(GG.[DEPVOYAGE])
		AND RTRIM(AA.[DEPSERVICECODE]) = RTRIM(GG.[DEPSERVICECODE])
		AND RTRIM(AA.SITE_CODE) = RTRIM(GG.SITE_CODE)
		and GG.[AuditVersionID] = CASE when @V_AuditVersionID is null then 0 else @V_AuditVersionID end 
		OPTION (MAXDOP 8);
		-----------------------------------------------------------------------
		--DELETE ROWS which have Insert/Update flag
		-----------------------------------------------------------------------
		SET @V_STEP_ID = @V_STEP_ID + 1
		SET @V_STEP_NAME = 'Delete existing schedules with Insert/update Flag'
		SET @V_NOTE = 'Delete existing schedules with Insert/update Flag'
		EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = @V_PROCESS_ID
  					, @V_STEP_ID = @V_STEP_ID
  					, @V_STEP_NAME = @V_STEP_NAME
  					, @V_START_DT = @V_SYSTEMTIME
  					, @V_END_DT = NULL
  					, @V_STATUS = 'RUNNING'
  					, @V_ROWS_PROCESSED = NULL
  					, @V_ACTION = 1
  					, @V_NOTE = @V_NOTE;
		-----------------------------------------------------------------------
		DELETE AA
		FROM DBO.SCHEDULE AA
		INNER JOIN (Select * from [ETLRepository].DBO.STG_CAP_SCHEDULE Where TransType Not like 'DELETE') GG
		 ON RTRIM(AA.VESSELCODE) = RTRIM(GG.VESSELCODE)
		AND RTRIM(AA.[DEPVOYAGE]) = RTRIM(GG.[DEPVOYAGE])
		AND RTRIM(AA.[DEPSERVICECODE]) = RTRIM(GG.[DEPSERVICECODE])
		AND RTRIM(AA.SITE_CODE) = RTRIM(GG.SITE_CODE)
		and GG.[AuditVersionID] = CASE when @V_AuditVersionID is null then 0 else @V_AuditVersionID end 
		OPTION (MAXDOP 8);
		------------------------------------------------------------------------
		SET @V_RECORD_CNT = @@ROWCOUNT
		SET @V_SYSTEMTIME = GETUTCDATE()
		------------------------------------------------------------------------	
		--Update Detail 
		------------------------------------------------------------------------
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
		SET @V_STEP_ID = @V_STEP_ID + 1
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

			-----------------------------------------------------------------------------------------
			select rtrim([VesselCode]) as VesselCode,rtrim([DepVoyage]) as DepVoyage
			,rtrim([DepServiceCode]) as DepServiceCode
			,rtrim([Site_Code]) as Site_Code
			,max(coalesce(auditversionid,-99)) as auditversionid
			into #tmpScheduleData
			from [ETLRepository].dbo.[Stg_cap_Schedule]
			WHERE CASE when AUDITVERSIONID is null then 0 else AUDITVERSIONID end 
			= case when @V_AuditVersionID is null then 0 else @V_AuditVersionID end
			and UPPER(TransType) Not like 'DELETE'
			group by rtrim([VesselCode]),rtrim([DepVoyage]),rtrim([DepServiceCode]),rtrim([Site_Code]);
			-----------------------------------------------------------------------------------------
			;with tmp_data as
			(
				SELECT  a.[AuditVersionId]
				   ,rtrim(a.[VesselCode]) as [VesselCode]
				   ,rtrim([VesselName]) as [VesselName]
				   ,rtrim([VesselOperator]) as [VesselOperator]
				   ,rtrim(a.[DepServiceCode]) as [DepServiceCode]
				   ,rtrim([DepServiceDir]) as [DepServiceDir]
				   ,rtrim(a.[DepVoyage]) as [DepVoyage]
				   ,rtrim([Dep_Stat]) as [Dep_Stat]
				   ,[SchDepartureDate]
				   ,[ActDepartureDate]
				   ,[SchDepartureDateUTC]
				   ,[ActDepartureDateUTC]
				   ,rtrim(a.[Site_Code]) as [Site_Code]
				   ,rtrim([ArrVoyage]) as [ArrVoyage]
				   ,rtrim([ArrServiceCode]) as [ArrServiceCode]
				   ,rtrim([ArrServiceDir]) as [ArrServiceDir]
				   ,rtrim([Arr_Stat]) as [Arr_Stat]
				   ,[SchArrivalDate]
				   ,[ActArrivalDate]
				   ,[SchArrivalDateUTC]
				   ,[ActArrivalDateUTC]
				   ,[Vessel_Capacity_TEU]
				   ,[TEU]
				   ,[DirArrival1Code]
				   ,[SiteOrderVal]
				   ,[OmitMarkInd]
				   ,[NextRKSTCode]
				   ,[GeoCode]
				   ,[ArrDate]
				   ,[DepDate]
				   ,[ArrDateUTC]
				   ,[DepDateUTC]
				   ,row_number() over (partition by rtrim(a.[VesselCode]),rtrim(a.[DepVoyage]),rtrim(a.[DepServiceCode]),rtrim(a.[Site_Code])  
				   order by coalesce(a.[AuditVersionId],-99)) as rnk
		  FROM 
			[ETLRepository].dbo.[Stg_cap_Schedule] a
		  inner join #tmpScheduleData gg
		  on 
			rtrim(a.[VesselCode]) = gg.[VesselCode]
			and rtrim(a.[DepVoyage]) = gg.[DepVoyage]
			and rtrim(a.[DepServiceCode]) = gg.[DepServiceCode]
			and rtrim(a.[Site_Code]) = gg.[Site_Code]
			and coalesce(a.[AuditVersionId],-99) = coalesce(gg.[AuditVersionId],-99)
		   Where 
			UPPER(a.TransType) Not like 'DELETE'
		)
		INSERT INTO [dbo].[Schedule]
		(	
			[AuditVersionId]
			,[VesselCode]
			,[VesselName]
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
			,[ArrServiceCode]
			,[ArrServiceDir]
			,[Arr_Stat]
			,[SchArrivalDate]
			,[ActArrivalDate]
			,[SchArrivalDateUTC]
			,[ActArrivalDateUTC]
			,[Vessel_Capacity_TEU]
			,[TEU] 
			,[DirArrival1Code]
			,[SiteOrderVal]
			,[OmitMarkInd]
			,[NextRKSTCode]
			,[GeoCode]
			,[ArrDate]
			,[DepDate]
			,[ArrDateUTC]
			,[DepDateUTC]   
		)
		SELECT  
			 [AuditVersionId]
			,[VesselCode]
			,[VesselName]
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
			,[ArrServiceCode]
			,[ArrServiceDir]
			,[Arr_Stat]
			,[SchArrivalDate]
			,[ActArrivalDate]
			,[SchArrivalDateUTC]
			,[ActArrivalDateUTC]
			,[Vessel_Capacity_TEU]
			,[TEU]
			,[DirArrival1Code]
			,[SiteOrderVal]
			,[OmitMarkInd]
			,[NextRKSTCode]
			,[GeoCode]
			,[ArrDate]
			,[DepDate]
			,[ArrDateUTC]
			,[DepDateUTC]
		from tmp_data
		where rnk = 1
		OPTION (MAXDOP 8);	
		-----------------------------------------------------------------------
		  SET @V_RECORD_CNT = @@ROWCOUNT
		  SET @V_SYSTEMTIME = GETUTCDATE()
		-----------------------------------------------------------------------	
		  --Update Detail 
		-----------------------------------------------------------------------
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

		Delete from ETLRepository.[DBO].STG_CAP_Schedule
		Where AuditVersionID = @V_AuditVersionID

		-----------------------------------------------------------------------
		SET @V_ERROR_CODE = 0
		RETURN @V_ERROR_CODE
		-----------------------------------------------------------------------
	END TRY
	BEGIN CATCH
		SET @V_MSG = coalesce(ERROR_PROCEDURE() +' Line:'+cast(ERROR_LINE() as varchar(10))+' Message:' +ERROR_MESSAGE(),'')
		SET @V_ERRORMESSAGE = 'Process to refresh Schedues (GSIS) data failed: Err:' + @V_MSG
		SET @V_ERRORSEVERITY = ERROR_SEVERITY()  
		SET @V_SYSTEMTIME = GETUTCDATE()
		SET @v_ERRORSTATE = ERROR_STATE()
		-----------------------------------------------------------------------
		--UPdate Detail 
		-----------------------------------------------------------------------
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
		-----------------------------------------------------------------------
		--Update Process --Complete Process
		-----------------------------------------------------------------------
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
		-----------------------------------------------------------------------
		RAISERROR(@V_ERRORMESSAGE,@V_ERRORSEVERITY,@v_ERRORSTATE)
		--SET @V_ERROR_CODE = -1
		--RETURN @V_ERROR_CODE
		-----------------------------------------------------------------------
	END CATCH
END




GO



/****** Object:  StoredProcedure [dbo].[USP_LOG_PROCESS_DETAIL]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_LOG_PROCESS_DETAIL]
  /****************************************************************************************************
  * COPYRIGHT REVENUE ANALYTICS 2017
  * ALL RIGHTS RESERVED
  *
  * CREATED BY: DATA ENGINEERING
  * FILENAME:   PKG_RA_USER_UTILITY.PKG
  * DATE:       04/18/2017
  *
  * APPLICATION:  LOG DETAIL OF PROCESS FROM P_PROCESS_LOG. DATA IS STORED IN RA_PROCESS_LOG_DETAIL
  *
  * PARAMETERS:      @V_PROCESS_ID      ID OF PROCESS RUNNING
  *                  @V_STEP_ID         STEP ID IN PROCESS BEING RAN
  *                  @V_STEP_NAME       NAME OF THE STEP BEING RAN
  *                  @V_START_DT        WHEN THE STEP STARTED
  *                  @V_END_DT          WHEN THE STEP ENDED
  *                  @V_STATUS          STATUS OF THE STEP
  *                  @V_ROWS_PROCESSED  NUMBER OF ROWS PROCESSED
  *                  @V_ACTION             ACTION TO BE TAKEN, 1= PRCESS STARTED, 2 = PROCESS ENDED
  *                  @V_NOTE               NOTE. YOU CAN MAKE NOTE WHAT YOU WNAT BUT SHOULD BE DESCRIPTIVE TO PROCESS
  *
  * ASSUMPTIONS:  THERE IS AN EXISTING PROCEDD_ID
  *
  * EXAMPLE CALL: EXEC dbo.USP_LOG_PROCESS_DETAIL @V_PROCESS_ID = 102
  *					, @V_PROCESS_NAME = 'SP_capInv_RouteLegs_schedule'
  *					, @V_STEP = 1
  *					, @V_STEP_NAME = 'TRUNCATE TABLE DBO.TEST FOR PERIOD'
  *					, @V_START_DT = @SYSTEMTIME
  *					, @V_END_DT = NULL
  *					, @V_STATUS = 'RUNNING'
  *					, @V_ROWS_PROCESSED = 2000
  *					, @V_ACTION = 1
  *					, @V_NOTE = 'DATA BEING LOADED FOR PERIOD';
  *
  *
  *****************************************************************************************************
  * NOTES:
  *  NAME             LAST MOD       COMMENTS
  *  DE                    1/7/2013        CREATED
  ****************************************************************************************************/       
    @V_PROCESS_ID      BIGINT,
    @V_STEP_ID         INT,
    @V_STEP_NAME       VARCHAR(255),
    @V_START_DT        DATETIME,
    @V_END_DT          DATETIME,
    @V_STATUS          VARCHAR(10),
    @V_ROWS_PROCESSED  BIGINT,
    @V_ACTION          TINYINT,
    @V_NOTE            NVARCHAR(2000)
AS
  BEGIN
    DECLARE @V_IN_NOTE NVARCHAR(2000)
	DECLARE @Post_Date datetime = getutcdate()
	DECLARE @ErrorMessage NVARCHAR(4000)  
	DECLARE @ErrorSeverity INT  

	BEGIN TRY
		SET @V_IN_NOTE = SUBSTRING(REPLACE(@V_NOTE, '''', ''''''), 1,  2000);
		--PROCESS START
		IF @V_ACTION = 1 
		BEGIN
			BEGIN TRANSACTION
			  INSERT INTO DBO.ML_PROCESS_LOG_DETAIL(PROCESS_ID, STEP_ID,STEP_NAME, START_DT, END_DT, ACTION, STATUS, ROWS_PROCESSED, NOTE)
					VALUES(@V_PROCESS_ID, @V_STEP_ID,@V_STEP_NAME,  @V_START_DT, @V_END_DT, @V_ACTION,@V_STATUS, @V_ROWS_PROCESSED, @V_IN_NOTE);
			COMMIT TRANSACTION
		END

		--PROCESS END
		IF @V_ACTION = 2 
		BEGIN
			BEGIN TRANSACTION
			  UPDATE  DBO.ML_PROCESS_LOG_DETAIL
			  SET     STATUS = @V_STATUS
						, END_DT = @V_END_DT
						, ROWS_PROCESSED = @V_ROWS_PROCESSED
						, ACTION = @V_ACTION
						, NOTE = @V_IN_NOTE
			  WHERE   PROCESS_ID = @V_PROCESS_ID
			  AND     STEP_ID = @V_STEP_ID;
			COMMIT TRANSACTION      
		END;
	END TRY
	begin catch
		SELECT   @ErrorMessage = ERROR_MESSAGE(),  
				 @ErrorSeverity = ERROR_SEVERITY()  

		ROLLBACK TRANSACTION  
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1) 
	end catch
end

GO

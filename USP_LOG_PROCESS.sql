/****** Object:  StoredProcedure [dbo].[USP_LOG_PROCESS]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_LOG_PROCESS]
  /****************************************************************************************************
  * COPYRIGHT REVENUE ANALYTICS 2017
  * ALL RIGHTS RESERVED
  *
  * CREATED BY: DATA ENGINEERING
  * FILENAME:   PKG_RA_USER_UTILITY.PKG
  * DATE:       04/18/2017
  *
  * APPLICATION:  LOG PROCESS THAT IS CURRENTLY BEING RUN. FOR EXAMPLE A STORED PROCEDURE
  *
  * PARAMETERS:    PROCESS_ID         THE ID OF THE PROCESS BEING RAN
  *                PROCESS_NAME       THE NAME OF THE PROCESS
  *                USER_NAME          NAME OF USER RUNNING PROCESS
  *                START_DT           START DATE OF PROCESS
  *                END_DT             END DATE OF PROCESS
  *                STATUS             PROCESS STATUS. COULD BE RUNNING, FAILED, SUCESS
  *                ACTION             ACTION TO BE TAKEN, 1= PRCESS STARTED, 2 = PROCESS ENDED
  *                PARENT_PROCESS_ID  ID OF PROCESS DOING THE CALLING OF CURRENT PROCESS. NULL if no process doing the calling
  *                NOTE               NOTE. YOU CAN MAKE NOTE WHAT YOU WANT BUT SHOULD BE DESCRIPTIVE TO PROCESS
  *                START_STEP         THE STEP THAT WAS STARTED. DEFAULT IS 1
  *
  * ASSUMPTIONS:  
  *
  * EXAMPLE CALL: EXEC dbo.USP_LOG_PROCESS @V_PROCESS_ID = 102
  *					, @V_PROCESS_NAME = 'SP_capInv_RouteLegs_schedule'
  *					, @V_USER_NAME = @SYSTEM_USER
  *					, @V_START_DT = @SYSTEMTIME
  *					, @V_END_DT = NULL
  *					, @V_STATUS = 'RUNNING'
  *					, @V_ACTION = 1
  *					, @V_PARENT_PROCESS_ID = 1000
  *					, @V_NOTE = 'DATA BEING LOADED FOR PERIOD'
  *					, @V_START_STEP = 1;
  *
  *****************************************************************************************************
  * NOTES:
  *  NAME             LAST MOD       COMMENTS
  *  DE                    1/7/2013        CREATED
  ****************************************************************************************************/     
    @V_PROCESS_ID    INT,
    @V_PROCESS_NAME  VARCHAR(50),
	@V_USER_NAME	 NVARCHAR(255),
    @V_START_DT      DATETIME,
    @V_END_DT        DATETIME,
    @V_STATUS        VARCHAR(25),
    @V_ACTION        TINYINT,
    @V_PARENT_PROCESS_ID INT,
    @V_NOTE          VARCHAR(2000),
    @V_START_STEP    TINYINT = 1
AS
BEGIN
    DECLARE @V_IN_NOTE NVARCHAR(2000)
	DECLARE @Post_Date datetime = getutcdate()
	DECLARE @ErrorMessage NVARCHAR(4000)  
	DECLARE @ErrorSeverity TINYINT  

	BEGIN TRY
		SET @V_IN_NOTE = SUBSTRING(REPLACE(@V_NOTE, '''', ''''''), 1,  2000);
		--PROCESS START
		IF @V_ACTION = 1 
		BEGIN
			BEGIN TRANSACTION 
			  INSERT INTO DBO.ML_PROCESS_LOG(PROCESS_ID, PROCESS_NAME, USER_NAME, START_DT, END_DT,ACTION, START_STEP, STATUS, NOTE, PARENT_PROCESS_ID)
			  VALUES(@V_PROCESS_ID, @V_PROCESS_NAME, @V_USER_NAME, @V_START_DT, @V_END_DT, @V_ACTION, @V_START_STEP, @V_STATUS, @V_NOTE, @V_PARENT_PROCESS_ID)
			COMMIT TRANSACTION 
		END
		--PROCESS END
		IF @V_ACTION = 2 
		BEGIN
			BEGIN TRANSACTION
			  UPDATE  DBO.ML_PROCESS_LOG
			  SET		STATUS = @V_STATUS, 
						END_DT = @V_END_DT,
						ACTION = @V_ACTION, 
						NOTE = @V_NOTE
			  WHERE   PROCESS_ID = @V_PROCESS_ID 
			COMMIT TRANSACTION
		END
	END TRY
	begin catch
		SELECT   @ErrorMessage = ERROR_MESSAGE(),  
				 @ErrorSeverity = ERROR_SEVERITY()  

		ROLLBACK TRANSACTION  
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1)   
	end catch
end
	
GO

/****** Object:  StoredProcedure [dbo].[usp_getAuditVersionID]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_getAuditVersionID]
/****************************************************************************************************
* Copyright REVENUE ANALYTICS 2017
* All Rights Reserved
*
* Created By: DATA ENGINEERING
* FileName:   usp_getAuditVersionID.SQL
* Date:       06/21/2017
*
* Application:  Function that returnd an audit version ID
*               
* Parameters:   @V_AUDITDATE == UTC Date of the audit version id you need
*
* Assumptions: Table dbo.AUDITVERSIONMASTER exists. NULL date passed means today's date
*
* EXAMPLE CALL:  DECLARE @V_AUDITVERSIONIDIN INT
*				 exec @V_AUDITVERSIONIDIN = dbo.usp_getAuditVersionID NULL, @V_AUDITVERSIONIDIN output
*****************************************************************************************************
* Notes:
*  Name					CREATED        Last Mod			Comments
*  DE\ELM               6/21/2017						Procedure Created
****************************************************************************************************/
(@V_AUDITDATE DATE=NULL, @V_AUDITVERSIONID INT OUTPUT)
AS
BEGIN
	DECLARE @V_AUDITVERSIONIDIN INT

	SET @V_AUDITDATE = COALESCE(@V_AUDITDATE, GETUTCDATE())

	BEGIN TRY
		-- CHECK AND SEE IF THE DATE FOR THE AUDIT VERSION EXISTS
		IF NOT EXISTS (
						SELECT 1 
						FROM DBO.AUDITVERSIONMASTER 
						WHERE CAST(AUDITVERSIONTS AS DATE) = CAST(@V_AUDITDATE AS DATE)
					 )
			INSERT INTO DBO.AUDITVERSIONMASTER(AUDITVERSIONTS) VALUES (GETUTCDATE())

		SELECT @V_AUDITVERSIONIDIN = AUDITVERSIONID 
		FROM DBO.AUDITVERSIONMASTER 
		WHERE CAST(AUDITVERSIONTS AS DATE) = CAST(@V_AUDITDATE AS DATE)
		
		-- RETURN New Audit version
		RETURN @V_AUDITVERSIONIDIN
	END TRY
	BEGIN CATCH
		SET @V_AUDITVERSIONIDIN = -1
		RETURN @V_AUDITVERSIONIDIN
	END CATCH
END

GO
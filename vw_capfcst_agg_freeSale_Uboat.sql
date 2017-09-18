USE [AnalyticsDatamart]
GO

/****** Object:  View [dbo].[vw_capfcst_agg_freeSale_Uboat]    Script Date: 14-09-2017 15:52:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




IF ( OBJECT_ID('DBO.vw_capfcst_agg_freeSale_Uboat', 'V') IS NOT NULL ) 
   DROP VIEW DBO.vw_capfcst_agg_freeSale_Uboat
GO


CREATE view [dbo].[vw_capfcst_agg_freeSale_Uboat] as select * from  ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT

GO



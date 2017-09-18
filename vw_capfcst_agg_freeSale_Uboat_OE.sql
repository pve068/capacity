USE [AnalyticsDatamart]
GO

/****** Object:  View [dbo].[vw_capfcst_agg_freeSale_Uboat_OE]    Script Date: 14-09-2017 15:51:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF ( OBJECT_ID('DBO.vw_capfcst_agg_freeSale_Uboat_OE', 'V') IS NOT NULL ) 
   DROP VIEW DBO.vw_capfcst_agg_freeSale_Uboat_OE
GO

CREATE view [dbo].[vw_capfcst_agg_freeSale_Uboat_OE] as 
select    id
		, a.runId
		, a.rundate
		, serviceCodeDirection as direction
		, vesselCode
		, voyage
		, serviceCode
		, left(departurePort,5) as Port
		, departurePort as fromLegSiteCode

		, arrivalport as toLegSiteCode
		, legSeqId
		, cast(departuredate as date) as departureDate
		, cast(arrivalDate as date) as arrivalDate
		, (allocationTEU * 1.0) / 2 as totalMSKAllocationFFE
		, allocationTons as totalMSKAllocationMTS
		, allocationPlugs as totalMSKAllocationPlugs
		, (totalCommitfilingsTeU * 1.0) / 2 as commitConsumptionFFE
		, totalCommitfilingsTons as commitConsumptionMTS
		, totalCommitfilingsPlugs as commitConsumptionPlugs
		
		, (freesaleConsumptionTeU * 1.0) / 2 as freesaleConsumptionFFE
		, freesaleConsumptionTons as freesaleConsumptionMTS
		, freesaleConsumptionPlugs as freesaleConsumptionPlugs

		, remaining_freesaleFFE as remainingFreesaleFFE
		, remaining_freesaleTeU as remainingFreesaleTeU
		, remaining_freesaleTons as remainingFreesaleTons
		, remaining_freesalePlugs as remainingFreesalePlugs
		, isc as ISC
		, cast(0.0 as numeric(10,4)) as OverbookingLevel
from  AnalyticsDatamart.dbo.AD_CAPFCST_FREESALE_UBOAT a
where a.rundate >= '2017-08-25';
GO



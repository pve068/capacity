USE [AnalyticsDatamart]
GO

/****** Object:  View [dbo].[vw_capfcst_agg_freeSale_Uboat_USER]    Script Date: 14-09-2017 15:49:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF ( OBJECT_ID('DBO.vw_capfcst_agg_freeSale_Uboat_USER', 'V') IS NOT NULL ) 
   DROP VIEW DBO.vw_capfcst_agg_freeSale_Uboat_USER
GO


CREATE view [dbo].[vw_capfcst_agg_freeSale_Uboat_USER] as 
select	id
		, A.runid
		, A.rundate
		, VesselCode as Vessel
		, voyage
		, ServiceCode as Service
		, ServiceCodeDirection as [Service code direction]
		, departurePort as [Departure PortCall]
		, arrivalport as [Arrival PortCall]
		, LegSeqId
		, cast(departuredate as date) as Departure
		, cast(Arrivaldate as date) as Arrival
		, AllocationTEU as [MSK allocation TEU]
		, AllocationTons as [MSK allocation MTS]
		, AllocationPlugs as [MSK allocation plugs]

		, cast(round(totalemptyTeU,0) as int) as [Empty allocation TEU]
		, cast(round(totalemptyTons,0) as int) as [Empty allocation MTS]

		, cast(totalcommitfilingsTeU as int) as [Commitment allocation TEU]
		, cast(round(totalcommitfilingsTons,0) as int) as [Commitment allocation MTS]
		, cast(totalcommitfilingsPlugs as int) as [Commitment allocation plugs]

		, cast(totalcommitfilingsTeU as int) as [Commitment Consumption TEU]
		, cast(round(totalcommitfilingsTons,0) as int) as [Commitment Consumption MTS]
		, cast(totalcommitfilingsPlugs as int) as [Commitment Consumption plugs]

		--, cast(freesale_availableNoOverBookTeU as int) as [Freesale available TEU - before overbooking]
		, cast(freesaleallocationTeU as int) as [Freesale available TEU - before overbooking]
		, cast(round(freesale_availableNoOverBookTons,0) as int) as [Freesale available MTS - before overbooking]
		, cast(freesale_availableNoOverBookPlugs as int) as [Freesale available plugs - before overbooking]

		, cast(freesale_availableTeU as int) as [Freesale available TEU - incl.  overbooking]
		, cast(round(freesale_availableTons,0) as int) as [Freesale available MTS - incl.  overbooking]
		, cast(freesale_availablePlugs as int) as [Freesale available plugs - incl.  overbooking]

		, cast(FreesaleConsumptionTeU as int) as [Freesale consumption TEU]
		, cast(FreesaleDisplacementTEU as int) as [OOG Displacement TEU]
		, cast(ConsumptionDisplacementTeU as int) as [Freesale consumption and displacement TEU total]
		, cast(round(freesaleConsumptionTons,0) as int) as [Freesale consumption MTS]
		, cast(freesaleConsumptionPlugs as int) as [Freesale consumption plugs]
		
		, cast(remaining_freesaleTEU as int)  as [Remaining capacity TEU - before OOG displacement]
		, cast(remaining_freesaledisplacementTEU as int) as [Remaining capacity TEU - incl. OOG displacement]

		, cast(round(remaining_freesaleTons,0) as int) as [Remaining capacity MTS]
		, cast(remaining_freesalePlugs as int) as [Remaining capacity Plugs]
		, isc as [ISC indicator (Lead trade / ISC1)]
from  ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT AS a
where a.rundate = (select max(rundate) from ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT (nolock));

GO



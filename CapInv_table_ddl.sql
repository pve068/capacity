USE [CapInvRepository]
GO
/****** Object:  Table [dbo].[ad_capfcst_FreeSale_UBoat_tmp]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ad_capfcst_FreeSale_UBoat_tmp](
	[id] [int] NOT NULL,
	[runid] [int] NOT NULL,
	[rundate] [datetime] NOT NULL,
	[voyage] [varchar](10) NOT NULL,
	[VesselCode] [varchar](5) NOT NULL,
	[servicecode] [varchar](10) NOT NULL,
	[LegSeqId] [int] NOT NULL,
	[ServiceCodeDirection] [varchar](30) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[freesaleDisplacementTEU] [decimal](38, 4) NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[ConsumptionDisplacementTeU] [decimal](38, 2) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 6) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 6) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL,
	[OVERBOOKPCT] [numeric](10, 5) NULL,
 CONSTRAINT [pk_AD_CAPFCST_FREESALE_UBOAT_TMP_all] PRIMARY KEY CLUSTERED 
(
	[runid] ASC,
	[rundate] ASC,
	[voyage] ASC,
	[VesselCode] ASC,
	[servicecode] ASC,
	[LegSeqId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ad_capinv_FreeSale_opt_Output]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ad_capinv_FreeSale_opt_Output](
	[id] [bigint] NULL,
	[RunId] [int] NULL,
	[Vessel] [varchar](5) NULL,
	[voyage] [varchar](10) NULL,
	[Service] [varchar](10) NULL,
	[ServiceCodeDirection] [varchar](10) NULL,
	[Departure PortCall] [varchar](50) NULL,
	[Arrival PortCall] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[Departure] [date] NULL,
	[Arrival] [date] NULL,
	[Remaining capacity FFE] [float] NULL,
	[Remaining capacity TEU] [float] NULL,
	[Remaining capacity MTS] [float] NULL,
	[Remaining capacity Plugs] [numeric](14, 1) NULL,
	[ISC] [varchar](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ad_capinv_FreeSale_opt_user_Output]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ad_capinv_FreeSale_opt_user_Output](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[Vessel] [varchar](5) NULL,
	[voyage] [varchar](10) NULL,
	[Service] [varchar](10) NULL,
	[Service code direction] [varchar](10) NULL,
	[Departure PortCall] [varchar](50) NULL,
	[Arrival PortCall] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[Departure] [date] NULL,
	[Arrival] [date] NULL,
	[MSK allocation TEU] [int] NULL,
	[MSK allocation MTS] [float] NULL,
	[MSK allocation plugs] [int] NULL,
	[Empty allocation TEU] [int] NULL,
	[Empty allocation MTS] [int] NULL,
	[Commitment allocation TEU] [int] NULL,
	[Commitment allocation MTS] [int] NULL,
	[Commitment allocation plugs] [int] NULL,
	[Freesale available TEU - before overbooking] [int] NULL,
	[Freesale available MTS - before overbooking] [int] NULL,
	[Freesale available plugs - before overbooking] [int] NULL,
	[Freesale available TEU - incl.  overbooking] [int] NULL,
	[Freesale available MTS - incl.  overbooking] [int] NULL,
	[Freesale available plugs - incl.  overbooking] [int] NULL,
	[Freesale consumption TEU] [int] NULL,
	[OOG Displacement TEU] [int] NULL,
	[Freesale consumption and displacement TEU total] [int] NULL,
	[Freesale consumption MTS] [int] NULL,
	[Freesale consumption plugs] [int] NULL,
	[Remaining capacity TEU - before OOG displacement] [int] NULL,
	[Remaining capacity TEU - incl. OOG displacement] [int] NULL,
	[Remaining capacity MTS] [int] NULL,
	[Remaining capacity Plugs] [int] NULL,
	[ISC indicator (Lead trade / ISC1)] [varchar](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ad_capinv_FreeSale_UBoat]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ad_capinv_FreeSale_UBoat](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[ServiceCodeDirection] [varchar](10) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesale_availableNoOverBookTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[DisplacementTEU] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[freesaleConsumptionDisplacementTeU] [decimal](38, 2) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 6) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 6) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AD_Displacement_OOG]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AD_Displacement_OOG](
	[Auditversion_ID] [bigint] NOT NULL,
	[Shipment_No] [varchar](9) NOT NULL,
	[ShipmentversionId] [varchar](13) NOT NULL,
	[servicecode] [varchar](3) NOT NULL,
	[DisplacementFFE] [decimal](15, 1) NULL,
	[DisplacementTEU] [decimal](15, 4) NULL,
	[FFE] [decimal](15, 1) NULL,
	[TeU] [decimal](15, 4) NULL,
	[FFEWithOOG] [decimal](15, 1) NULL,
	[TEUWithOOG] [int] NULL,
 CONSTRAINT [pk_OOG] PRIMARY KEY CLUSTERED 
(
	[Auditversion_ID] ASC,
	[Shipment_No] ASC,
	[ShipmentversionId] ASC,
	[servicecode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AD_Rocks]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AD_Rocks](
	[Auditversion_ID] [bigint] NOT NULL,
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departurePort] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[vesseloperator] [varchar](50) NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AD_ROCKS_bak]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AD_ROCKS_bak](
	[Auditversion_ID] [bigint] NOT NULL,
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departurePort] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[vesseloperator] [varchar](50) NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AD_Schedule]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AD_Schedule](
	[Service] [varchar](50) NULL,
	[Vessel] [varchar](10) NULL,
	[Depvoyage] [varchar](10) NULL,
	[site_code] [varchar](50) NULL,
	[original_etd] [datetime] NULL,
	[actual_etd] [datetime] NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AGG_CAPFCST_FREESALECONSUMPTION]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AGG_CAPFCST_FREESALECONSUMPTION](
	[RUNID] [int] NULL,
	[RUNDATE] [date] NULL,
	[VESSEL] [varchar](50) NULL,
	[VOYAGE] [varchar](50) NULL,
	[SERVICECODE] [varchar](50) NULL,
	[DEPARTUREPORT] [varchar](50) NULL,
	[ARRIVALPORT] [varchar](50) NULL,
	[DEPARTUREDATE] [datetime] NULL,
	[ARRIVALDATE] [datetime] NULL,
	[serviceCodeDirection] [varchar](50) NULL,
	[LEGSEQID] [bigint] NULL,
	[CONSUMPTIONTEU] [decimal](38, 2) NULL,
	[CUMMTEU] [decimal](38, 2) NULL,
	[CONSUMPTIONGROSSWEIGHTTONS] [numeric](38, 6) NULL,
	[CUMMGROSSWEIGHTTONS] [numeric](38, 6) NULL,
	[CONSUMPTIONPLUGS] [int] NULL,
	[CUMMPLUGS] [int] NULL,
	[DISPLACEMENTFFE] [decimal](38, 1) NULL,
	[DISPLACEMENTTEU] [decimal](38, 4) NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [decimal](38, 4) NULL,
	[FFEWITHOOG] [decimal](38, 1) NULL,
	[TEUWITHOOG] [int] NULL,
	[COMMITMENTTEU] [decimal](38, 2) NULL,
	[CUMMCOMMITMENTTEU] [decimal](38, 2) NULL,
	[COMMITMENTGROSSWEIGHTTONS] [numeric](38, 6) NULL,
	[CUMMCOMMITMENTTONS] [numeric](38, 6) NULL,
	[COMMITMENTPLUGS] [int] NULL,
	[CUMMCOMMITMENTPLUGS] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_capinv_freesaleConsumption]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_capinv_freesaleConsumption](
	[bkg_dp] [int] NULL,
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](10) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalPort] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[LegSeqId] [bigint] NULL,
	[ConsumptionTEU] [decimal](38, 2) NULL,
	[cummTEU] [decimal](38, 2) NULL,
	[ConsumptionGrossweightTons] [numeric](38, 6) NULL,
	[cummgrossweightTons] [numeric](38, 6) NULL,
	[ConsumptionPlugs] [int] NULL,
	[cummPlugs] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[DisplacementTEU] [int] NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [int] NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[TEUWithOOG] [int] NULL,
	[commitmentTEU] [decimal](38, 2) NULL,
	[cummcommitmentTEU] [decimal](38, 2) NULL,
	[CommitmentGrossweightTons] [numeric](38, 6) NULL,
	[cummCommitmentTons] [numeric](38, 6) NULL,
	[CommitmentPlugs] [int] NULL,
	[cummCommitmentPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Agg_Empty_MainLine]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Agg_Empty_MainLine](
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[legseqid] [bigint] NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Agg_Empty84K]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Agg_Empty84K](
	[VESSELCODE] [varchar](50) NOT NULL,
	[VOYAGE] [varchar](50) NOT NULL,
	[SERVICECODE] [varchar](50) NOT NULL,
	[DEPARTUREPORT] [varchar](50) NULL,
	[ARRIVALPORT] [varchar](50) NULL,
	[LEGSEQID] [bigint] NULL,
	[TOTALEMPTYCONTAINER] [float] NULL,
	[TOTALEMPTYTEU] [float] NULL,
	[TOTALEMPTYTONS] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Agg_Empty84K_25B]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Agg_Empty84K_25B](
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[legseqid] [bigint] NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Agg_Empty84K_26B]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Agg_Empty84K_26B](
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[legseqid] [bigint] NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freeSale_Uboat]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freeSale_Uboat](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[rundate] [datetime] NOT NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[ServiceCodeDirection] [varchar](30) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesale_availableNoOverBookTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[DisplacementTEU] [decimal](38, 4) NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[freesaleConsumptionDisplacementTeU] [decimal](38, 2) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 6) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 6) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freeSale_Uboat_bak]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freeSale_Uboat_bak](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[ServiceCodeDirection] [varchar](30) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesale_availableNoOverBookTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[DisplacementTEU] [decimal](38, 1) NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[freesaleConsumptionDisplacementTeU] [decimal](38, 1) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 6) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 6) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freeSale_Uboat_MainLine]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freeSale_Uboat_MainLine](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[rundate] [datetime] NOT NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[ServiceCodeDirection] [varchar](30) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[freesaleDisplacementTEU] [decimal](38, 4) NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[ConsumptionDisplacementTeU] [decimal](38, 2) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 6) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 6) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freeSale_Uboat84K]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freeSale_Uboat84K](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[rundate] [datetime] NOT NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[ServiceCodeDirection] [varchar](30) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[freesaleDisplacementTEU] [decimal](38, 4) NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[ConsumptionDisplacementTeU] [decimal](38, 2) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 6) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 6) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freeSale_Uboat84K_bak]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freeSale_Uboat84K_bak](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[rundate] [datetime] NOT NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[ServiceCodeDirection] [varchar](30) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[freesaleDisplacementTEU] [decimal](38, 4) NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[ConsumptionDisplacementTeU] [decimal](38, 2) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 10) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 10) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freeSale_Uboat84K_tmp]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freeSale_Uboat84K_tmp](
	[id] [bigint] NULL,
	[runid] [int] NULL,
	[rundate] [datetime] NOT NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[ServiceCodeDirection] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[totalemptyTeU] [float] NULL,
	[totalcommitfilingsTeU] [decimal](38, 2) NULL,
	[freesaleallocationTeU] [float] NULL,
	[overbookTeu] [float] NULL,
	[freesale_availableTeU] [float] NULL,
	[freesaleConsumptionTeU] [decimal](38, 2) NULL,
	[freesaleDisplacementTEU] [decimal](38, 4) NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[ConsumptionDisplacementTeU] [decimal](38, 2) NULL,
	[remaining_freesaledisplacementTeU] [float] NULL,
	[remaining_freesaleTeU] [float] NULL,
	[remaining_freesaledisplacementNoOverbookTeU] [float] NULL,
	[remaining_freesaleNoOverbookTeU] [float] NULL,
	[remaining_freesaledisplacementFFE] [float] NULL,
	[remaining_freesaleFFE] [float] NULL,
	[totalemptyTons] [float] NULL,
	[totalcommitfilingsTons] [numeric](38, 6) NULL,
	[freesaleallocationTons] [float] NULL,
	[overbookTons] [float] NULL,
	[freesale_availableTons] [float] NULL,
	[freesale_availableNoOverbookTons] [float] NULL,
	[freesaleConsumptionTons] [numeric](38, 6) NULL,
	[remaining_freesaleTons] [float] NULL,
	[remaining_freesaleNoOverbookTons] [float] NULL,
	[totalcommitfilingsPlugs] [int] NULL,
	[freesaleallocationPlugs] [int] NULL,
	[overbookPlugs] [numeric](12, 1) NULL,
	[freesale_availablePlugs] [numeric](13, 1) NULL,
	[freesale_availableNoOverBookPlugs] [int] NULL,
	[freesaleConsumptionPlugs] [int] NULL,
	[remaining_freesalePlugs] [numeric](14, 1) NULL,
	[remaining_freesaleNoOverbookPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freesaleConsumption]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freesaleConsumption](
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalPort] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[serviceCodeDirection] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[ConsumptionTEU] [decimal](38, 2) NULL,
	[cummTEU] [decimal](38, 2) NULL,
	[ConsumptionGrossweightTons] [numeric](38, 6) NULL,
	[cummgrossweightTons] [numeric](38, 6) NULL,
	[ConsumptionPlugs] [int] NULL,
	[cummPlugs] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[DisplacementTEU] [decimal](38, 4) NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [decimal](38, 4) NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[TEUWithOOG] [int] NULL,
	[commitmentTEU] [decimal](38, 2) NULL,
	[cummcommitmentTEU] [decimal](38, 2) NULL,
	[CommitmentGrossweightTons] [numeric](38, 6) NULL,
	[cummCommitmentTons] [numeric](38, 6) NULL,
	[CommitmentPlugs] [int] NULL,
	[cummCommitmentPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freesaleConsumption_All]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freesaleConsumption_All](
	[bkg_dp] [int] NULL,
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](10) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalPort] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[LegSeqId] [bigint] NULL,
	[ConsumptionTEU] [decimal](38, 2) NULL,
	[cummTEU] [decimal](38, 2) NULL,
	[ConsumptionGrossweightTons] [numeric](38, 6) NULL,
	[cummgrossweightTons] [numeric](38, 6) NULL,
	[ConsumptionPlugs] [int] NULL,
	[cummPlugs] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[DisplacementTEU] [decimal](38, 1) NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [decimal](38, 1) NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[TEUWithOOG] [decimal](38, 1) NULL,
	[commitmentTEU] [decimal](38, 2) NULL,
	[cummcommitmentTEU] [decimal](38, 2) NULL,
	[CommitmentGrossweightTons] [numeric](38, 6) NULL,
	[cummCommitmentTons] [numeric](38, 6) NULL,
	[CommitmentPlugs] [int] NULL,
	[cummCommitmentPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freesaleConsumption_current]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freesaleConsumption_current](
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](10) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalPort] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[DepartureDate] [datetime] NULL,
	[ArrivalDate] [datetime] NULL,
	[ConsumptionTEU] [decimal](38, 2) NULL,
	[ConsumptionGrossweightTons] [numeric](38, 6) NULL,
	[ConsumptionPlugs] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[DisplacementTEU] [decimal](38, 4) NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [decimal](38, 4) NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[TEUWithOOG] [int] NULL,
	[commitmentTEU] [decimal](38, 2) NULL,
	[CommitmentGrossweightTons] [numeric](38, 6) NULL,
	[CommitmentPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freesaleConsumption_MainLine]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freesaleConsumption_MainLine](
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalPort] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[LegSeqId] [bigint] NULL,
	[ConsumptionTEU] [decimal](38, 2) NULL,
	[cummTEU] [decimal](38, 2) NULL,
	[ConsumptionGrossweightTons] [numeric](38, 6) NULL,
	[cummgrossweightTons] [numeric](38, 6) NULL,
	[ConsumptionPlugs] [int] NULL,
	[cummPlugs] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[DisplacementTEU] [decimal](38, 4) NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [decimal](38, 4) NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[TEUWithOOG] [int] NULL,
	[commitmentTEU] [decimal](38, 2) NULL,
	[cummcommitmentTEU] [decimal](38, 2) NULL,
	[CommitmentGrossweightTons] [numeric](38, 6) NULL,
	[cummCommitmentTons] [numeric](38, 6) NULL,
	[CommitmentPlugs] [int] NULL,
	[cummCommitmentPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[agg_freesaleConsumption20170601]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[agg_freesaleConsumption20170601](
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalPort] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[LegSeqId] [bigint] NULL,
	[ConsumptionTEU] [decimal](38, 2) NULL,
	[cummTEU] [decimal](38, 2) NULL,
	[ConsumptionGrossweightTons] [numeric](38, 6) NULL,
	[cummgrossweightTons] [numeric](38, 6) NULL,
	[ConsumptionPlugs] [int] NULL,
	[cummPlugs] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[DisplacementTEU] [decimal](38, 4) NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [decimal](38, 4) NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[TEUWithOOG] [int] NULL,
	[commitmentTEU] [decimal](38, 2) NULL,
	[cummcommitmentTEU] [decimal](38, 2) NULL,
	[CommitmentGrossweightTons] [numeric](38, 6) NULL,
	[cummCommitmentTons] [numeric](38, 6) NULL,
	[CommitmentPlugs] [int] NULL,
	[cummCommitmentPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Agg_ML_Allocations84K_25B]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Agg_ML_Allocations84K_25B](
	[VesselCode] [char](3) NOT NULL,
	[voyage] [varchar](5) NOT NULL,
	[servicecode] [char](3) NOT NULL,
	[departurePort] [char](5) NOT NULL,
	[arrivalport] [char](5) NULL,
	[departuredate] [datetime2](0) NOT NULL,
	[vesseloperator] [char](3) NOT NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [int] NULL,
	[IntakePlugs] [int] NULL,
	[teufull] [float] NULL,
	[teuempty] [float] NULL,
	[teukilledslots] [float] NULL,
	[tonsfull] [float] NULL,
	[tonsempty] [float] NULL,
	[livereefers] [float] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [numeric](38, 0) NULL,
	[allocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Allocation_Override]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Allocation_Override](
	[CesselOperator] [varchar](50) NULL,
	[VesselCode] [varchar](50) NULL,
	[SiteCode] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[TEU] [int] NULL,
	[TONS] [numeric](38, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Booking_Final]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Booking_Final](
	[AuditVersion_ID] [int] NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Is_VSA_F] [char](1) NULL,
	[IS_IMPORT_SHIPMENT_F] [char](1) NULL,
	[IS_Operational_Shipment_F] [char](1) NULL,
	[Container_size_x] [smallint] NULL,
	[FFE] [decimal](6, 2) NULL,
	[Container_type_x] [varchar](20) NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[Dipla] [varchar](20) NULL,
	[Lopfi] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PRice_calc_Base_lcl_D] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[booking_final_bak]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[booking_final_bak](
	[AuditVersion_ID] [int] NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Is_VSA_F] [char](1) NULL,
	[IS_IMPORT_SHIPMENT_F] [char](1) NULL,
	[IS_Operational_Shipment_F] [char](1) NULL,
	[Container_size_x] [smallint] NULL,
	[FFE] [decimal](6, 2) NULL,
	[Container_type_x] [varchar](20) NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[Dipla] [varchar](20) NULL,
	[Lopfi] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PRice_calc_Base_lcl_D] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BookingCommitment]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BookingCommitment](
	[SHIPMENT_NO_X] [varchar](9) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](13) NULL,
	[CONTAINER_SIZE_X] [varchar](2) NULL,
	[CONTAINER_TYPE_X] [varchar](10) NULL,
	[CommitmentID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CAPFCST_AD_CONSUMPTION]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CAPFCST_AD_CONSUMPTION](
	[RUNDATE] [date] NULL,
	[RUNID] [int] NULL,
	[SHIPMENT_NO_X] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](50) NULL,
	[BOOKING_DATE] [date] NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[SERVICECODE] [varchar](50) NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[VESSEL] [varchar](50) NULL,
	[VOYAGE] [varchar](50) NULL,
	[LEGSEQID] [bigint] NULL,
	[CONTAINER_SIZE_X] [smallint] NULL,
	[CONTAINER_TYPE_X] [varchar](20) NULL,
	[CARGO_TYPE] [varchar](10) NULL,
	[LOPFI] [varchar](20) NULL,
	[DIPLA] [varchar](20) NULL,
	[FROMSITECODE] [varchar](50) NULL,
	[TOSITECODE] [varchar](50) NULL,
	[SCHEDULEID] [bigint] NULL,
	[FROMLEGSITECODE] [varchar](50) NULL,
	[TOLEGSITECODE] [varchar](50) NULL,
	[DEPARTUREDATE] [datetime] NULL,
	[ETD] [date] NULL,
	[ARRIVALDATE] [datetime] NULL,
	[TEU] [decimal](38, 2) NULL,
	[GROSSWEIGHTKG] [decimal](38, 6) NULL,
	[PLUGS] [int] NOT NULL,
	[CONTAINERCOUNT] [decimal](38, 2) NULL,
	[serviceCodeDirection] [varchar](50) NULL,
	[ISFREESALE] [tinyint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CapInv_Agg_Empty]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CapInv_Agg_Empty](
	[VesselCode] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CapInv_agg_freesaleConsumption]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CapInv_agg_freesaleConsumption](
	[bkg_dp] [int] NULL,
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](10) NULL,
	[servicecode] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalPort] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[LegSeqId] [bigint] NULL,
	[ConsumptionTEU] [decimal](38, 2) NULL,
	[cummTEU] [decimal](38, 2) NULL,
	[ConsumptionGrossweightTons] [numeric](38, 6) NULL,
	[cummgrossweightTons] [numeric](38, 6) NULL,
	[ConsumptionPlugs] [int] NULL,
	[cummPlugs] [int] NULL,
	[DisplacementFFE] [decimal](38, 1) NULL,
	[DisplacementTEU] [decimal](38, 1) NULL,
	[OOGFFE] [decimal](38, 1) NULL,
	[OOGTEU] [decimal](38, 1) NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[TEUWithOOG] [decimal](38, 1) NULL,
	[commitmentTEU] [decimal](38, 2) NULL,
	[cummcommitmentTEU] [decimal](38, 2) NULL,
	[CommitmentGrossweightTons] [numeric](38, 6) NULL,
	[cummCommitmentTons] [numeric](38, 6) NULL,
	[CommitmentPlugs] [int] NULL,
	[cummCommitmentPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[capinv_Consumption]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[capinv_Consumption](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[booking_Date] [date] NULL,
	[Route_CD] [varchar](20) NULL,
	[ServiceCode] [varchar](50) NULL,
	[Vessel] [varchar](50) NULL,
	[Voyage] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[Container_size_x] [smallint] NULL,
	[Container_type_x] [varchar](20) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ScheduleID] [int] NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ArrivalDate] [datetime] NULL,
	[TEU] [decimal](8, 2) NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[Plugs] [int] NOT NULL,
	[ContainerCount] [decimal](8, 2) NULL,
	[IsFreeSale] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[capinv_Consumption_noReef]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[capinv_Consumption_noReef](
	[booking_date] [date] NULL,
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](10) NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ArrivalDate] [datetime] NULL,
	[IsFreeSale] [int] NOT NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[TEU] [decimal](8, 2) NULL,
	[plugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[capinv_isc_Actual]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[capinv_isc_Actual](
	[AuditVersion_ID] [int] NULL,
	[week_No] [int] NULL,
	[servicecode] [varchar](10) NULL,
	[vesselcode] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[selling_string] [varchar](15) NULL,
	[buying_string] [varchar](15) NULL,
	[buying_company] [varchar](15) NULL,
	[from_port] [varchar](10) NULL,
	[to_port] [varchar](10) NULL,
	[teu] [numeric](18, 0) NULL,
	[FFE] [numeric](20, 6) NULL,
	[weight_kg] [numeric](15, 2) NULL,
	[weight_Tons] [numeric](20, 7) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[capinv_isc_Actual_bak]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[capinv_isc_Actual_bak](
	[week_No] [int] NULL,
	[servicecode] [varchar](10) NULL,
	[vesselcode] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[selling_string] [varchar](15) NULL,
	[buying_string] [varchar](15) NULL,
	[buying_company] [varchar](15) NULL,
	[from_port] [varchar](10) NULL,
	[to_port] [varchar](10) NULL,
	[teu] [numeric](18, 0) NULL,
	[FFE] [numeric](20, 6) NULL,
	[weight_kg] [numeric](15, 2) NULL,
	[weight_Tons] [numeric](20, 7) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[capinv_isc_committed]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[capinv_isc_committed](
	[week_No] [int] NULL,
	[servicecode] [varchar](10) NULL,
	[selling_string] [varchar](15) NULL,
	[buying_string] [varchar](15) NULL,
	[buying_company] [varchar](15) NULL,
	[from_port] [varchar](10) NULL,
	[to_port] [varchar](10) NULL,
	[teu] [int] NULL,
	[FFE] [numeric](20, 6) NULL,
	[weight_kg] [numeric](15, 2) NULL,
	[weight_Tons] [numeric](20, 7) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CapInv_ML_Allocations]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CapInv_ML_Allocations](
	[AUDITVERSION_ID] [bigint] NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CapInv_ML_Allocations_hist]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CapInv_ML_Allocations_hist](
	[AUDITVERSION_ID] [bigint] NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL,
	[rundate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CapInv_ML_Allocations20170501v2]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CapInv_ML_Allocations20170501v2](
	[AUDITVERSION_ID] [bigint] NULL,
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Consumption_MainLine]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Consumption_MainLine](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[booking_Date] [date] NULL,
	[Route_CD] [varchar](20) NULL,
	[ServiceCode] [varchar](50) NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[Vessel] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[Container_size_x] [smallint] NULL,
	[Container_type_x] [varchar](20) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ETD] [date] NULL,
	[ArrivalDate] [datetime] NULL,
	[TEU] [decimal](8, 2) NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[Plugs] [int] NOT NULL,
	[ContainerCount] [decimal](8, 2) NULL,
	[IsFreeSale] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Consumption84K]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Consumption84K](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[booking_Date] [date] NULL,
	[Route_CD] [varchar](20) NULL,
	[ServiceCode] [varchar](50) NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[Vessel] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[Container_size_x] [smallint] NULL,
	[Container_type_x] [varchar](20) NULL,
	[cargo_type] [varchar](10) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ScheduleID] [bigint] NULL,
	[serviceCodeDirection] [varchar](50) NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ETD] [date] NULL,
	[ArrivalDate] [datetime] NULL,
	[TEU] [decimal](38, 2) NULL,
	[GrossWeightKg] [decimal](38, 6) NULL,
	[Plugs] [int] NOT NULL,
	[ContainerCount] [decimal](38, 2) NULL,
	[IsFreeSale] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Consumption84K_bak]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Consumption84K_bak](
	[recordnumber] [bigint] NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[booking_Date] [date] NULL,
	[Route_CD] [varchar](20) NULL,
	[ServiceCode] [varchar](50) NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[Vessel] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[Container_size_x] [smallint] NULL,
	[Container_type_x] [varchar](20) NULL,
	[cargo_type] [varchar](10) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ScheduleID] [int] NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ETD] [datetime] NULL,
	[ArrivalDate] [datetime] NULL,
	[TEU] [decimal](8, 2) NULL,
	[GrossWeightKg] [decimal](12, 4) NULL,
	[Plugs] [int] NOT NULL,
	[ContainerCount] [decimal](8, 2) NULL,
	[IsFreeSale] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Consumption84K_dedup]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Consumption84K_dedup](
	[booking_date] [date] NULL,
	[vessel] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[fromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ArrivalDate] [datetime] NULL,
	[ETD] [date] NULL,
	[IsFreeSale] [int] NOT NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[TEU] [decimal](8, 2) NULL,
	[plugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dim_Date]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[dim_Date](
	[ID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Day] [char](2) NOT NULL,
	[DaySuffix] [varchar](4) NOT NULL,
	[DayOfWeek] [tinyint] NOT NULL,
	[DayOfWeekname] [varchar](9) NOT NULL,
	[DOWInMonth] [tinyint] NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[WeekOfMonth] [tinyint] NOT NULL,
	[Month] [char](2) NOT NULL,
	[MonthName] [varchar](9) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[Year] [char](4) NOT NULL,
	[StandardDate] [varchar](10) NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[dim_Date] ADD [WD_WE] [varchar](2) NULL
ALTER TABLE [dbo].[dim_Date] ADD [PREVIOUSDAY] [date] NULL
ALTER TABLE [dbo].[dim_Date] ADD [NEXTDAY] [date] NULL
ALTER TABLE [dbo].[dim_Date] ADD [int_yearweek] [int] NULL
ALTER TABLE [dbo].[dim_Date] ADD [char_yearweek] [char](7) NULL
ALTER TABLE [dbo].[dim_Date] ADD [WEEK_SUNDAY_DATE] [date] NULL
ALTER TABLE [dbo].[dim_Date] ADD [iso_WeekOfYear] [int] NULL
ALTER TABLE [dbo].[dim_Date] ADD [iso_year] [int] NULL
ALTER TABLE [dbo].[dim_Date] ADD [int_iso_yearweek] [int] NULL
ALTER TABLE [dbo].[dim_Date] ADD [char_iso_yearweek] [char](7) NULL
 CONSTRAINT [PK_dim_Date] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dim_rock_container]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dim_rock_container](
	[containertype] [varchar](10) NULL,
	[RockcontainerSubtype] [varchar](10) NULL,
	[RockEquipmentType] [varchar](10) NULL,
	[Containerdescription] [varchar](75) NULL,
	[TEU] [numeric](6, 3) NULL,
	[FFE] [numeric](6, 3) NULL,
	[emptyweightKG] [int] NULL,
	[emptyweightTons] [numeric](6, 3) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dim_runid]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dim_runid](
	[runid] [int] IDENTITY(0,1) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dim_Time]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[dim_Time](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Time] [char](8) NOT NULL,
	[Hour] [char](2) NOT NULL,
	[MilitaryHour] [char](2) NOT NULL,
	[Minute] [char](2) NOT NULL,
	[Second] [char](2) NOT NULL,
	[AmPm] [char](2) NOT NULL,
	[StandardTime] [char](11) NULL,
 CONSTRAINT [PK_dim_Time] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_Allocations_MainLine]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ML_Allocations_MainLine](
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_Allocations_ML]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ML_Allocations_ML](
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_Allocations84K]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ML_Allocations84K](
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_Allocations84K_25B]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ML_Allocations84K_25B](
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_Allocations84K_26B]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ML_Allocations84K_26B](
	[voyage] [varchar](10) NULL,
	[VesselCode] [varchar](5) NULL,
	[servicecode] [varchar](10) NULL,
	[route_cd] [varchar](10) NULL,
	[serviceroute] [varchar](10) NULL,
	[departureport] [varchar](10) NULL,
	[arrivalport] [varchar](10) NULL,
	[vesseloperator] [varchar](50) NULL,
	[departuredate] [date] NULL,
	[departuretime] [varchar](10) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [float] NULL,
	[IntakePlugs] [int] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [float] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_PROCESS_LOG]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF OBJECT_ID('CAPINVREPOSITORY.DBO.ML_PROCESS_LOG', 'U') IS NOT NULL
	DROP TABLE CAPINVREPOSITORY.DBO.ML_PROCESS_LOG;
go
CREATE TABLE [dbo].[ML_PROCESS_LOG](
	[PROCESS_ID] [int] NOT NULL,
	[PROCESS_NAME] [varchar](50) NULL,
	[USER_NAME] [nvarchar](255) NULL,
	[START_DT] [datetime] NULL,
	[END_DT] [datetime] NULL,
	[STATUS] [varchar](10) NULL,
	[ACTION] [tinyint] NULL,
	[PARENT_PROCESS_ID] [int] NULL,
	[NOTE] [nvarchar](2000) NULL,
	[START_STEP] [tinyint] NULL,
 CONSTRAINT [PK_ML_PROCESS_LOG_PROCESS_ID] PRIMARY KEY CLUSTERED 
(
	[PROCESS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_PROCESS_LOG_DETAIL]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF OBJECT_ID('CAPINVREPOSITORY.DBO.ML_PROCESS_LOG_DETAIL', 'U') IS NOT NULL
	DROP TABLE CAPINVREPOSITORY.DBO.ML_PROCESS_LOG_DETAIL;

CREATE TABLE [dbo].[ML_PROCESS_LOG_DETAIL](
	[PROCESS_ID] [int] NOT NULL,
	[STEP_ID] [tinyint] NOT NULL,
	[STEP_NAME] [varchar](255) NULL,
	[START_DT] [datetime] NULL DEFAULT (getutcdate()),
	[END_DT] [datetime] NULL,
	[STATUS] [varchar](10) NULL,
	[ROWS_PROCESSED] [int] NULL,
	[ACTION] [tinyint] NULL,
	[NOTE] [nvarchar](2000) NULL,
 CONSTRAINT [PK_ML_PROCESS_LOG_DETAIL_PROCESS_ID_STEP_ID] PRIMARY KEY CLUSTERED 
(
	[PROCESS_ID] ASC,
	[STEP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RouteLegs]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RouteLegs](
	[vesselcode] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[segment_FromSiteCode] [varchar](50) NULL,
	[segment_ToSiteCode] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[ETD] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RouteLegs_schedule]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RouteLegs_schedule](
	[AUDITVERSIONID] [int] NULL,
	[ScheduleID] [bigint] NULL,
	[servicecode] [varchar](50) NULL,
	[vesselcode] [varchar](10) NULL,
	[voyage] [varchar](50) NULL,
	[ARRVOYAGE] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[nextDepVoyage] [varchar](50) NULL,
	[nextarrivalvoyage] [varchar](10) NULL,
	[original_etd] [datetime] NULL,
	[actual_etd] [datetime] NULL,
	[arrivalDate] [datetime] NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RouteLegs_schedule84K]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RouteLegs_schedule84K](
	[AUDITVERSIONID] [int] NULL,
	[SCHEDULEID] [bigint] NULL,
	[SERVICECODE] [varchar](50) NULL,
	[VESSELCODE] [varchar](10) NULL,
	[VOYAGE] [varchar](50) NULL,
	[ARRVOYAGE] [varchar](10) NULL,
	[LEGSEQID] [bigint] NULL,
	[DEPARTUREPORT] [varchar](50) NULL,
	[serviceCodeDirection] [varchar](50) NULL,
	[ARRIVALPORT] [varchar](50) NULL,
	[NEXTDEPVOYAGE] [varchar](50) NULL,
	[NEXTARRIVALVOYAGE] [varchar](10) NULL,
	[ORIGINAL_ETD] [datetime] NULL,
	[ACTUAL_ETD] [datetime] NULL,
	[ARRIVALDATE] [datetime] NULL,
	[SCHARRIVALDATE] [datetime] NULL,
	[ACTARRIVALDATE] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RouteLegs_schedule84K_LegSeq]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RouteLegs_schedule84K_LegSeq](
	[VesselCode] [varchar](50) NULL,
	[depVoyage] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[fromsitecode] [varchar](50) NULL,
	[tositecode] [varchar](50) NULL,
	[Firstscheduleid] [bigint] NULL,
	[Lastscheduleid] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RouteLinks]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RouteLinks](
	[AUDITVERSION_ID] [int] NULL,
	[SHIPMENT_NO_X] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](50) NULL,
	[Booking_Date] [date] NULL,
	[FromSiteCode] [varchar](50) NULL,
	[FromCityCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ToCityCode] [varchar](50) NULL,
	[MEPCTransModeX] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[DepVoyageX] [varchar](50) NULL,
	[ArrVoyageX] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[VesselCode] [varchar](50) NULL,
	[DepLocalExpectedDt] [date] NULL,
	[ArrLocalExpectedDt] [date] NULL,
	[WaterLandMode_Fl] [varchar](50) NULL,
	[DIPLA] [varchar](50) NULL,
	[LOPFI] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RTT_26B_1616]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RTT_26B_1616](
	[First Tpdoc] [varchar](50) NULL,
	[Shipment Number] [varchar](50) NULL,
	[Shipment Priority] [varchar](50) NULL,
	[Container Number] [varchar](50) NULL,
	[Container Size] [varchar](50) NULL,
	[Container Type] [varchar](50) NULL,
	[Container Height] [varchar](50) NULL,
	[FFE] [varchar](50) NULL,
	[Teus] [varchar](50) NULL,
	[Most Reliable Weight] [varchar](50) NULL,
	[Oper] [varchar](50) NULL,
	[Vessel Code] [varchar](50) NULL,
	[Voyage Number] [varchar](50) NULL,
	[Load Port Code] [varchar](50) NULL,
	[Discharge Port] [varchar](50) NULL,
	[Vessel ETA] [varchar](50) NULL,
	[Vessel ETD] [varchar](50) NULL,
	[Load Port LOC] [varchar](50) NULL,
	[Discharge Port LOC] [varchar](50) NULL,
	[Bucket] [varchar](50) NULL,
	[CYield] [varchar](50) NULL,
	[Customer] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule](
	[AUDITVERSION_ID] [int] NOT NULL,
	[Vessel] [varchar](10) NULL,
	[VesselOperator] [int] NULL,
	[Service] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[Arr_Stat] [varchar](50) NULL,
	[Site_Code] [varchar](50) NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL,
	[SchDepartureDate] [datetime] NULL,
	[ActDepartureDate] [datetime] NULL,
	[DepVoyage] [varchar](10) NULL,
	[Dep_Stat] [varchar](10) NULL,
	[Vessel_Capacity_TEU] [int] NULL,
	[TEU] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule84K]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule84K](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[Service] [varchar](50) NULL,
	[Vessel] [varchar](10) NULL,
	[Depvoyage] [varchar](10) NULL,
	[site_code] [varchar](50) NULL,
	[original_etd] [datetime] NULL,
	[actual_etd] [datetime] NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stg_allocation_new]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stg_allocation_new](
	[ID] [varchar](50) NULL,
	[isown] [varchar](50) NULL,
	[Operator] [varchar](50) NULL,
	[vslcode] [varchar](50) NULL,
	[vslName] [varchar](50) NULL,
	[arrDate] [varchar](50) NULL,
	[arrTime] [varchar](50) NULL,
	[arrVoy] [varchar](50) NULL,
	[GSIS_st] [varchar](50) NULL,
	[siteCode] [varchar](50) NULL,
	[siteName] [varchar](50) NULL,
	[depVoy] [varchar](50) NULL,
	[svc_Route] [varchar](50) NULL,
	[depDate] [varchar](50) NULL,
	[depTime] [varchar](50) NULL,
	[GSIS_1_st] [varchar](50) NULL,
	[SP_HH_BH] [varchar](50) NULL,
	[SP_Bottleneck] [varchar](50) NULL,
	[IntakeTeu] [varchar](50) NULL,
	[IntakeMT] [varchar](50) NULL,
	[IntakePlugs] [varchar](50) NULL,
	[MLBTeu] [varchar](50) NULL,
	[MLBMT] [varchar](50) NULL,
	[MLBPlugs] [varchar](50) NULL,
	[MSKTeu] [varchar](50) NULL,
	[MSKMT] [varchar](50) NULL,
	[MSKPlugs] [varchar](50) NULL,
	[MCCTeu] [varchar](50) NULL,
	[MCCMT] [varchar](50) NULL,
	[MCCPlugs] [varchar](50) NULL,
	[SGLTeu] [varchar](50) NULL,
	[SGLMT] [varchar](50) NULL,
	[SGLPlugs] [varchar](50) NULL,
	[SLDTeu] [varchar](50) NULL,
	[SLDMT] [varchar](50) NULL,
	[SLDPlugs] [varchar](50) NULL,
	[EXPORT_Teu] [varchar](50) NULL,
	[EXPORT_MT] [varchar](50) NULL,
	[EXPORT_Plugs] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stg_CAP_Displacement]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stg_CAP_Displacement](
	[Shipment_No] [varchar](9) NULL,
	[ShipmentversionId] [varchar](13) NULL,
	[Service] [varchar](3) NULL,
	[Displacement] [decimal](10, 1) NULL,
	[FFE] [decimal](10, 1) NULL,
	[WgtGross] [decimal](15, 3) NULL,
	[LOPFI] [varchar](1) NULL,
	[DIPLA] [varchar](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stg_CAP_Displacement_OOG]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stg_CAP_Displacement_OOG](
	[Shipment_No] [varchar](9) NULL,
	[ShipmentversionId] [varchar](13) NULL,
	[Service] [varchar](3) NULL,
	[Displacement] [decimal](15, 1) NULL,
	[FFE] [decimal](15, 1) NULL,
	[FFEWithOOG] [decimal](15, 1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Stg_RevenueOptimizationLegs]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Stg_RevenueOptimizationLegs](
	[ID] [int] NOT NULL,
	[VesselCode] [char](3) NOT NULL,
	[VesselOperator] [char](3) NOT NULL,
	[Voyage] [varchar](5) NOT NULL,
	[Direction] [varchar](3) NOT NULL,
	[ServiceCode] [char](3) NOT NULL,
	[DeparturePort] [char](5) NOT NULL,
	[DepartureDate] [datetime2](0) NOT NULL,
	[ArrivalPort] [char](5) NULL,
	[NextLegDirection] [varchar](3) NULL,
	[IntakeTEU] [int] NULL,
	[IntakeTons] [int] NULL,
	[IntakePlugs] [int] NULL,
	[IsOwnVessel] [bit] NOT NULL,
	[IsActual] [bit] NOT NULL,
	[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Stg_RevenueOptimizationOperatorDetails]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Stg_RevenueOptimizationOperatorDetails](
	[ID] [int] NOT NULL,
	[OperatorCode] [char](3) NOT NULL,
	[TEUFull] [float] NULL,
	[TEUEmpty] [float] NULL,
	[TEUKilledSlots] [float] NULL,
	[TonsFull] [float] NULL,
	[TonsEmpty] [float] NULL,
	[LiveReefers] [float] NULL,
	[AllocationTEU] [int] NULL,
	[AllocationTons] [int] NULL,
	[AllocationPlugs] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stg_rock]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stg_rock](
	[OTTnumber] [varchar](50) NULL,
	[VesselOperator] [varchar](50) NULL,
	[VesselCode] [varchar](50) NULL,
	[VesselName] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[Line] [varchar](50) NULL,
	[PlaceFrom] [varchar](50) NULL,
	[FromDate] [varchar](50) NULL,
	[OriginDeparture] [varchar](50) NULL,
	[PlaceTo] [varchar](50) NULL,
	[VoyageTo] [varchar](50) NULL,
	[ToDate] [varchar](50) NULL,
	[DestinationDeparture] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[ApprovedBy] [varchar](50) NULL,
	[ApprovedDate] [varchar](50) NULL,
	[InsertedBy] [varchar](50) NULL,
	[InsertDate] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [varchar](50) NULL,
	[OTTType] [varchar](50) NULL,
	[Transport] [varchar](50) NULL,
	[COntainerType] [varchar](50) NULL,
	[ContainerStatus] [varchar](50) NULL,
	[containerAmount] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TMP_AGG_EMPTY]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_AGG_EMPTY](
	[VESSELCODE] [varchar](50) NOT NULL,
	[VOYAGE] [varchar](50) NOT NULL,
	[SERVICECODE] [varchar](50) NOT NULL,
	[DEPARTUREPORT] [varchar](50) NULL,
	[ARRIVALPORT] [varchar](50) NULL,
	[LEGSEQID] [bigint] NULL,
	[TOTALEMPTYCONTAINER] [float] NULL,
	[TOTALEMPTYTEU] [float] NULL,
	[TOTALEMPTYTONS] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Agg_Empty84K]    Script Date: 7/21/2017 2:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Agg_Empty84K](
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departurePort] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[vesseloperator] [varchar](50) NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Agg_Empty84K_26B]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Agg_Empty84K_26B](
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departurePort] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[vesseloperator] [varchar](50) NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_RoacksData_new]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_RoacksData_new](
	[OTTNumber] [varchar](50) NULL,
	[VesselOperator] [varchar](50) NULL,
	[VesselCode] [varchar](50) NULL,
	[VesselName] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[Line] [varchar](50) NULL,
	[PlaceFrom] [varchar](50) NULL,
	[FromDate] [varchar](50) NULL,
	[OriginDeparture] [varchar](50) NULL,
	[PlaceTo] [varchar](50) NULL,
	[VoyageTo] [varchar](50) NULL,
	[ToDate] [varchar](50) NULL,
	[DestinationDeparture] [varchar](50) NULL,
	[OTTStatus] [varchar](50) NULL,
	[ApprovedBy] [varchar](50) NULL,
	[ApprovedDate] [varchar](50) NULL,
	[InsertedBy] [varchar](50) NULL,
	[InsertDate] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [varchar](50) NULL,
	[OTTType] [varchar](50) NULL,
	[Transport] [varchar](50) NULL,
	[ContainerStatus] [varchar](50) NULL,
	[ContainerType] [varchar](50) NULL,
	[ContainerAmount] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_rock_legSequence]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_rock_legSequence](
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departurePort] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[vesseloperator] [varchar](50) NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL,
	[FirstScheduleID] [bigint] NULL,
	[LastScheduleID] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_rock_legSequence_MainLine]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_rock_legSequence_MainLine](
	[VesselCode] [varchar](50) NOT NULL,
	[voyage] [varchar](50) NOT NULL,
	[servicecode] [varchar](50) NOT NULL,
	[departurePort] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[departuredate] [datetime] NULL,
	[arrivaldate] [datetime] NULL,
	[vesseloperator] [varchar](50) NULL,
	[totalEmptyContainer] [float] NULL,
	[totalEmptyTEU] [float] NULL,
	[totalEmptyTons] [float] NULL,
	[FirstLegSeqId] [bigint] NULL,
	[LastLegSeqId] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TMP_RouteLegs_schedule_arrvoyage]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_RouteLegs_schedule_arrvoyage](
	[Service] [varchar](50) NULL,
	[Vessel] [varchar](10) NULL,
	[voyage] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[SchDepartureDate] [datetime] NULL,
	[ActDepartureDate] [datetime] NULL,
	[arrivalDate] [datetime] NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TMP_RouteLegs_schedule_arrvoyage84K]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_RouteLegs_schedule_arrvoyage84K](
	[Service] [varchar](50) NULL,
	[Vessel] [varchar](10) NULL,
	[voyage] [varchar](50) NULL,
	[Depvoyage] [varchar](10) NULL,
	[ARRVOYAGE] [varchar](50) NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[SchDepartureDate] [datetime] NULL,
	[ActDepartureDate] [datetime] NULL,
	[arrivalDate] [datetime] NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_routelinks20170622]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_routelinks20170622](
	[SHIPMENT_NO_X] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](50) NULL,
	[Booking_Date] [date] NULL,
	[LocSeqX] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[FromCityCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ToCityCode] [varchar](50) NULL,
	[MEPCTransModeX] [varchar](50) NULL,
	[DepVoyageX] [varchar](50) NULL,
	[ArrVoyageX] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[VesselCode] [varchar](50) NULL,
	[DepLocalExpectedDt] [varchar](50) NULL,
	[ArrLocalExpectedDt] [varchar](50) NULL,
	[WaterLandMode_Fl] [varchar](50) NULL,
	[DIPLA] [varchar](50) NULL,
	[LOPFI] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_routelinks20170622_new]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_routelinks20170622_new](
	[AUDITVERSION_ID] [int] NOT NULL,
	[SHIPMENT_NO_X] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](50) NULL,
	[Booking_Date] [date] NULL,
	[LocSeqX] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[FromCityCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ToCityCode] [varchar](50) NULL,
	[MEPCTransModeX] [varchar](50) NULL,
	[DepVoyageX] [varchar](50) NULL,
	[ArrVoyageX] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[VesselCode] [varchar](50) NULL,
	[DepLocalExpectedDt] [datetime] NULL,
	[ArrLocalExpectedDt] [datetime] NULL,
	[WaterLandMode_Fl] [varchar](50) NULL,
	[DIPLA] [varchar](50) NULL,
	[LOPFI] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumption_Legs]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumption_Legs](
	[recordnumber] [bigint] NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Container_size_x] [smallint] NULL,
	[FFE] [decimal](38, 2) NULL,
	[Container_type_x] [varchar](20) NULL,
	[cargo_type] [varchar](10) NULL,
	[GrossWeightKg] [decimal](38, 6) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PCD_Date] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL,
	[vesselcode] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[depvoyagex] [varchar](50) NULL,
	[ETD] [date] NULL,
	[Firstscheduleid] [bigint] NULL,
	[Lastscheduleid] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumption_Legs_ML]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumption_Legs_ML](
	[AuditVersion_ID] [int] NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Container_size_x] [smallint] NULL,
	[FFE] [decimal](6, 2) NULL,
	[Container_type_x] [varchar](20) NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PCD_Date] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL,
	[vesselcode] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[depvoyagex] [varchar](50) NULL,
	[ETD] [date] NULL,
	[FirstLegSeqId] [bigint] NULL,
	[LastLegSeqId] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumptionStep1]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumptionStep1](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Container_size_x] [smallint] NULL,
	[Container_type_x] [varchar](20) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PCD_Date] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL,
	[vesselcode] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[depvoyagex] [varchar](50) NULL,
	[ArrVoyageX] [varchar](50) NULL,
	[etd] [date] NULL,
	[cargo_type] [varchar](10) NULL,
	[FFE] [decimal](38, 2) NULL,
	[GrossWeightKg] [decimal](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumptionStep1_ML]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumptionStep1_ML](
	[AuditVersion_ID] [int] NULL,
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Container_size_x] [smallint] NULL,
	[FFE] [decimal](6, 2) NULL,
	[Container_type_x] [varchar](20) NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PCD_Date] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL,
	[vesselcode] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[VOYAGE] [varchar](50) NULL,
	[ETD] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumptionStep2]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumptionStep2](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Container_size_x] [smallint] NULL,
	[FFE] [decimal](38, 2) NULL,
	[Container_type_x] [varchar](20) NULL,
	[cargo_type] [varchar](10) NULL,
	[GrossWeightKg] [decimal](38, 6) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PCD_Date] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL,
	[vesselcode] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[ETD] [date] NULL,
	[voyage] [varchar](50) NULL,
	[ScheduleID] [bigint] NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[serviceCodeDirection] [varchar](50) NULL,
	[arrivalDate] [datetime] NULL,
	[LegSeqId] [bigint] NULL,
	[original_etd] [datetime] NULL,
	[actual_etd] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumptionStep2_cont]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumptionStep2_cont](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[Brand] [varchar](20) NULL,
	[Container_size_x] [smallint] NULL,
	[FFE] [decimal](38, 2) NULL,
	[Container_type_x] [varchar](20) NULL,
	[cargo_type] [varchar](10) NULL,
	[GrossWeightKg] [decimal](38, 6) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[Pod] [varchar](20) NULL,
	[Por] [varchar](20) NULL,
	[PCD_Date] [date] NULL,
	[booking_Date] [date] NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL,
	[vesselcode] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[voyage] [varchar](50) NULL,
	[ETD] [date] NULL,
	[ScheduleID] [bigint] NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[arrivalDate] [datetime] NULL,
	[LegSeqId] [bigint] NULL,
	[original_etd] [datetime] NULL,
	[actual_etd] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumptionStep3]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumptionStep3](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[booking_Date] [date] NULL,
	[Route_CD] [varchar](20) NULL,
	[ServiceCode] [varchar](50) NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[Vessel] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[Container_size_x] [smallint] NULL,
	[Container_type_x] [varchar](20) NULL,
	[cargo_type] [varchar](10) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ScheduleID] [bigint] NULL,
	[serviceCodeDirection] [varchar](50) NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ETD] [date] NULL,
	[ArrivalDate] [datetime] NULL,
	[TEU] [decimal](38, 2) NULL,
	[GrossWeightKg] [decimal](38, 6) NULL,
	[Plugs] [int] NOT NULL,
	[ContainerCount] [decimal](38, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumptionStep3_ML]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpConsumptionStep3_ML](
	[Shipment_no_x] [varchar](50) NULL,
	[Shipment_vrsn_Id_X] [varchar](50) NULL,
	[booking_Date] [date] NULL,
	[Route_CD] [varchar](20) NULL,
	[ServiceCode] [varchar](50) NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[Vessel] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[LegSeqId] [bigint] NULL,
	[Container_size_x] [smallint] NULL,
	[Container_type_x] [varchar](20) NULL,
	[Lopfi] [varchar](20) NULL,
	[Dipla] [varchar](20) NULL,
	[FromSiteCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[FromLegSiteCode] [varchar](50) NULL,
	[ToLegSiteCode] [varchar](50) NULL,
	[DepartureDate] [datetime] NULL,
	[ETD] [date] NULL,
	[ArrivalDate] [datetime] NULL,
	[TEU] [decimal](8, 2) NULL,
	[GrossWeightKg] [decimal](38, 3) NULL,
	[Plugs] [int] NOT NULL,
	[ContainerCount] [decimal](8, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpRouteLinks5312017]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpRouteLinks5312017](
	[AUDITVERSION_ID] [int] NULL,
	[SHIPMENT_NO_X] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](50) NULL,
	[Booking_Date] [date] NULL,
	[FromSiteCode] [varchar](50) NULL,
	[FromCityCode] [varchar](50) NULL,
	[ToSiteCode] [varchar](50) NULL,
	[ToCityCode] [varchar](50) NULL,
	[MEPCTransModeX] [varchar](50) NULL,
	[LocSeqX] [varchar](50) NULL,
	[DepVoyageX] [varchar](50) NULL,
	[ArrVoyageX] [varchar](50) NULL,
	[ServiceCode] [varchar](50) NULL,
	[VesselCode] [varchar](50) NULL,
	[DepLocalExpectedDt] [date] NULL,
	[ArrLocalExpectedDt] [date] NULL,
	[WaterLandMode_Fl] [varchar](50) NULL,
	[DIPLA] [varchar](50) NULL,
	[LOPFI] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
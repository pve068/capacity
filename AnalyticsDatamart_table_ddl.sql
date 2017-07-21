USE [AnalyticsDatamart]
GO
/****** Object:  Table [dbo].[AD_Displacement_OOG]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AD_Displacement_OOG](
	[AuditversionID] [bigint] NOT NULL,
	[Shipment_No] [varchar](9) NOT NULL,
	[ShipmentversionId] [varchar](13) NOT NULL,
	[servicecode] [varchar](3) NOT NULL,
	[DisplacementFFE] [decimal](15, 1) NULL,
	[DisplacementTEU] [decimal](15, 4) NULL,
	[FFE] [decimal](15, 1) NULL,
	[TeU] [decimal](15, 4) NULL,
	[FFEWithOOG] [decimal](15, 1) NULL,
	[TEUWithOOG] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AD_ISC_Commited]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AD_ISC_Commited](
	[AuditVersionId] [int] NULL,
	[WeekNo] [int] NULL,
	[ServiceCode] [varchar](10) NULL,
	[SellingString] [varchar](50) NULL,
	[BuyingString] [varchar](50) NULL,
	[BuyingCompany] [varchar](50) NULL,
	[FromPort] [varchar](10) NULL,
	[ToPort] [varchar](10) NULL,
	[TEU] [int] NULL,
	[WeightKg] [decimal](12, 4) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ad_los_tranche2]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ad_los_tranche2](
	[RCD] [varchar](20) NULL,
	[CCD] [varchar](8000) NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[ad_los_tranche2] ADD [NND] [varchar](203) NOT NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [BOD] [varchar](103) NOT NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [COD] [varchar](103) NOT NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [SOD] [varchar](103) NOT NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [Week] [int] NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [ContainerSizeType] [varchar](62) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[ad_los_tranche2] ADD [SHIPMENT_COMMODITY] [varchar](500) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [SHIPMENT_COMMODITY_CODE] [varchar](50) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [InteractionContainer] [varchar](50) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [InteractionCommodity] [varchar](50) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [InteractionCustomer] [varchar](50) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [ProjectMonths] [varchar](12) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [NumOfContainers] [decimal](38, 2) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [NumOfFFE] [decimal](38, 2) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [AvgPerContainer] [decimal](38, 9) NULL
ALTER TABLE [dbo].[ad_los_tranche2] ADD [AvgPerFFE] [decimal](38, 9) NULL

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AD_ML_Allocations]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AD_ML_Allocations](
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
/****** Object:  Table [dbo].[AD_Rocks]    Script Date: 7/21/2017 2:19:00 PM ******/
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
/****** Object:  Table [dbo].[AFLSBaseRateDaily]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AFLSBaseRateDaily](
	[NewMLINumber] [varchar](50) NULL,
	[NewMLIVersion_No] [varchar](50) NULL,
	[NewMLIOrigin_Cd] [varchar](50) NULL,
	[NewMLIDestination_Cd] [varchar](50) NULL,
	[NewMLIReceiptType_Cd] [varchar](50) NULL,
	[NewMLIDeliveryType_Cd] [varchar](50) NULL,
	[NewMLIContainer] [varchar](50) NULL,
	[NewMLICommodity] [varchar](50) NULL,
	[NewMLICustomer] [varchar](50) NULL,
	[NewMLIEffective_Dt] [date] NULL,
	[NewMLIExpiry_Dt] [date] NULL,
	[NewMLIValidityPeriod] [int] NULL,
	[NewMLIRate] [decimal](16, 3) NULL,
	[NewProject_Id] [varchar](50) NULL,
	[NewProject_Name] [varchar](50) NULL,
	[NewHeaderContainer] [varchar](50) NULL,
	[NewHeaderCommodity] [varchar](50) NULL,
	[NewHeaderCustomer] [varchar](1) NOT NULL,
	[NewHeaderValidityPeriod] [int] NULL,
	[NewBaseRef] [varchar](50) NULL,
	[NewBaseVersion_No] [int] NULL,
	[NewBaseOrigin_Cd] [varchar](50) NULL,
	[NewBaseDestination_Cd] [varchar](50) NULL,
	[NewBaseContainer] [varchar](50) NULL,
	[NewBaseCommodity] [varchar](50) NULL,
	[NewBaseCustomer] [varchar](50) NULL,
	[NewBaseEffective_Dt] [date] NULL,
	[NewBaseExpiry_Dt] [date] NULL,
	[NewBaseValidityPeriod] [int] NULL,
	[NewBaseRate] [decimal](16, 3) NULL,
	[NewMLICurrencyCode] [varchar](3) NULL,
	[NewMLIUSDExchRate] [decimal](13, 6) NULL,
	[NewBaseCurrencyCode] [varchar](3) NULL,
	[NewBaseUSDExchRate] [decimal](13, 6) NULL,
	[NewBaseRateKey] [decimal](12, 0) NOT NULL,
	[OLD_BASE_KEY] [decimal](12, 0) NULL,
	[AuditVersion_ID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AFLSBaseRateWeekly]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AFLSBaseRateWeekly](
	[Base_Key] [decimal](12, 0) NULL,
	[Project_Id] [int] NULL,
	[Project_Name] [varchar](50) NULL,
	[HeaderContainer] [varchar](50) NULL,
	[HeaderCommodity] [varchar](50) NULL,
	[HeaderValidityPeriod] [int] NULL,
	[BaseRef] [varchar](50) NULL,
	[BaseVersion_No] [int] NULL,
	[BaseOrigin_Cd] [varchar](50) NULL,
	[BaseDestination_Cd] [varchar](50) NULL,
	[BaseContainer] [varchar](50) NULL,
	[BaseCommodity] [varchar](50) NULL,
	[BaseCustomer] [varchar](50) NULL,
	[BaseEffective_Dt] [date] NULL,
	[BaseExpiry_Dt] [date] NULL,
	[BaseValidityPeriod] [int] NULL,
	[BaseRate] [decimal](16, 3) NULL,
	[BaseCurrencyCode] [varchar](3) NULL,
	[BaseUSDExchRate] [decimal](13, 6) NULL,
	[MLINumber] [varchar](50) NULL,
	[MLIVersion_No] [varchar](50) NULL,
	[MLIOrigin_Cd] [varchar](50) NULL,
	[MLIDestination_Cd] [varchar](50) NULL,
	[MLIReceiptType_Cd] [varchar](50) NULL,
	[MLIDeliveryType_Cd] [varchar](50) NULL,
	[MLIContainer] [varchar](50) NULL,
	[MLICommodity] [varchar](50) NULL,
	[MLICustomer] [varchar](50) NULL,
	[MLIEffective_Dt] [date] NULL,
	[MLIExpiry_Dt] [date] NULL,
	[MLIValidityPeriod] [int] NULL,
	[MLIRate] [decimal](16, 3) NULL,
	[MLICurrencyCode] [varchar](3) NULL,
	[MLIUSDExchRate] [decimal](13, 6) NULL,
	[QuoteLine_Id] [varchar](50) NULL,
	[QLIVersion_No] [int] NULL,
	[QLIOrigin_Cd] [varchar](50) NULL,
	[QLIDestination_Cd] [varchar](50) NULL,
	[QLIContainer] [varchar](50) NULL,
	[QLICommodity] [varchar](50) NULL,
	[QLIReceiptType_Cd] [varchar](50) NULL,
	[QLIDeliveryType_Cd] [varchar](50) NULL,
	[CLINumber] [varchar](50) NULL,
	[CLIVersion_No] [int] NULL,
	[RouteCodeDirection_Cd] [varchar](20) NULL,
	[PORGeoCC_Cd] [varchar](5) NULL,
	[PODGeoCC_Cd] [varchar](50) NULL,
	[PORGeoSite_Cd] [varchar](8) NULL,
	[PODGeoSite_Cd] [varchar](8) NULL,
	[PricingEqptSize_Cd] [varchar](2) NULL,
	[PricingEqptType_Cd] [varchar](9) NULL,
	[ShipmentCommodity_Cd] [varchar](20) NULL,
	[M_NumberOfContainer] [decimal](15, 2) NULL,
	[M_FFEDummy] [decimal](10, 2) NULL,
	[M_RevenueAdjAmtUSD] [decimal](38, 11) NULL,
	[M_ActualOceanFrtRateUSD] [decimal](30, 10) NULL,
	[M_BookedRevenueAmtUSD] [decimal](38, 11) NULL,
	[M_MarketRateAmtUSD] [decimal](38, 11) NULL,
	[M_ContributionAmtUSD] [decimal](38, 11) NULL,
	[Shipment_No] [varchar](50) NULL,
	[Equipment_No] [varchar](50) NULL,
	[AuditVersion_ID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AUDITVERSIONMASTER]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AUDITVERSIONMASTER](
	[AUDITVERSIONID] [int] IDENTITY(0,1) NOT NULL,
	[AUDITVERSIONTS] [datetime] NULL,
 CONSTRAINT [PK_AUDITVERSIONMASTER_AUDITVERSIONID] PRIMARY KEY CLUSTERED 
(
	[AUDITVERSIONID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BaseRateDailyExcluded]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BaseRateDailyExcluded](
	[NewProject_Id] [varchar](50) NULL,
	[NewProject_Name] [varchar](50) NULL,
	[NewHeaderContainer] [varchar](50) NULL,
	[NewHeaderCommodity] [varchar](50) NULL,
	[NewHeaderValidityPeriod] [int] NULL,
	[NewBaseRef] [varchar](50) NULL,
	[NewBaseVersion_No] [int] NULL,
	[NewBaseOrigin_Cd] [varchar](50) NULL,
	[NewBaseDestination_Cd] [varchar](50) NULL,
	[NewBaseContainer] [varchar](50) NULL,
	[NewBaseCommodity] [varchar](50) NULL,
	[NewBaseCustomer] [varchar](50) NULL,
	[NewBaseEffective_Dt] [date] NULL,
	[NewBaseExpiry_Dt] [date] NULL,
	[NewBaseValidityPeriod] [int] NULL,
	[NewBaseRate] [decimal](16, 3) NULL,
	[NewBaseCurrencyCode] [varchar](3) NULL,
	[NewBaseUSDExchRate] [decimal](13, 6) NULL,
	[NewBaseRateKey] [decimal](12, 0) NOT NULL,
	[OLD_BASE_KEY] [decimal](12, 0) NULL,
	[PROJECT MONTHS] [varchar](8000) NULL,
	[Problem] [varchar](40) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Booking_Final]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Booking_Final](
	[AuditVersionID] [int] NULL,
	[SHIPMENT_NO_X] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](50) NULL,
	[IS_VSA_F] [char](1) NULL,
	[IS_IMPORT_SHIPMENT_F] [char](1) NULL,
	[IS_Operational_Shipment_F] [char](1) NULL,
	[Brand] [varchar](20) NULL,
	[Container_Key] [int] NULL,
	[CONTAINER_NO_X] [varchar](20) NULL,
	[CONTAINER_SIZE_X] [smallint] NULL,
	[CONTAINER_HEIGHT_X] [varchar](20) NULL,
	[CARGO_TYPE] [varchar](10) NULL,
	[FFE] [decimal](6, 2) NULL,
	[CONTAINER_TYPE_X] [varchar](20) NULL,
	[CargoWeightKG] [decimal](12, 4) NULL,
	[GrossWeightKG] [decimal](12, 4) NULL,
	[EquipmentTareWeight_Kgs] [decimal](12, 4) NULL,
	[SHIPMENT_CARGO_DESC_X] [varchar](255) NULL,
	[CommodityCode] [varchar](20) NULL,
	[IS_HAZ_F] [char](1) NULL,
	[IS_OOG_F] [char](1) NULL,
	[IS_BREAK_BULK_F] [char](1) NULL,
	[DIPLA] [varchar](20) NULL,
	[LOPFI] [varchar](20) NULL,
	[POD] [varchar](20) NULL,
	[POR] [varchar](20) NULL,
	[PRICE_CALC_BASE_LCL_D] [date] NULL,
	[Booking_Date] [date] NULL,
	[Booked_By] [varchar](50) NULL,
	[Booked_By_CD] [varchar](50) NULL,
	[Price_Owner] [varchar](50) NULL,
	[Price_Owner_CD] [varchar](50) NULL,
	[PO_CUST_SEGMENT] [varchar](50) NULL,
	[Consignee] [varchar](50) NULL,
	[Consignee_CD] [varchar](50) NULL,
	[STRING_ID_X] [varchar](20) NULL,
	[STRING_DIRECTION_X] [varchar](50) NULL,
	[ROUTE_CD] [varchar](20) NULL,
	[Shipment_Status] [varchar](50) NULL,
	[BAS] [money] NULL,
	[NON_BAS] [money] NULL,
	[SURCHARGES] [money] NULL,
	[Is_Live_Reefer] [int] NULL,
	[NAC_Customer] [varchar](50) NULL,
	[NAC_Customer_CD] [varchar](50) NULL,
	[Shipper] [varchar](50) NULL,
	[Shipper_CD] [varchar](50) NULL,
	[Extract_Date] [datetime] NULL DEFAULT (getdate())
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Booking_MasterShipment]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Booking_MasterShipment](
	[Shipment_No] [varchar](50) NULL,
	[MasterShipment_No] [varchar](50) NULL,
	[ShipmentStatus_Key] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Booking_Snapshot]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Booking_Snapshot](
	[AuditVersionID] [int] NULL,
	[BOOKING_KEY] [varchar](50) NULL,
	[SHIPMENT_NO_X] [varchar](50) NULL,
	[SHIPMENT_KEY] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](50) NULL,
	[SHIPMENT_ORIGIN] [varchar](50) NULL,
	[SHIPMENT_VRSN_ID_ORIGIN] [varchar](50) NULL,
	[HAS_TARGET] [char](1) NULL,
	[BRAND_KEY] [int] NULL,
	[REPORT_DATE] [smalldatetime] NULL,
	[ETD_DATE] [smalldatetime] NULL,
	[WEEK_NO] [int] NULL,
	[LASTDATEOFTHEWEEK] [smalldatetime] NULL,
	[DAYSTOETD] [int] NULL,
	[FFE] [decimal](6, 2) NULL,
	[FFE_WITH_CONTAINER] [decimal](6, 2) NULL,
	[FFE_EMPTY_SLOT] [decimal](6, 2) NULL,
	[DRY20_86] [int] NULL,
	[REEF20_86] [int] NULL,
	[DRY40_86] [int] NULL,
	[DRY40_96] [int] NULL,
	[REEF40_96] [int] NULL,
	[DRY45_96] [int] NULL,
	[OTHER_CONT_TYPE] [int] NULL,
	[LOAD_SITE] [varchar](50) NULL,
	[POR_SITE] [varchar](50) NULL,
	[POD_SITE] [varchar](50) NULL,
	[DISC_SITE] [varchar](50) NULL,
	[STRING_CD] [varchar](50) NULL,
	[STRINGDIRECTION] [varchar](10) NULL,
	[TRADE_CD] [varchar](50) NULL,
	[TRADE_DSC] [varchar](255) NULL,
	[SHIPPER_CUSTOMER_NO_X] [varchar](50) NULL,
	[SHIPPER_CUSTOMER_NAME] [varchar](255) NULL,
	[BB_CUSTOMER_NO_X] [varchar](50) NULL,
	[BB_CUSTOMER_NAME] [varchar](255) NULL,
	[BB_CUST_SEGMENT] [varchar](50) NULL,
	[STATUS_KEY] [int] NULL,
	[SHIPMENT_STATUS_CD] [varchar](50) NULL,
	[FLOWDIR_CD] [varchar](10) NULL,
	[FLOWDIR_DSC] [varchar](10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bookingcommitment]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bookingcommitment](
	[AuditVersionId] [int] NULL,
	[SHIPMENT_NO_X] [varchar](9) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](13) NULL,
	[CONTAINER_SIZE_X] [varchar](2) NULL,
	[CONTAINER_TYPE_X] [varchar](10) NULL,
	[CommitmentID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Commodity]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Commodity](
	[AuditImport_ID] [int] NULL,
	[Commodity_CD] [int] NULL,
	[CargoIfDry] [varchar](50) NULL,
	[CargoIfReef] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Commodity_Mstr]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Commodity_Mstr](
	[Commodity_ID] [int] NOT NULL,
	[Commodity_Code] [varchar](500) NULL,
	[COALESCE_COMMODITY] [varchar](500) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CTSClusterSubRegionMap]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CTSClusterSubRegionMap](
	[ClusterCode] [varchar](50) NULL,
	[ClusterName] [varchar](50) NULL,
	[Region] [varchar](50) NULL,
	[SubRegion] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerDetails]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerDetails](
	[Cust_Cd] [varchar](50) NULL,
	[Cust_Dsc] [varchar](50) NULL,
	[Cust_Key] [int] NULL,
	[CustActiveYesNo_Key] [int] NULL,
	[CustConcern_Cd] [varchar](50) NULL,
	[CustConcern_Dsc] [varchar](5000) NULL,
	[CustIndustry_Dsc] [varchar](50) NULL,
	[CustSegment_Cd] [int] NULL,
	[GeoCountry_Cd] [varchar](50) NULL,
	[AuditVersion_ID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerDetailsException]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerDetailsException](
	[Cust_Cd] [varchar](50) NULL,
	[Cust_Dsc] [varchar](50) NULL,
	[Cust_Key] [int] NULL,
	[CustActiveYesNo_Key] [int] NULL,
	[CustConcern_Cd] [varchar](50) NULL,
	[CustConcern_Dsc] [varchar](5000) NULL,
	[CustIndustry_Dsc] [varchar](50) NULL,
	[CustSegment_Cd] [int] NULL,
	[GeoCountry_Cd] [varchar](50) NULL,
	[AuditImportId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dates]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dates](
	[REPORT_DATE] [date] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dim_date]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[dim_date](
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
	[StandardDate] [varchar](10) NULL,
	[HolidayText] [varchar](50) NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[dim_date] ADD [WD_WE] [varchar](2) NULL
ALTER TABLE [dbo].[dim_date] ADD [PREVIOUSDAY] [date] NULL
ALTER TABLE [dbo].[dim_date] ADD [NEXTDAY] [date] NULL
ALTER TABLE [dbo].[dim_date] ADD [int_yearweek] [int] NULL
ALTER TABLE [dbo].[dim_date] ADD [char_yearweek] [char](7) NULL
ALTER TABLE [dbo].[dim_date] ADD [WEEK_SUNDAY_DATE] [date] NULL
ALTER TABLE [dbo].[dim_date] ADD [iso_WeekOfYear] [int] NULL
ALTER TABLE [dbo].[dim_date] ADD [iso_year] [int] NULL
ALTER TABLE [dbo].[dim_date] ADD [int_iso_yearweek] [int] NULL
ALTER TABLE [dbo].[dim_date] ADD [char_iso_yearweek] [char](7) NULL

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dim_rock_container]    Script Date: 7/21/2017 2:19:00 PM ******/
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
/****** Object:  Table [dbo].[dual]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dual](
	[num] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[moment] [datetime] NULL,
	[pid] [varchar](20) NULL,
	[root_pid] [varchar](20) NULL,
	[father_pid] [varchar](20) NULL,
	[project] [varchar](50) NULL,
	[job] [varchar](255) NULL,
	[context] [varchar](50) NULL,
	[priority] [int] NULL,
	[type] [varchar](255) NULL,
	[origin] [varchar](255) NULL,
	[message] [varchar](255) NULL,
	[code] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Exceptions_Booking]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exceptions_Booking](
	[AuditImportId] [int] NOT NULL,
	[Key_Row] [varchar](200) NULL,
	[SHIPMENT_NO_X] [varchar](200) NULL,
	[SHIPMENT_VRSN_ID_X] [varchar](200) NULL,
	[CREATE_USER] [varchar](200) NULL,
	[Create_User_Commerce_Flag] [varchar](200) NULL,
	[IS_VSA_F] [varchar](200) NULL,
	[IS_IMPORT_SHIPMENT_F] [varchar](200) NULL,
	[IS_Operational_Shipment_F] [varchar](200) NULL,
	[Brand] [varchar](200) NULL,
	[Container_Key] [varchar](200) NULL,
	[CONTAINER_NO_X] [varchar](200) NULL,
	[CONTAINER_SIZE_X] [varchar](200) NULL,
	[CONTAINER_HEIGHT_X] [varchar](200) NULL,
	[FFE] [varchar](200) NULL,
	[CONTAINER_TYPE_X] [varchar](200) NULL,
	[CargoWeightKG] [varchar](200) NULL,
	[GrossWeightKG] [varchar](200) NULL,
	[EquipmentTareWeight_Kgs] [varchar](200) NULL,
	[SHIPMENT_CARGO_DESC_X] [varchar](200) NULL,
	[CommodityCode] [varchar](200) NULL,
	[IS_HAZ_F] [varchar](200) NULL,
	[IS_OOG_F] [varchar](200) NULL,
	[IS_BREAK_BULK_F] [varchar](200) NULL,
	[DIPLA] [varchar](200) NULL,
	[DIPLA_Country] [varchar](200) NULL,
	[DIPLA_Cluster] [varchar](200) NULL,
	[LOPFI] [varchar](200) NULL,
	[LOPFI_Country] [varchar](200) NULL,
	[LOPFI_Cluster] [varchar](200) NULL,
	[POD] [varchar](200) NULL,
	[POD_Country] [varchar](200) NULL,
	[POD_Cluster] [varchar](200) NULL,
	[POR] [varchar](200) NULL,
	[POR_Country] [varchar](200) NULL,
	[POR_Cluster] [varchar](200) NULL,
	[PRICE_CALC_BASE_LCL_D] [varchar](200) NULL,
	[Mode_of_transport] [varchar](200) NULL,
	[Booking_Date] [varchar](200) NULL,
	[Booked_By] [varchar](200) NULL,
	[Booked_By_CD] [varchar](200) NULL,
	[Price_Owner] [varchar](200) NULL,
	[Price_Owner_CD] [varchar](200) NULL,
	[PO_CUST_SEGMENT] [varchar](200) NULL,
	[Consignee] [varchar](200) NULL,
	[Consignee_CD] [varchar](200) NULL,
	[NAC_Customer] [varchar](200) NULL,
	[NAC_Customer_CD] [varchar](200) NULL,
	[Shipper] [varchar](200) NULL,
	[Shipper_CD] [varchar](200) NULL,
	[Invoice_Party] [varchar](200) NULL,
	[Invoice_Party_CD] [varchar](200) NULL,
	[STRING_ID_X] [varchar](200) NULL,
	[STRING_DIRECTION_X] [varchar](200) NULL,
	[ROUTE_CD] [varchar](200) NULL,
	[Cargo_Weight] [varchar](200) NULL,
	[Shipment_Status] [varchar](200) NULL,
	[SHIPMENT_STATUS_CD] [varchar](200) NULL,
	[LINE_ITEM_NUMBER] [varchar](200) NULL,
	[Long_Short] [varchar](200) NULL,
	[IS_AFLS_PRICED_F] [varchar](200) NULL,
	[RATE_TYPE] [varchar](200) NULL,
	[BAS] [varchar](200) NULL,
	[NON_BAS] [varchar](200) NULL,
	[SURCHARGES] [varchar](2000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Exceptions_Schedule]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exceptions_Schedule](
	[Vessel] [varchar](50) NULL,
	[ACT_Arrival_Date] [varchar](50) NULL,
	[ACT_Arrival_Time] [varchar](50) NULL,
	[SCH_Arrival_Date] [varchar](50) NULL,
	[SCH_Arrival_Time] [varchar](50) NULL,
	[Sunday_of_ACT_Arr] [varchar](50) NULL,
	[Sunday_of_SCH_Arr] [varchar](50) NULL,
	[Arr_Stat] [varchar](50) NULL,
	[Voyage] [varchar](50) NULL,
	[Site_Code] [varchar](50) NULL,
	[Site] [varchar](50) NULL,
	[City_Code] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[Region_Code] [varchar](50) NULL,
	[Region] [varchar](50) NULL,
	[Dep_Voy] [varchar](50) NULL,
	[ACT_Departure_Date] [varchar](50) NULL,
	[ACT_Departure_Time] [varchar](50) NULL,
	[Sunday_of_ACT_Dep] [varchar](50) NULL,
	[SCH_Departure_Date] [varchar](50) NULL,
	[SCH_Departure_Time] [varchar](50) NULL,
	[Sunday_of_SCH_Dep] [varchar](50) NULL,
	[Dep_Stat] [varchar](50) NULL,
	[Service] [varchar](50) NULL,
	[VES_OPER] [varchar](50) NULL,
	[GSIS_Source_FBR] [varchar](50) NULL,
	[Vessel_Capacity_TEU] [varchar](50) NULL,
	[TEU] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GeoMaster]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GeoMaster](
	[AUDITVERSION_ID] [int] NULL,
	[Site_CD] [varchar](50) NULL,
	[Site] [varchar](50) NULL,
	[City_CD] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[Country_CD] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[Region_CD] [varchar](50) NULL,
	[Region] [varchar](50) NULL,
	[Cluster_CD] [varchar](50) NULL,
	[Clust] [varchar](50) NULL,
	[Pool_CD] [varchar](50) NULL,
	[Pool] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LKP_AFLS_COMMODITY_GROUPING]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LKP_AFLS_COMMODITY_GROUPING](
	[COMMODITY_CODE_HS_CODE] [varchar](500) NULL,
	[COMMODITY_GROUP_CODE] [varchar](500) NULL,
	[COMMODITY_GROUP_NAME] [varchar](500) NULL,
	[COMMODITY_NAME] [varchar](700) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lkp_avg_cost]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lkp_avg_cost](
	[PODGeoCity_Cd] [varchar](50) NULL,
	[PORGeoCity_Cd] [varchar](50) NULL,
	[ContainerSizeType] [varchar](59) NULL,
	[CostFlowUSD] [decimal](38, 11) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lkp_rcd1]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lkp_rcd1](
	[NewBaseOrigin_Cd] [varchar](50) NULL,
	[NewBaseDestination_Cd] [varchar](50) NULL,
	[RouteCodeDirection_Cd] [varchar](20) NULL,
	[blf] [decimal](38, 2) NULL,
	[pod_por_ccd] [varchar](8000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lkp_rcd2]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lkp_rcd2](
	[NewBaseOrigin_Cd] [varchar](50) NULL,
	[NewBaseDestination_Cd] [varchar](50) NULL,
	[max_blf] [decimal](38, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lkp_WeeklyNewBaseUSDExchRate]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lkp_WeeklyNewBaseUSDExchRate](
	[BaseCurrencyCode] [varchar](3) NULL,
	[BaseUSDExchRate] [decimal](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lkp_WeeklyNewBaseUSDExchRate_V1]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lkp_WeeklyNewBaseUSDExchRate_V1](
	[BaseCurrencyCode] [varchar](3) NULL,
	[BaseUSDExchRate] [decimal](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOS_Segment_Mstr]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOS_Segment_Mstr](
	[Segment_ID] [int] NOT NULL,
	[Segment_Name] [varchar](500) NULL,
	[RCD] [varchar](20) NULL,
	[CONTAINER_TYPE] [varchar](62) NOT NULL,
	[Commodity_ID] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MacroMarket]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[MacroMarket](
	[AuditVersion_ID] [int] NOT NULL,
	[Trade] [varchar](50) NULL,
	[Micro_market_origin] [varchar](50) NULL,
	[Micro_market_dest] [varchar](103) NULL,
	[Macro_market] [varchar](101) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Map_MicroMarketProjectMonths]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Map_MicroMarketProjectMonths](
	[COD] [varchar](103) NOT NULL,
	[ContainerSizeType] [varchar](62) NULL,
	[mod] [varchar](103) NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Map_MicroMarketProjectMonths] ADD [mc] [varchar](50) NULL
ALTER TABLE [dbo].[Map_MicroMarketProjectMonths] ADD [ProjectMonths] [varchar](12) NULL
ALTER TABLE [dbo].[Map_MicroMarketProjectMonths] ADD [sum_ffe] [decimal](38, 2) NULL

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Map_RCD_Trade_Dir]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Map_RCD_Trade_Dir](
	[AUDITIMPORT_ID] [numeric](10, 0) NULL,
	[VALID_ROUTE_CODE_DIRECTION] [varchar](20) NULL,
	[FFE_IN_LOS] [numeric](10, 0) NULL,
	[TRADE_DIRECTION] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MasterShipment]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MasterShipment](
	[AUDITVERSION_ID] [int] NULL,
	[Shipment_No] [varchar](50) NULL,
	[MasterShipment_No] [varchar](50) NULL,
	[ShipmentStatus_Key] [varchar](50) NULL,
	[Extract_Date] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MEPC]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MEPC](
	[ID] [int] NOT NULL,
	[RunID] [int] NULL,
	[LOPFI] [varchar](5) NOT NULL,
	[DIPLA] [varchar](5) NOT NULL,
	[Week] [date] NOT NULL,
	[ContainerSize] [varchar](2) NOT NULL,
	[CargoType] [varchar](4) NOT NULL,
	[WeightAvg] [float] NULL,
	[RevenueAvg] [float] NULL,
	[UDF] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MEPC_EXPORT_OE]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MEPC_EXPORT_OE](
	[product_id] [numeric](10, 0) NULL,
	[product_no_level] [numeric](3, 0) NULL,
	[por_geoid] [nvarchar](13) NULL,
	[pod_geoid] [nvarchar](13) NULL,
	[container_size] [nvarchar](4) NULL,
	[container_type] [nvarchar](4) NULL,
	[fromservice] [nvarchar](4) NULL,
	[toservice] [nvarchar](4) NULL,
	[company] [varchar](10) NULL,
	[Trade_Lane] [varchar](30) NULL,
	[Number_Of_Products] [numeric](3, 0) NULL,
	[Number_Of_Links_In_Product] [numeric](2, 0) NULL,
	[por] [varchar](8) NULL,
	[pod] [varchar](8) NULL,
	[il_flag] [nvarchar](1) NULL,
	[originsite] [nvarchar](13) NULL,
	[destsite] [nvarchar](13) NULL,
	[carrier] [nvarchar](11) NULL,
	[transmode] [nvarchar](3) NULL,
	[transtype] [nvarchar](4) NULL,
	[vessel] [nvarchar](3) NULL,
	[voyage] [nvarchar](10) NULL,
	[vesselflag] [nvarchar](2) NULL,
	[distance] [numeric](6, 0) NULL,
	[transittime] [numeric](7, 0) NULL,
	[layover] [numeric](7, 0) NULL,
	[linkcost] [numeric](11, 2) NULL,
	[routingtype] [nvarchar](1) NULL,
	[link_direction] [nvarchar](3) NULL,
	[canal_siteid] [nvarchar](13) NULL,
	[origindeparturedate] [datetime] NULL,
	[destinationarrivaldate] [datetime] NULL,
	[isscheduled] [nvarchar](1) NULL,
	[service] [nvarchar](3) NULL,
	[commalias] [text] NULL,
	[GLOBAL_LENGTH] [varchar](5) NULL,
	[RKCMSTAT_LENGTH] [varchar](5) NULL,
	[RKCMSTAT_SECTYPE] [varchar](8) NULL,
	[RKCMSTAT_RC] [varchar](6) NULL,
	[RKCMSTAT_INFORMATIVE] [varchar](6) NULL,
	[RKCMSTAT_WARNING] [varchar](6) NULL,
	[RKCMSTAT_ERROR] [varchar](6) NULL,
	[RKCMSTAT_SEVERE] [varchar](6) NULL,
	[LENGTH] [varchar](5) NULL,
	[SECTYPE] [varchar](8) NULL,
	[CM] [varchar](13) NULL,
	[OM] [varchar](13) NULL,
	[NM] [varchar](13) NULL,
	[CYIELD] [varchar](13) NULL,
	[OYIELD] [varchar](13) NULL,
	[NYIELD] [varchar](13) NULL,
	[DIVACOST] [varchar](13) NULL,
	[CDNCOST] [varchar](13) NULL,
	[SEFOCOST] [varchar](13) NULL,
	[FVAOCOST] [varchar](13) NULL,
	[FLOACOST] [varchar](13) NULL,
	[FRSUM] [varchar](9) NULL,
	[TRANDAYS] [varchar](5) NULL,
	[CM_DAY] [varchar](13) NULL,
	[OM_DAY] [varchar](13) NULL,
	[NM_DAY] [varchar](13) NULL,
	[CYIELD_DAY] [varchar](13) NULL,
	[OYIELD_DAY] [varchar](13) NULL,
	[NYIELD_DAY] [varchar](13) NULL,
	[RET_CODE] [varchar](4) NULL,
	[Created] [datetime] NULL,
	[SourceId] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ML_port_X_Region]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ML_port_X_Region](
	[M_geo_city_code] [varchar](5) NULL,
	[X_region_name] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ml_process_log]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ml_process_log](
	[PROCESS_ID] [int] NOT NULL,
	[PROCESS_NAME] [varchar](50) NULL,
	[USER_NAME] [nvarchar](255) NULL,
	[START_DT] [datetime] NULL,
	[END_DT] [datetime] NULL,
	[STATUS] [varchar](10) NULL,
	[ACTION] [tinyint] NULL,
	[PARENT_PROCESS_ID] [int] NULL,
	[NOTE] [nvarchar](2000) NULL,
	[START_STEP] [tinyint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ml_process_log_detail]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ml_process_log_detail](
	[PROCESS_ID] [int] NOT NULL,
	[STEP_ID] [tinyint] NOT NULL,
	[STEP_NAME] [varchar](255) NULL,
	[START_DT] [datetime] NULL,
	[END_DT] [datetime] NULL,
	[STATUS] [varchar](10) NULL,
	[ROWS_PROCESSED] [int] NULL,
	[ACTION] [tinyint] NULL,
	[NOTE] [nvarchar](2000) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mstr_Brand]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mstr_Brand](
	[brand_ID] [int] NULL,
	[brand_dsc] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mstr_City]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mstr_City](
	[CityId] [int] IDENTITY(1,1) NOT NULL,
	[CityCode] [varchar](10) NULL,
	[City] [varchar](50) NULL,
	[ClusterCode] [varchar](10) NULL,
	[Cluster] [varchar](50) NULL,
	[RegionCode] [varchar](10) NULL,
	[Region] [varchar](50) NULL,
	[CountryCode] [varchar](10) NULL,
	[Country] [varchar](50) NULL,
	[Latitude] [decimal](10, 5) NULL,
	[Longitude] [decimal](10, 5) NULL,
	[UNLocation] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mstr_ContainerType]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mstr_ContainerType](
	[Equipment_ID] [int] NULL,
	[EquipmentType] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mstr_Contract_LengthType]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mstr_Contract_LengthType](
	[Length_Type_ID] [int] NULL,
	[length_Type] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mstr_Contract_Rate_Line_Type]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mstr_Contract_Rate_Line_Type](
	[Rate_Line_Type_ID] [int] NULL,
	[Rate_Line_Type] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mstr_PortCodes]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mstr_PortCodes](
	[XEN_UN_LOC_CD] [varchar](100) NULL,
	[ML_UN_LOC_CD] [varchar](100) NULL,
	[GEO_CODE] [varchar](6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mstr_Site]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mstr_Site](
	[SiteId] [int] IDENTITY(1,1) NOT NULL,
	[SiteCode] [varchar](10) NULL,
	[Site] [varchar](50) NULL,
	[CityId] [int] NULL,
	[PoolCode] [varchar](10) NULL,
	[Pool] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[mvp1_weekly_hist_demand]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mvp1_weekly_hist_demand](
	[Origin] [varchar](5) NULL,
	[Destination] [varchar](5) NULL,
	[Week] [char](7) NULL,
	[EndOfWeek] [date] NULL,
	[CargoType] [varchar](5) NULL,
	[ContainerSize] [varchar](10) NULL,
	[CommitmentFlag] [varchar](5) NULL,
	[WeightAvg] [numeric](38, 6) NULL,
	[RevenueAvg] [float] NULL,
	[TotalFFE] [numeric](38, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NewBaseRefExcluded]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NewBaseRefExcluded](
	[NewBaseRef] [varchar](50) NULL,
	[Problem] [varchar](40) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oe_ActualForecast]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oe_ActualForecast](
	[Service] [varchar](3) NOT NULL,
	[ServiceCode] [varchar](3) NOT NULL,
	[Direction] [varchar](3) NOT NULL,
	[RouteCode] [varchar](3) NOT NULL,
	[CargoType] [varchar](4) NOT NULL,
	[Voyage] [varchar](4) NOT NULL,
	[Vessel] [varchar](4) NOT NULL,
	[DepartureDate] [date] NOT NULL,
	[Bucket] [varchar](4) NOT NULL,
	[CYperFFE] [int] NULL,
	[PublishedVersion] [int] NULL,
	[PublishedDate] [date] NULL,
	[ValidDate] [date] NULL,
	[DaysToDep] [int] NOT NULL,
	[Units] [int] NOT NULL,
	[FFE] [decimal](38, 1) NOT NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[UTM_CY] [decimal](38, 1) NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oe_capinv]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oe_capinv](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceCode] [varchar](5) NULL,
	[VesselCode] [varchar](5) NULL,
	[Port] [varchar](10) NULL,
	[RouteCode] [varchar](5) NULL,
	[Voyage] [varchar](5) NULL,
	[DepartureDate] [datetime] NULL,
	[CargoType] [varchar](5) NULL,
	[Bucket] [varchar](5) NULL,
	[Capacity] [int] NULL,
	[CommitmentAllocation] [int] NULL,
	[OverbookingLevel] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oe_protectionlevels]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oe_protectionlevels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceCode] [varchar](5) NULL,
	[VesselCode] [varchar](5) NULL,
	[Port] [varchar](10) NULL,
	[RouteCode] [varchar](5) NULL,
	[Direction] [varchar](5) NULL,
	[Voyage] [varchar](5) NULL,
	[DepartureDate] [datetime] NULL,
	[CargoType] [varchar](5) NULL,
	[SteeringType] [varchar](5) NULL,
	[CreationDate] [datetime] NULL,
	[Bucket] [varchar](5) NULL,
	[ProtectionLevel] [int] NULL,
	[Mean] [varchar](50) NULL,
	[StandardDeviation] [varchar](50) NULL,
	[Rate] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oe_release1_dev_ActualForecast_tmp]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oe_release1_dev_ActualForecast_tmp](
	[Service] [varchar](3) NOT NULL,
	[ServiceCode] [varchar](3) NOT NULL,
	[Direction] [varchar](3) NOT NULL,
	[RouteCode] [varchar](3) NOT NULL,
	[CargoType] [varchar](4) NOT NULL,
	[Voyage] [varchar](4) NOT NULL,
	[Vessel] [varchar](4) NOT NULL,
	[DepartureDate] [date] NOT NULL,
	[Bucket] [varchar](4) NOT NULL,
	[CYperFFE] [int] NULL,
	[PublishedVersion] [int] NULL,
	[PublishedDate] [date] NULL,
	[ValidDate] [date] NULL,
	[DaysToDep] [int] NOT NULL,
	[Units] [int] NOT NULL,
	[FFE] [decimal](38, 1) NOT NULL,
	[FFEWithOOG] [decimal](38, 1) NULL,
	[UTM_CY] [decimal](38, 1) NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oe_release1_dev_protectionlevels_tmp]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oe_release1_dev_protectionlevels_tmp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceCode] [varchar](5) NULL,
	[VesselCode] [varchar](5) NULL,
	[Port] [varchar](10) NULL,
	[RouteCode] [varchar](5) NULL,
	[Direction] [varchar](5) NULL,
	[Voyage] [varchar](5) NULL,
	[DepartureDate] [datetime] NULL,
	[CargoType] [varchar](5) NULL,
	[SteeringType] [varchar](5) NULL,
	[CreationDate] [datetime] NULL,
	[Bucket] [varchar](5) NULL,
	[ProtectionLevel] [int] NULL,
	[Mean] [float] NULL,
	[StandardDeviation] [float] NULL,
	[Rate] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oe_release1_dev_relevantdepartures_tmp]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oe_release1_dev_relevantdepartures_tmp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Direction] [varchar](5) NOT NULL,
	[Port] [varchar](10) NOT NULL,
	[RouteCode] [varchar](5) NOT NULL,
	[ServiceCode] [varchar](5) NOT NULL,
	[ServiceName] [varchar](255) NOT NULL,
	[Voyage] [varchar](5) NOT NULL,
	[VesselCode] [varchar](5) NOT NULL,
	[VesselName] [varchar](255) NOT NULL,
	[DepartureDate] [datetime] NOT NULL,
	[LastUptakeSite] [varchar](10) NOT NULL,
	[IsIsc] [bit] NOT NULL,
	[LastDischargePortRegion] [varchar](10) NOT NULL,
 CONSTRAINT [PK_oe_release1_dev_relevantdepartures_tmp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[oe_relevantdepartures]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[oe_relevantdepartures](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Direction] [varchar](5) NOT NULL,
	[Port] [varchar](10) NOT NULL,
	[RouteCode] [varchar](5) NOT NULL,
	[ServiceCode] [varchar](5) NOT NULL,
	[ServiceName] [varchar](255) NOT NULL,
	[Voyage] [varchar](5) NOT NULL,
	[VesselCode] [varchar](5) NOT NULL,
	[VesselName] [varchar](255) NOT NULL,
	[DepartureDate] [datetime] NOT NULL,
	[LastUptakeSite] [varchar](10) NOT NULL,
	[IsIsc] [bit] NOT NULL,
	[LastDischargePortRegion] [varchar](10) NOT NULL,
 CONSTRAINT [PK_oe_release1_dev_relevantdepartures] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[psm_sum_per]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[psm_sum_per](
	[variable] [varchar](16) NULL,
	[unwt] [float] NULL,
	[wt] [float] NULL,
	[auditversion_id] [smallint] NULL,
	[time_exe] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RevenueOptimizationLegs]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RevenueOptimizationLegs](
	[ID] [int] IDENTITY(0,1) NOT NULL,
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
	[LastUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_RevenueOptimizationCalls] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RevenueOptimizationOperatorDetails]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RevenueOptimizationOperatorDetails](
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
	[AllocationPlugs] [int] NULL,
 CONSTRAINT [PK_RevenueOptimizationOperatorDetails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[OperatorCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ROUTELEGS_SCHEDULE]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ROUTELEGS_SCHEDULE](
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
/****** Object:  Table [dbo].[RouteLegs_schedule84K]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RouteLegs_schedule84K](
	[ScheduleID] [bigint] NULL,
	[servicecode] [varchar](50) NULL,
	[vesselcode] [varchar](10) NULL,
	[Depvoyage] [varchar](50) NULL,
	[ARRVOYAGE] [varchar](10) NULL,
	[depServiceDirection] [varchar](50) NULL,
	[arrServiceDirection] [varchar](10) NULL,
	[LegSeqId] [bigint] NULL,
	[departureport] [varchar](50) NULL,
	[arrivalport] [varchar](50) NULL,
	[nextDepVoyage] [varchar](50) NULL,
	[nextarrivalvoyage] [varchar](10) NULL,
	[original_etd] [datetime] NULL,
	[actual_etd] [datetime] NULL,
	[arrivalDate] [datetime] NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL,
	[firstarrScheduleID] [bigint] NULL,
	[lastArrScheduleID] [bigint] NULL,
	[firstarrdepScheduleID] [bigint] NULL,
	[lastarrdepScheduleID] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RouteLegs_schedule84K_LegSeq]    Script Date: 7/21/2017 2:19:00 PM ******/
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
/****** Object:  Table [dbo].[RouteLinks]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RouteLinks](
	[AUDITVERSIONID] [int] NULL,
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
	[DepUTCExpectedTs] [date] NULL,
	[ArrUTCExpectedTs] [date] NULL,
	[WaterLandMode_Fl] [varchar](50) NULL,
	[DIPLA] [varchar](50) NULL,
	[LOPFI] [varchar](50) NULL,
	[Extract_Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule](
	[AuditVersionId] [int] NULL,
	[Vessel] [varchar](10) NULL,
	[VesselOperator] [varchar](50) NULL,
	[DepServiceCode] [varchar](50) NULL,
	[DepServiceDir] [varchar](50) NULL,
	[DepVoyage] [varchar](50) NULL,
	[Dep_Stat] [varchar](10) NULL,
	[SchDepartureDate] [datetime] NULL,
	[ActDepartureDate] [datetime] NULL,
	[SchDepartureDateUTC] [datetime] NULL,
	[ActDepartureDateUTC] [datetime] NULL,
	[Site_Code] [varchar](50) NULL,
	[ArrVoyage] [varchar](10) NULL,
	[ArrServiceDir] [varchar](10) NULL,
	[ArrServiceCode] [varchar](50) NULL,
	[Arr_Stat] [varchar](50) NULL,
	[SchArrivalDate] [datetime] NULL,
	[ActArrivalDate] [datetime] NULL,
	[SchArrivalDateUTC] [datetime] NULL,
	[ActArrivalDateUTC] [datetime] NULL,
	[Vessel_Capacity_TEU] [int] NULL,
	[TEU] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[shipment_dates]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[shipment_dates](
	[shipment_no_x] [varchar](50) NULL,
	[shipment_vrsn_id_x] [varchar](50) NULL,
	[report_date] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[src_los]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[src_los](
	[auditVersion_id] [int] NOT NULL,
	[ROUTE_CODE_DIRECTION] [varchar](50) NULL,
	[BRAND_DSC] [varchar](100) NULL,
	[LENGTH_TYPE] [varchar](50) NULL,
	[PROJECT_ID] [varchar](50) NULL,
	[PROJECT_NAME] [varchar](50) NULL,
	[PRICING_CUSTGROUP_FLAG] [varchar](50) NULL,
	[PRICING_CUSTOMER_CODE] [varchar](50) NULL,
	[PRICING_CUSTOMER] [varchar](100) NULL,
	[PRICING_ORIGIN_GEOSITE_CODE] [varchar](50) NULL,
	[PRICING_ORIGIN_GEOSITE] [varchar](100) NULL,
	[PRICING_ORIGIN_GEOCITY_CODE] [varchar](50) NULL,
	[PRICING_ORIGIN_GEOCITY] [varchar](100) NULL,
	[PRICING_ORIGIN_GEOCOUNTRY_CODE] [varchar](50) NULL,
	[PRICING_ORIGIN_GEOCOUNTRY] [varchar](100) NULL,
	[PRICING_ORIGIN_GEOCC_CODE] [varchar](50) NULL,
	[PRICING_ORIGIN_GEOCC] [varchar](100) NULL,
	[PRICING_ORIGIN_GEOREGION_CODE] [varchar](50) NULL,
	[PRICING_ORIGIN_GEOREGION] [varchar](100) NULL,
	[PRICING_DEST_GEOSITE_CODE] [varchar](50) NULL,
	[PRICING_DEST_GEOSITE] [varchar](100) NULL,
	[PRICING_DEST_GEOCITY_CODE] [varchar](50) NULL,
	[PRICING_DEST_GEOCITY] [varchar](100) NULL,
	[PRICING_DEST_GEOCOUNTRY_CODE] [varchar](50) NULL,
	[PRICING_DEST_GEOCOUNTRY] [varchar](100) NULL,
	[PRICING_DEST_GEOCC_CODE] [varchar](50) NULL,
	[PRICING_DEST_GEOCC] [varchar](100) NULL,
	[PRICING_DEST_GEOREGION_CODE] [varchar](50) NULL,
	[PRICING_DEST_GEOREGION] [varchar](100) NULL,
	[PRICING_EQUIPMENTSIZE] [int] NULL,
	[PRICING_EQUIPMENTTYPE] [varchar](50) NULL,
	[PRICING_EFFECTIVEDATE] [date] NULL,
	[PRICING_EXPIREDATE] [date] NULL,
	[PRICING_COMMODITY_CODE] [varchar](50) NULL,
	[PRICING_COMMODITY] [varchar](500) NULL,
	[PRICING_NOR] [varchar](50) NULL,
	[PRICING_SOC] [varchar](50) NULL,
	[PRICING_EMPTY_FLAG] [varchar](50) NULL,
	[PRICING_VALIDITY_DAYS] [int] NULL,
	[QUOTE_ID] [varchar](50) NULL,
	[QUOTING_ORIGIN_GEOSITE_CODE] [varchar](50) NULL,
	[QUOTING_ORIGIN_GEOSITE] [varchar](100) NULL,
	[QUOTING_ORIGIN_GEOCITY_CODE] [varchar](50) NULL,
	[QUOTING_ORIGIN_GEOCITY] [varchar](100) NULL,
	[QUOTING_ORIGIN_GEOCOUNTRY_CODE] [varchar](50) NULL,
	[QUOTING_ORIGIN_GEOCOUNTRY] [varchar](100) NULL,
	[QUOTING_ORIGIN_GEOCC_CODE] [varchar](50) NULL,
	[QUOTING_ORIGIN_GEOCC] [varchar](100) NULL,
	[QUOTING_ORIGIN_GEOREGION_CODE] [varchar](50) NULL,
	[QUOTING_ORIGIN_GEOREGION] [varchar](100) NULL,
	[QUOTING_DEST_GEOSITE_CODE] [varchar](50) NULL,
	[QUOTING_DEST_GEOSITE] [varchar](100) NULL,
	[QUOTING_DEST_GEOCITY_CODE] [varchar](50) NULL,
	[QUOTING_DEST_GEOCITY] [varchar](100) NULL,
	[QUOTING_DEST_GEOCOUNTRY_CODE] [varchar](50) NULL,
	[QUOTING_DEST_GEOCOUNTRY] [varchar](100) NULL,
	[QUOTING_DEST_GEOCC_CODE] [varchar](50) NULL,
	[QUOTING_DEST_GEOCC] [varchar](100) NULL,
	[QUOTING_DEST_GEOREGION_CODE] [varchar](50) NULL,
	[QUOTING_DEST_GEOREGION] [varchar](100) NULL,
	[QUOTING_NOR] [varchar](50) NULL,
	[QUOTING_SOC] [varchar](50) NULL,
	[QUOTING_EMPTY_FLAG] [varchar](50) NULL,
	[QUOTING_EQUIPMENTSIZE] [int] NULL,
	[QUOTING_EQUIPMENTTYPE] [varchar](50) NULL,
	[QUOTING_COMMODITY_CODE] [varchar](50) NULL,
	[QUOTING_COMMODITY] [varchar](500) NULL,
	[QUOTING_CUSTOMER] [varchar](100) NULL,
	[QUOTING_CUSTOMER_CODE] [varchar](50) NULL,
	[QUOTING_CUSTOMER_CONCERN] [varchar](100) NULL,
	[QUOTINGCUSTCONCERN_CD] [varchar](50) NULL,
	[QUOTING_NACCUSTOMER] [varchar](50) NULL,
	[QUOTING_NACCUSTOMER_CD] [varchar](50) NULL,
	[QUOTING_NACCUSTOMER_CONCERN] [varchar](100) NULL,
	[QUOTINGNACCUSTCONCERN_CD] [varchar](50) NULL,
	[QUOTELINEITEM_NO] [varchar](50) NULL,
	[QUOTING_EFFECTIVEDATE] [date] NULL,
	[QUOTING_EXPIREDATE] [date] NULL,
	[QBA_CREATE_DATE] [date] NULL,
	[QUOTED_FFES] [decimal](38, 3) NULL,
	[QUOTETAT_HOURS] [int] NULL,
	[QUOTELINESTATUS] [varchar](50) NULL,
	[QUOTEQBA_FLAG] [varchar](50) NULL,
	[CONTRACT_LINEITEM_NO] [varchar](50) NULL,
	[SHIPMENT_NO] [varchar](50) NULL,
	[PODGEOSITE_GEOSITE_CODE] [varchar](50) NULL,
	[PODGEOSITE_GEOSITE] [varchar](100) NULL,
	[PODGEOSITE_GEOCITY_CODE] [varchar](50) NULL,
	[PODGEOSITE_GEOCITY] [varchar](100) NULL,
	[PODGEOSITE_GEOCOUNTRY_CODE] [varchar](50) NULL,
	[PODGEOSITE_GEOCOUNTRY] [varchar](100) NULL,
	[PODGEOSITE_GEOCC_CODE] [varchar](50) NULL,
	[PODGEOSITE_GEOCC] [varchar](100) NULL,
	[PODGEOSITE_GEOREGION_CODE] [varchar](50) NULL,
	[PODGEOSITE_GEOREGION] [varchar](100) NULL,
	[PORGEOSITE_GEOSITE_CODE] [varchar](50) NULL,
	[PORGEOSITE_GEOSITE] [varchar](100) NULL,
	[PORGEOSITE_GEOCITY_CODE] [varchar](50) NULL,
	[PORGEOSITE_GEOCITY] [varchar](100) NULL,
	[PORGEOSITE_GEOCOUNTRY_CODE] [varchar](50) NULL,
	[PORGEOSITE_GEOCOUNTRY] [varchar](100) NULL,
	[PORGEOSITE_GEOCC_CODE] [varchar](50) NULL,
	[PORGEOSITE_GEOCC] [varchar](100) NULL,
	[PORGEOSITE_GEOREGION_CODE] [varchar](50) NULL,
	[PORGEOSITE_GEOREGION] [varchar](100) NULL,
	[SHIPPING_PRICEOWNER] [varchar](100) NULL,
	[SHIPPING_PRICEOWNER_CODE] [varchar](50) NULL,
	[SHIPPING_PRICEOWNER_CONCERN] [varchar](100) NULL,
	[SHIPMNTPRICEOWNERCUSTCNCRN_CD] [varchar](50) NULL,
	[SHIPPING_EQUIPMENT_SIZE] [int] NULL,
	[SHIPMENTEQUIPMENTSUBTYPE_DSC] [varchar](100) NULL,
	[SHIPMENTEQUIPMENT_NO] [varchar](50) NULL,
	[SHIPPING_NAC_CUSTOMER_CONCERN] [varchar](100) NULL,
	[SHIPMENTNACCUSTCONCERN_CD] [varchar](50) NULL,
	[SHIPMENTNACCUST_CD] [varchar](50) NULL,
	[SHIPPING_NAC_CUSTOMER] [varchar](100) NULL,
	[SHIPMENT_COMMODITY] [varchar](500) NULL,
	[SHIPMENT_COMMODITY_CODE] [varchar](50) NULL,
	[SHIPMENT_SERVICE_MODE] [varchar](50) NULL,
	[PCD_DATE] [date] NULL,
	[RATE_LINE_TYPE] [varchar](50) NULL,
	[MANUALCONTRACT_FLAG] [varchar](50) NULL,
	[M_NUMBEROFCONTAINER] [decimal](15, 2) NULL,
	[M_FFE_DUMMY] [decimal](10, 2) NULL,
	[M_BAS_AMT_USD] [decimal](38, 11) NULL,
	[M_BASADJUSTMENT_AMT_USD] [decimal](38, 11) NULL,
	[M_BOOKEDREVENUE_AMT_USD] [decimal](38, 11) NULL,
	[M_MARKETRATEAMT_USD] [decimal](38, 11) NULL,
	[M_WEIGHT_AMT_USD] [decimal](38, 11) NULL,
	[M_CONTRIBUTION_AMT] [decimal](38, 11) NULL,
	[M_REVENUE1_AMT_USD] [decimal](38, 11) NULL,
	[M_REVENUE1ADJUSTED_AMT_USD] [decimal](38, 11) NULL,
	[M_OUTPUT_AMT_USD] [decimal](38, 11) NULL,
	[M_CONTRACTRATEAMT_USD] [decimal](38, 11) NULL,
	[M_ACTUALOCEANFREIGHTRATE_USD] [decimal](30, 10) NULL,
	[M_QUOTERATEAMT_USD] [decimal](38, 11) NULL,
	[M_QUOTERATEAMT_USD_FFE] [decimal](38, 11) NULL,
	[BASE_ORIGIN] [varchar](50) NULL,
	[BASE_DESTINATION] [varchar](50) NULL,
	[BASE_CONTAINER] [varchar](50) NULL,
	[BASE_COMMODITY] [varchar](50) NULL,
	[BASE_CUSTOMER] [varchar](50) NULL,
	[Base_Key] [decimal](12, 0) NULL,
	[BaseRate] [decimal](16, 3) NULL,
	[BaseCurrencyCode] [varchar](3) NULL,
	[BaseUSDExchRate] [decimal](13, 6) NULL,
	[HEADER_CONTAINER] [varchar](50) NULL,
	[HEADER_COMMODITY] [varchar](50) NULL,
	[HEADER_CUSTOMER] [varchar](50) NULL,
	[As_of_Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[src_Xeneta_LanesAndRegions]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[src_Xeneta_LanesAndRegions](
	[AuditVersion_ID] [int] NOT NULL,
	[validity_date] [varchar](10) NULL,
	[port_origin_cd] [varchar](5) NULL,
	[port_destination_cd] [varchar](5) NULL,
	[EquipmentSize_Cd] [char](2) NULL,
	[EquipmentHeight_Cd] [varchar](100) NULL,
	[contractLength] [varchar](12) NULL,
	[val_port_quant2_5] [int] NULL,
	[val_port_quant25] [int] NULL,
	[val_port_mean] [int] NULL,
	[val_port_median] [int] NULL,
	[val_port_quant75] [int] NULL,
	[val_port_quant97_5] [int] NULL,
	[port_dataQuality] [varchar](11) NULL,
	[region_origin_dsc] [varchar](100) NULL,
	[region_destination_dsc] [varchar](100) NULL,
	[val_region_quant2_5] [int] NULL,
	[val_region_quant25] [int] NULL,
	[val_region_mean] [int] NULL,
	[val_region_median] [int] NULL,
	[val_region_quant75] [int] NULL,
	[val_region_quant97_5] [int] NULL,
	[region_dataQuality] [varchar](11) NULL,
	[As_of_Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[src_Xeneta_LanesAndRegions_BackwardLooking]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[src_Xeneta_LanesAndRegions_BackwardLooking](
	[AuditVersion_ID] [int] NOT NULL,
	[validity_date] [varchar](10) NULL,
	[port_origin_cd] [varchar](5) NULL,
	[port_destination_cd] [varchar](5) NULL,
	[EquipmentSize_Cd] [char](2) NULL,
	[EquipmentHeight_Cd] [varchar](100) NULL,
	[contractLength] [varchar](12) NULL,
	[val_port_quant2_5] [int] NULL,
	[val_port_quant25] [int] NULL,
	[val_port_mean] [int] NULL,
	[val_port_median] [int] NULL,
	[val_port_quant75] [int] NULL,
	[val_port_quant97_5] [int] NULL,
	[port_dataQuality] [varchar](11) NULL,
	[region_origin_dsc] [varchar](100) NULL,
	[region_destination_dsc] [varchar](100) NULL,
	[val_region_quant2_5] [int] NULL,
	[val_region_quant25] [int] NULL,
	[val_region_mean] [int] NULL,
	[val_region_median] [int] NULL,
	[val_region_quant75] [int] NULL,
	[val_region_quant97_5] [int] NULL,
	[region_dataQuality] [varchar](11) NULL,
	[As_of_Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[src_Xeneta_LanesAndRegions_ForwardLooking]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[src_Xeneta_LanesAndRegions_ForwardLooking](
	[AuditVersion_ID] [int] NOT NULL,
	[validity_date] [varchar](10) NULL,
	[port_origin_cd] [varchar](5) NULL,
	[port_destination_cd] [varchar](5) NULL,
	[EquipmentSize_Cd] [char](2) NULL,
	[EquipmentHeight_Cd] [varchar](100) NULL,
	[contractLength] [varchar](12) NULL,
	[val_port_quant2_5] [int] NULL,
	[val_port_quant25] [int] NULL,
	[val_port_mean] [int] NULL,
	[val_port_median] [int] NULL,
	[val_port_quant75] [int] NULL,
	[val_port_quant97_5] [int] NULL,
	[port_dataQuality] [varchar](11) NULL,
	[region_origin_dsc] [varchar](100) NULL,
	[region_destination_dsc] [varchar](100) NULL,
	[val_region_quant2_5] [int] NULL,
	[val_region_quant25] [int] NULL,
	[val_region_mean] [int] NULL,
	[val_region_median] [int] NULL,
	[val_region_quant75] [int] NULL,
	[val_region_quant97_5] [int] NULL,
	[region_dataQuality] [varchar](11) NULL,
	[As_of_Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StatsLog]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StatsLog](
	[moment] [datetime] NULL,
	[pid] [varchar](20) NULL,
	[father_pid] [varchar](20) NULL,
	[root_pid] [varchar](20) NULL,
	[system_pid] [bigint] NULL,
	[project] [varchar](50) NULL,
	[job] [varchar](255) NULL,
	[job_repository_id] [varchar](255) NULL,
	[job_version] [varchar](255) NULL,
	[context] [varchar](50) NULL,
	[origin] [varchar](255) NULL,
	[message_type] [varchar](255) NULL,
	[message] [varchar](255) NULL,
	[duration] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StringTradeMap]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StringTradeMap](
	[Column1] [varchar](50) NULL,
	[String_Cd] [varchar](50) NULL,
	[Month_Cd] [varchar](50) NULL,
	[Trade_Cd] [varchar](50) NULL,
	[ShipmentRoute_CD] [varchar](50) NULL,
	[Sum(BookedFFE_Cnt)] [numeric](10, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sys_config_param]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sys_config_param](
	[Param_ID] [int] NOT NULL,
	[Process] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[Description] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_ad_LoS3M]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_ad_LoS3M](
	[RCD] [varchar](20) NULL,
	[CCD] [varchar](8000) NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [NND] [varchar](203) NOT NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [BOD] [varchar](103) NOT NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [COD] [varchar](103) NOT NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [SOD] [varchar](103) NOT NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [Week] [int] NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [ContainerSizeType] [varchar](62) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [SHIPMENT_COMMODITY] [varchar](500) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [SHIPMENT_COMMODITY_CODE] [varchar](50) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [InteractionContainer] [varchar](50) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [InteractionCommodity] [varchar](50) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [InteractionCustomer] [varchar](50) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [ProjectMonths] [varchar](12) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [NumOfContainers] [decimal](38, 2) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [NumOfFFE] [decimal](38, 2) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [AvgPerContainer] [decimal](38, 9) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [AvgPerFFE] [decimal](38, 9) NULL
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [MC] [varchar](50) NULL
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[tmp_ad_LoS3M] ADD [MOD] [varchar](103) NULL

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_los_40_dry]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_los_40_dry](
	[Pricing_EQUIPMENTSIZE] [int] NULL,
	[Pricing_EQUIPMENTTYPE] [varchar](50) NULL,
	[M_REVENUE1ADJUSTED_AMT_USD] [decimal](38, 11) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_LOS_ReSeg_Candidates]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_LOS_ReSeg_Candidates](
	[RCD] [varchar](20) NULL,
	[CONTAINER_TYPE] [varchar](62) NOT NULL,
	[SEGMENT_ID] [int] NULL,
	[Exception_Type] [varchar](5) NOT NULL,
	[Other_Segment_ID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_LOS_ReSeg_step1]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_LOS_ReSeg_step1](
	[RCD] [varchar](20) NULL,
	[CONTAINER_TYPE] [varchar](62) NOT NULL,
	[SEGMENT_ID] [int] NULL,
	[Week] [int] NULL,
	[Total_Containers] [numeric](38, 4) NULL,
	[Bad] [int] NULL,
	[Good] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_LOS_ReSeg_step2]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_LOS_ReSeg_step2](
	[RCD] [varchar](20) NULL,
	[Container_Type] [varchar](62) NOT NULL,
	[Segment_ID] [int] NULL,
	[Good_Weeks] [int] NULL,
	[Bad_Weeks] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Los_Seg_Step1]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Los_Seg_Step1](
	[RCD] [varchar](20) NULL,
	[Container_Type] [varchar](62) NOT NULL,
	[Commodity_ID] [int] NOT NULL,
	[M_NUMBEROFCONTAINER] [numeric](38, 4) NULL,
	[M_BOOKEDREVENUE_AMT_USD] [numeric](38, 4) NULL,
	[Revnue_AMT_PER_Container] [numeric](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Los_Seg_Step2]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Los_Seg_Step2](
	[RCD] [varchar](20) NULL,
	[Container_Type] [varchar](62) NOT NULL,
	[Commodity_ID] [int] NOT NULL,
	[M_NUMBEROFCONTAINER] [numeric](38, 4) NULL,
	[Revnue_Amt_Per_Container] [numeric](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Los_Seg_Step3]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Los_Seg_Step3](
	[RCD] [varchar](20) NULL,
	[Container_Type] [varchar](62) NOT NULL,
	[Commodity_ID] [int] NOT NULL,
	[FFE_Commodity] [numeric](38, 4) NULL,
	[FFE_Total] [numeric](38, 4) NULL,
	[FFE_PCT] [numeric](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Los_Seg_Step4]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Los_Seg_Step4](
	[RCD] [varchar](20) NULL,
	[CONTAINER_TYPE] [varchar](62) NOT NULL,
	[Commodity_ID] [int] NOT NULL,
	[FFE_PCT] [numeric](38, 6) NULL,
	[Segment_Type] [varchar](5) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Los_Seg_Step5]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Los_Seg_Step5](
	[Segment_Name] [varchar](500) NULL,
	[RCD] [varchar](20) NULL,
	[CONTAINER_TYPE] [varchar](62) NOT NULL,
	[Commodity_ID] [int] NOT NULL,
	[FFE_PCT] [numeric](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_Los_Seg_Step6]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Los_Seg_Step6](
	[Segment_Name] [varchar](5) NOT NULL,
	[RCD] [varchar](20) NULL,
	[CONTAINER_TYPE] [varchar](62) NOT NULL,
	[Commodity_ID] [int] NOT NULL,
	[FFE_Pct] [numeric](38, 6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmp_LOS_Segment_Mstr]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_LOS_Segment_Mstr](
	[Segment_ID] [int] NOT NULL,
	[Segment_Name] [varchar](500) NULL,
	[RCD] [varchar](20) NULL,
	[CONTAINER_TYPE] [varchar](62) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tmpConsumptionStep1]    Script Date: 7/21/2017 2:19:00 PM ******/
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
/****** Object:  Table [dbo].[UI_MRM_distribute_v2]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UI_MRM_distribute_v2](
	[RCD] [varchar](50) NULL,
	[CCD] [varchar](255) NULL,
	[projectName] [varchar](50) NULL,
	[baseOrigin] [varchar](50) NULL,
	[baseDestination] [varchar](50) NULL,
	[baseRateID] [varchar](50) NULL,
	[baseEffective] [varchar](50) NULL,
	[baseExpiry] [varchar](50) NULL,
	[baseCommodity] [varchar](50) NULL,
	[baseContainer] [varchar](50) NULL,
	[baseRate] [varchar](50) NULL,
	[baseCurrency] [varchar](50) NULL,
	[bakFFE] [varchar](50) NULL,
	[cyFFE] [varchar](50) NULL,
	[gross_cy_estimate] [varchar](50) NULL,
	[elast_segment] [varchar](50) NULL,
	[elasticitySegment] [varchar](50) NULL,
	[sig_strength_elast] [varchar](50) NULL,
	[elast_segment_lb] [varchar](50) NULL,
	[elast_segment_ub] [varchar](50) NULL,
	[rpi_segment] [varchar](50) NULL,
	[rpiSegment] [varchar](50) NULL,
	[sig_strength_rpi] [varchar](50) NULL,
	[rpi_segment_lb] [varchar](50) NULL,
	[rpi_segment_ub] [varchar](50) NULL,
	[IsChild] [varchar](50) NULL,
	[elastCommodSegment] [varchar](50) NULL,
	[commod_onl] [varchar](50) NULL,
	[last_conv] [varchar](50) NULL,
	[rpi] [varchar](50) NULL,
	[for_base_rate_usd] [varchar](50) NULL,
	[bak_vol] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UI_MRM_v2]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UI_MRM_v2](
	[RCD] [varchar](50) NULL,
	[CCD] [varchar](255) NULL,
	[projectName] [varchar](50) NULL,
	[baseOrigin] [varchar](50) NULL,
	[baseDestination] [varchar](50) NULL,
	[baseRateID] [varchar](50) NULL,
	[baseEffective] [varchar](50) NULL,
	[baseExpiry] [varchar](50) NULL,
	[baseCommodity] [varchar](50) NULL,
	[baseContainer] [varchar](50) NULL,
	[baseCustomer] [varchar](50) NULL,
	[baseRate] [varchar](50) NULL,
	[baseCurrency] [varchar](50) NULL,
	[bakFFE] [varchar](50) NULL,
	[cyFFE] [varchar](50) NULL,
	[gross_cy_estimate] [varchar](50) NULL,
	[elast_segment] [varchar](50) NULL,
	[elasticitySegment] [varchar](50) NULL,
	[sig_strength_elast] [varchar](50) NULL,
	[elast_segment_lb] [varchar](50) NULL,
	[elast_segment_ub] [varchar](50) NULL,
	[rpi_segment] [varchar](50) NULL,
	[rpiSegment] [varchar](50) NULL,
	[sig_strength_rpi] [varchar](50) NULL,
	[rpi_segment_lb] [varchar](50) NULL,
	[rpi_segment_ub] [varchar](50) NULL,
	[IsChild] [varchar](50) NULL,
	[elastCommodSegment] [varchar](50) NULL,
	[commod_onl] [varchar](50) NULL,
	[last_conv] [varchar](50) NULL,
	[rpi] [varchar](50) NULL,
	[for_base_rate_usd] [varchar](50) NULL,
	[bak_vol] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[updatedElasticity]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[updatedElasticity](
	[segment_id] [int] NULL,
	[rcd] [varchar](255) NULL,
	[container_type] [varchar](255) NULL,
	[commod_segment] [nvarchar](255) NULL,
	[ccd] [varchar](255) NULL,
	[rcd_elast_value] [decimal](10, 5) NULL,
	[rcd_elast_se] [decimal](10, 5) NULL,
	[rcd_elast_pvalue] [decimal](10, 5) NULL,
	[rcd_adj_r2] [decimal](6, 4) NULL,
	[rcd_nob] [int] NULL,
	[rcd_df] [int] NULL,
	[ccd_elast_value] [decimal](10, 5) NULL,
	[ccd_elast_se] [decimal](10, 5) NULL,
	[ccd_elast_pvalue] [decimal](10, 5) NULL,
	[ccd_adj_r2] [decimal](10, 5) NULL,
	[ccd_nob] [int] NULL,
	[ccd_df] [int] NULL,
	[ccd_interaction_term] [int] NULL,
	[ccd_elast_int_pvalue] [nvarchar](255) NULL,
	[elast_value] [decimal](10, 5) NULL,
	[elast_se] [decimal](10, 5) NULL,
	[elast_pvalue] [decimal](10, 5) NULL,
	[adj_r2] [decimal](6, 4) NULL,
	[nob] [int] NULL,
	[df] [int] NULL,
	[bnd_elast_value] [float] NULL,
	[bnd_elast_value_lb] [decimal](10, 5) NULL,
	[bnd_elast_value_ub] [decimal](10, 5) NULL,
	[elast_value_lb] [decimal](10, 5) NULL,
	[elast_value_ub] [decimal](10, 5) NULL,
	[tot_rev] [decimal](12, 3) NULL,
	[time_exe] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[XenetaPilotCorridor]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XenetaPilotCorridor](
	[ExportDateAndTime] [varchar](50) NULL,
	[Date] [varchar](50) NULL,
	[OriginName] [varchar](50) NULL,
	[OriginCode] [varchar](50) NULL,
	[DestinationName] [varchar](50) NULL,
	[DestinationCode] [varchar](50) NULL,
	[Equipment] [varchar](50) NULL,
	[MarketLow] [varchar](50) NULL,
	[MarketAverage] [varchar](50) NULL,
	[Validity] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[XenetaPilotRegion]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[XenetaPilotRegion](
	[DownloadDate] [varchar](50) NULL,
	[Date] [varchar](50) NULL,
	[OriginName] [varchar](50) NULL,
	[DestinationName] [varchar](50) NULL,
	[Equipment] [varchar](50) NULL,
	[MarketLow] [varchar](50) NULL,
	[MarketAverage] [varchar](50) NULL,
	[Validity] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_AD_SCHEDULE_ALL]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_AD_SCHEDULE_ALL] AS
Select 
	Service,
	Vessel,
	Depvoyage,
	site_code,
	Dep_Stat,
	convert(datetime,convert(date,schdeparturetimestamp)) as original_etd,
	convert(datetime,convert(date,actdeparturetimestamp)) as actual_etd
from 
(
select   
	x.service, x.vessel, x.depvoyage, x.site_code,Dep_Stat,
	max(x.SchDepartureDate) as schdeparturetimestamp,
	max(x.ActDepartureDate) as actdeparturetimestamp
from schedule x	
--where x.Dep_Stat = 'ACT'
group by 
	x.service, x.vessel, x.depvoyage, x.site_code,Dep_Stat
) A
GO
/****** Object:  View [dbo].[vw_capfcst_agg_freeSale_Uboat]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_capfcst_agg_freeSale_Uboat] as select * from  [CapInvRepository].[dbo].[agg_freeSale_Uboat84K]

GO
/****** Object:  View [dbo].[vw_capfcst_agg_freeSale_Uboat_OE]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_capfcst_agg_freeSale_Uboat_OE] as 
select id,RunId, VesselCode as Vessel,voyage, ServiceCode as Service
		, ServiceCodeDirection
		, departurePort as  [Departure PortCall]
		, arrivalport as [Arrival PortCall]
		, LegSeqId
		, cast(departuredate as date) as Departure
		, cast(Arrivaldate as date) as Arrival
		, remaining_freesaleFFE as [Remaining capacity FFE]
		, remaining_freesaleTeU as [Remaining capacity TEU]
		, remaining_freesaleTons as [Remaining capacity MTS]
		, remaining_freesalePlugs as [Remaining capacity Plugs]
		, cast('Lead' as varchar) as ISC
from  capinvrepository.dbo.agg_freeSale_Uboat84K;

GO
/****** Object:  View [dbo].[vw_capfcst_agg_freeSale_Uboat_USER]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vw_capfcst_agg_freeSale_Uboat_USER] as 
select	id
		, runid
		, rundate
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
		, cast('Lead' as varchar) as [ISC indicator (Lead trade / ISC1)]
from  capinvrepository.dbo.agg_freeSale_Uboat84K;


GO
/****** Object:  View [dbo].[vw_udf_mvp1_fcst_final]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_udf_mvp1_fcst_final] as select * from [UDFRepository].[dbo].[udf_mvp1_fcst_final]


GO
/****** Object:  View [dbo].[vw_udf_mvp1_runs_final]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_udf_mvp1_runs_final] as select * from [UDFRepository].[dbo].[udf_mvp1_runs_final]


GO
/****** Object:  View [dbo].[vw_udf_mvp3_fcst_final]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[vw_udf_mvp3_fcst_final] as select * from [UDFRepository].[dbo].[udf_mvp3_fcst_final]



GO
/****** Object:  View [dbo].[vw_udf_mvp3_runs_final]    Script Date: 7/21/2017 2:19:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[vw_udf_mvp3_runs_final] as select * from [UDFRepository].[dbo].[udf_mvp3_runs_final]



GO
ALTER TABLE [dbo].[RevenueOptimizationOperatorDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_RevenueOptimization] FOREIGN KEY([ID])
REFERENCES [dbo].[RevenueOptimizationLegs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RevenueOptimizationOperatorDetails] NOCHECK CONSTRAINT [FK_RevenueOptimization]
GO

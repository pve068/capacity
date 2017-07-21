
/****** Object:  View [dbo].[vw_ad_capinv_FreeSale_UBoat_ports]    Script Date: 7/21/2017 2:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_ad_capinv_FreeSale_UBoat_ports]
as
with lastdate as 
(
	select service,Site_Code, max(cast(ActDepartureDate as date)) as etd
	from [dbo].Schedule
	group by service,Site_Code
), rnk as
(
	select service,Site_Code, DENSE_RANK() over (partition by service order by etd) as rnk
	from lastdate a
)
select distinct a.*, b.Site_Code, b.rnk
from [dbo].[ad_capinv_FreeSale_UBoat] a
inner join rnk b
on a.servicecode = b.service

GO
ALTER TABLE [dbo].[ML_PROCESS_LOG_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK_ML_PROCESS_LOG_PROCESS_ID] FOREIGN KEY([PROCESS_ID])
REFERENCES [dbo].[ML_PROCESS_LOG] ([PROCESS_ID])
GO
ALTER TABLE [dbo].[ML_PROCESS_LOG_DETAIL] CHECK CONSTRAINT [FK_ML_PROCESS_LOG_PROCESS_ID]
GO
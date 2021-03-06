IF ( OBJECT_ID('DBO.USP_CAPINV_RUNDAILY_REPORT', 'P') IS NOT NULL ) 
   DROP PROCEDURE DBO.USP_CAPINV_RUNDAILY_REPORT
GO


CREATE PROCEDURE [dbo].USP_CAPINV_RUNDAILY_REPORT
/****************************************************************************************************
* COPYRIGHT REVENUE ANALYTICS 2017
* ALL RIGHTS RESERVED
*
* CREATED BY: DATA ENGINEERING
* FILENAME:   USP_CAPFCST_CALC_FREESALECONSUMPTION.SQL
* DATE:       11/09/2017
*
* APPLICATION:  Generate Daily Report after forecast runs
*               
* PARAMETERS:   @V_RUNDATE = DATE OF THE RUN
*  				
* ASSUMPTIONS: Forecast Run colpleted
* 
* OUTPUTS:		Report
*				
* EXAMPLE CALL: DECLARE	@RETURN_VALUE INT,
*						@V_ERROR_CODE INT
*
*EXEC	@RETURN_VALUE = CAPINVREPOSITORY.[DBO].[USP_CAPINV_RUNDAILY_REPORT] @V_ERROR_CODE OUTPUT
*****************************************************************************************************
* NOTES:
*  NAME					CREATED        LAST MOD			COMMENTS
*  DE\ELM               11/09/2017						PROCEDURE CREATED
****************************************************************************************************/
@V_ERROR_CODE INT OUTPUT
as
BEGIN
    DECLARE @V_Results NVARCHAR(MAX)
    DECLARE @v_xml NVARCHAR(MAX)
	declare @V_SUBJECT VARCHAR(255)
	declare @V_RUNDATE datetime = getutcdate()

    DECLARE @Support_Email VARCHAR(700) = (
        select PARAMVALUE
        from ANALYTICSDATAMART.[DBO].[CAPINVUDF_APP_PARAMETER] where ParamName='SUPPORT_EMAIL'
		and processname = 'CAPINV'
    )
	DECLARE @V_ERRORMESSAGE NVARCHAR(4000)  
	DECLARE @V_MSG  NVARCHAR(4000)
	DECLARE @V_NOTE  NVARCHAR(4000)
	DECLARE @V_ERRORSEVERITY INT  

	DECLARE @V_SYSTEM_USER NVARCHAR(255) = SYSTEM_USER

	set @V_RUNDATE = getutcdate()
	set @V_SUBJECT = 'Capacity Forecast Run completed for: '+cast(@V_RUNDATE as varchar)+' by user: '+ @V_SYSTEM_USER;

	begin try;
		--Get Commit fillings -- same as from calculation of remaining FS
		;WITH T1 AS 
			(
						SELECT L.RUNID
							,L.VESSEL	
							,L.VOYAGE	
							,L.SERVICECODE	
							,ISNULL(LD.ISC, 'LEAD') AS ISC
							,L.DEPARTUREPORT
							,L.ARRIVALPORT
							,L.DEPARTUREDATE
							,SUM(COMMITMENTALLOCATIONTEU) AS COMMITMENTALLOCATIONTEU
							,SUM(COMMITMENTALLOCATIONMTS) AS COMMITMENTALLOCATIONMTS
							,SUM(COMMITMENTALLOCATIONPLUGS) AS COMMITMENTALLOCATIONPLUGS
						FROM ANALYTICSDATAMART.DBO.COMMITMENTFILINGS L
						LEFT JOIN ( 
									SELECT DISTINCT SERVICECODE,SERVICECODEDIRECTION,LEAD_ROUTE AS ROUTE_CD,ISC
									FROM ANALYTICSDATAMART.DBO.DIM_LEAD_ROUTE
									UNION 
									SELECT DISTINCT SERVICECODE,SERVICECODEDIRECTION,CHILD_ROUTE, ISC
									FROM ANALYTICSDATAMART.DBO.DIM_LEAD_ROUTE
									)LD
						ON L.SERVICECODE = LD.SERVICECODE
						AND L.SERVICECODEDIRECTION = LD.SERVICECODEDIRECTION
						AND L.ROUTECODE = LD.ROUTE_CD
						WHERE RUNID = (SELECT MAX(RUNID) FROM ANALYTICSDATAMART.DBO.COMMITMENTFILINGS)
						GROUP BY L.RUNID
							,L.VESSEL	
							,L.VOYAGE	
							,L.SERVICECODE	
							,ISNULL(LD.ISC, 'LEAD')
							,L.DEPARTUREPORT
							,L.ARRIVALPORT
							,L.DEPARTUREDATE
		)
			SELECT N.RUNID
					,N.VESSEL	
					,N.VOYAGE	
					,N.SERVICECODE	
					,N.ISC
					,N.DEPARTUREPORT
					,N.ARRIVALPORT
					,N.DEPARTUREDATE
					,N.COMMITMENTALLOCATIONTEU
					,N.COMMITMENTALLOCATIONMTS
					,N.COMMITMENTALLOCATIONPLUGS
		INTO #AGGCOMMITFILINGS
		FROM T1 N
		INNER JOIN 
		(
			SELECT VESSEL,VOYAGE,SERVICECODE,DEPARTUREPORT,ARRIVALPORT,ISC,MAX(DEPARTUREDATE) AS  DEPARTUREDATE
			FROM T1
			GROUP BY VESSEL,VOYAGE,SERVICECODE,DEPARTUREPORT,ARRIVALPORT,ISC
		)G
		ON N.VESSEL = G.VESSEL
		AND N.VOYAGE = G.VOYAGE
		AND N.SERVICECODE = G.SERVICECODE
		AND N.DEPARTUREPORT = G.DEPARTUREPORT
		AND N.ARRIVALPORT = G.ARRIVALPORT
		AND N.ISC = G.ISC
		AND N.DEPARTUREDATE = G.DEPARTUREDATE;
		--Match Coms allocation leg to route leg schedule
		select cast((sum(case when b.arrivalport is null then 1 else 0 end)*1.00)/ count(1)  as numeric(5,4)) as COMSROUTELEGPCT
		into #COMS_ROUTELEG_MATCH
		from AnalyticsDatamart..ad_ml_allocations a
		left join AnalyticsDatamart..routelegs_schedule b
		on a.vesselcode = b.vesselcode
		and a.voyage = b.voyage
		and a.servicecode = b.servicecode
		and a.departureport = b.departureport
		and a.arrivalport = b.arrivalport

		--Match route legs schedule to coms
		select cast((sum(case when b.arrivalport is null then 1 else 0 end)*1.00)/ count(1)  as numeric(5,4)) as ROUTELEGCOMSPCT
		into #ROUTELEG_COMS_MATCH
		from AnalyticsDatamart..routelegs_schedule a
		left join AnalyticsDatamart..ad_ml_allocations b
		on a.vesselcode = b.vesselcode
		and a.voyage = b.voyage
		and a.servicecode = b.servicecode
		and a.departureport = b.departureport
		and a.arrivalport = b.arrivalport
		where cast(a.original_etd as date) >= (select min(cast(departuredate as date)) from AnalyticsDatamart..ad_ml_allocations)

		--Match Booking final to Route links
		SELECT (COUNT(DISTINCT CASE WHEN  R.SHIPMENT_VRSN_ID_X IS NULL THEN L.SHIPMENT_NO_X ELSE NULL END)*1.00) / COUNT(DISTINCT L.SHIPMENT_NO_X) AS BKGFINALROUTELINKSMATCHPCT
		into #BOOKINGFINAL_ROUTELINKS
		FROM ANALYTICSDATAMART.[DBO].[BOOKING_FINAL] L (NOLOCK) 
		LEFT JOIN ANALYTICSDATAMART.DBO.ROUTELINKS R (NOLOCK)
		ON 	L.SHIPMENT_NO_X = R.SHIPMENT_NO_X
			AND L.SHIPMENT_VRSN_ID_X = R.SHIPMENT_VRSN_ID_X
		WHERE 	
			UPPER(L.IS_VSA_F) IN ('N')
			AND UPPER(L.SHIPMENT_STATUS) IN ('ACTIVE');

		--Calculate percent of missing segment from and to ports
		SELECT (sum(CASE WHEN  SC.SITE_CODE IS NULL THEN 1 ELSE 0 END)*1.00) / COUNT(1) AS FROMSITEPCT
				,(sum(CASE WHEN  LP.SITE_CODE IS NULL THEN 1 ELSE 0 END)*1.00) / COUNT(1) AS TOSITEPCT
				,(sum(CASE WHEN  SC.SITE_CODE IS NULL AND LP.SITE_CODE IS NULL THEN 1 ELSE NULL END)*1.00) / COUNT(1) AS FROMSITE_TOSITEPCT
		into #ROUTELINKSSCHEDULE
		FROM ANALYTICSDATAMART.[DBO].[BOOKING_FINAL] L (NOLOCK) 
		INNER JOIN ANALYTICSDATAMART.DBO.ROUTELINKS R (NOLOCK)
		ON 	L.SHIPMENT_NO_X = R.SHIPMENT_NO_X
			AND L.SHIPMENT_VRSN_ID_X = R.SHIPMENT_VRSN_ID_X
		LEFT JOIN (SELECT * FROM ANALYTICSDATAMART.DBO.SCHEDULE WHERE DEP_STAT NOT LIKE '%OMIT%') SC 
			ON R.VESSELCODE = SC.VESSELCODE
				AND R.DEPVOYAGEX = SC.DEPVOYAGE
					AND R.SERVICECODE = SC.DEPSERVICECODE
					AND LEFT(R.FROMSITECODE,5) = LEFT(SC.SITE_CODE,5)
		LEFT JOIN (SELECT * FROM ANALYTICSDATAMART.DBO.SCHEDULE WHERE DEP_STAT NOT LIKE '%OMIT%') LP 
			ON R.VESSELCODE = LP.VESSELCODE
					AND R.SERVICECODE = LP.DEPSERVICECODE
					AND LEFT(R.TOSITECODE,5) = LEFT(LP.SITE_CODE,5)
		WHERE UPPER(L.IS_VSA_F) IN ('N') AND UPPER(L.SHIPMENT_STATUS) IN ('ACTIVE');

		/*******************************************************
					Calculate Statistics
		*******************************************************/
		;WITH COMMITMENTISC AS 
		(
			SELECT (SUM(CASE WHEN ISC = 'LEAD' THEN 1 ELSE 0 END)*1.0)/ COUNT(1) AS COMMITLEADPCT
					,(SUM(CASE WHEN ISC <> 'LEAD' THEN 1 ELSE 0 END)*1.0)/ COUNT(1) AS COMMITISCPCT
			FROM #AGGCOMMITFILINGS
		),ISC AS
		(
			SELECT (SUM(CASE WHEN ISC = 'LEAD' THEN 1 ELSE 0 END)*1.0)/ COUNT(1) AS UBOATLEADPCT
					,(SUM(CASE WHEN ISC <> 'LEAD' THEN 1 ELSE 0 END)*1.0)/ COUNT(1) AS UBOATISCPCT
			FROM ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT
			WHERE RUNID = (	SELECT PUBLISHEDRUNID FROM ANALYTICSDATAMART.DBO.[PROCESSPUBLISH]  WHERE PROCESSMASTERID = 1)
		)
		,FREESALECONSUMPTION AS
		(
			SELECT (SUM(CASE WHEN FREESALECONSUMPTIONTEU > 0 THEN 1 ELSE 0 END)*1.0)/ COUNT(1) AS FREESALECONSUMPTIONPCT
					,(SUM(CASE WHEN TOTALCOMMITCONSUMPTIONTEU >0 THEN 1 ELSE 0 END)*1.0)/ COUNT(1) AS COMMITCONSUMPTIONPCTPCT
					,(SUM(CASE WHEN TOTALCOMMITFILINGSTEU >0 THEN 1 ELSE 0 END)*1.0)/ COUNT(1) AS COMMITALLOCATIONPCTPCT
					,(SUM(CASE WHEN TOTALEMPTYTEU >0 THEN 1 ELSE 0 END)*1.0)/ SUM(CASE WHEN ISC = 'LEAD' THEN 1 ELSE 0 END) AS ROCKPCT
			FROM ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT
			WHERE RUNID = (	SELECT PUBLISHEDRUNID FROM ANALYTICSDATAMART.DBO.[PROCESSPUBLISH]  WHERE PROCESSMASTERID = 1)

		),
		CONSUMPTIONNOALLOCATION AS
		(
				SELECT (SUM(CASE WHEN CON.ISC IS NULL THEN 1 ELSE 0 END))*1.00 / COUNT(1) AS CONSUMPTIONNOALLOCATIONPCT
				FROM 
				(
					SELECT DISTINCT VESSEL,VOYAGE,SERVICECODE,DEPARTUREPORT,ARRIVALPORT,ISC
					FROM CAPINVREPOSITORY.DBO.TMP_AGG_CAPFCST_FREESALECONSUMPTION
					WHERE DEPARTUREDATE>= (SELECT MIN(DEPARTUREDATE) FROM CAPINVREPOSITORY.DBO.TMP_FINAL_ALLOCATION_OVERBOOK)
				) A
				LEFT JOIN 
				(
					SELECT DISTINCT VESSELCODE,VOYAGE,SERVICECODE,DEPARTUREPORT,ARRIVALPORT,ISC
					FROM CAPINVREPOSITORY.DBO.TMP_FINAL_ALLOCATION_OVERBOOK
				) CON
				ON A.VESSEL = CON.VESSELCODE
				AND A.VOYAGE = CON.VOYAGE
				AND A.SERVICECODE = CON.SERVICECODE
				AND A.DEPARTUREPORT = CON.DEPARTUREPORT
				AND A.ARRIVALPORT = CON.ARRIVALPORT
				AND A.ISC = CON.ISC
		)	,SCHEDULE_COMS AS
		(
				SELECT CAST((B.CNT - A.CNT)AS DECIMAL(12,4))/CAST(B.CNT AS DECIMAL(12,4))  AS COMSSCHEDULEMATCHPCT
				FROM 
				(
					SELECT COUNT(*) CNT
					FROM ANALYTICSDATAMART.DBO.COMS_ALLOCATIONS L 
					LEFT OUTER JOIN (SELECT * FROM ANALYTICSDATAMART.DBO.SCHEDULE WHERE DEP_STAT NOT LIKE '%OMIT%') R 
					ON L.VESSELCODE = R.VESSELCODE
						AND L.VOYAGE = R.DEPVOYAGE
							AND L.SERVICECODE = R.DEPSERVICECODE
							AND L.SITECODE = R.SITE_CODE
					WHERE 
					R.VESSELCODE IS NULL
				) A,
				(
					SELECT COUNT(*) CNT
					FROM ANALYTICSDATAMART.DBO.COMS_ALLOCATIONS L 
					LEFT OUTER JOIN (SELECT * FROM ANALYTICSDATAMART.DBO.SCHEDULE WHERE DEP_STAT NOT LIKE 'OMIT') R 
					ON L.VESSELCODE = R.VESSELCODE
					AND L.VOYAGE = R.DEPVOYAGE
						AND L.SERVICECODE = R.DEPSERVICECODE
							AND L.SITECODE = R.SITE_CODE
				) B		
		),
		OVERBOOK AS
		(
			SELECT	MIN(OVERBOOKPCT) MINOVERBOOKPCT, MAX(OVERBOOKPCT) MAXOVERBOOKPCT
					, COUNT(DISTINCT  VOYAGE+VESSELCODE+SERVICECODE+DEPARTUREPORT+ARRIVALPORT) AS NUMLEGS
					, MIN(DEPARTUREDATE) AS MINDEPARTUREDATE, MAX(DEPARTUREDATE) AS MAXDEPARTUREDATE
					,(SUM(CASE WHEN OVERBOOKPCT = 0 THEN 1 ELSE 0 END)*1.00)/COUNT(1) AS UBOATOVERBOOKINGPCT
					,(SUM(CASE WHEN OVERBOOKPCT < 0 THEN 1 ELSE 0 END)*1.00)/COUNT(1) AS NEGUBOATOVERBOOKINGPCT

					,(SUM(CASE WHEN TOTALCOMMITCONSUMPTIONTEU = 0 THEN 1 ELSE 0 END)*1.00)/COUNT(1) AS UBOATCOMMITCONSUMPTIONPCT
					,(SUM(CASE WHEN TOTALCOMMITFILINGSTEU = 0 THEN 1 ELSE 0 END)*1.00)/COUNT(1) AS UBOATCOMMITFILLINGSPCT
					,(SUM(CASE WHEN ALLOCATIONTEU = 0 THEN 1 ELSE 0 END)*1.00)/COUNT(1) AS UBOATALLOCATIONPCT
			FROM ANALYTICSDATAMART.DBO.AD_CAPFCST_FREESALE_UBOAT WHERE RUNID 
				= (SELECT PUBLISHEDRUNID FROM ANALYTICSDATAMART.DBO.[PROCESSPUBLISH] WHERE PROCESSMASTERID = 1)
		)
		SELECT	cast(COMMITLEADPCT as numeric(5,4)) as COMMITLEADPCT
				,cast(COMMITISCPCT as numeric(5,4)) as COMMITISCPCT
				,cast(UBOATLEADPCT as numeric(5,4)) as UBOATLEADPCT
				,cast(UBOATISCPCT as numeric(5,4)) as UBOATISCPCT
				,cast(FREESALECONSUMPTIONPCT as numeric(5,4)) as FREESALECONSUMPTIONPCT
				,cast(COMMITCONSUMPTIONPCTPCT as numeric(5,4)) as COMMITCONSUMPTIONPCTPCT
				,cast(COMMITALLOCATIONPCTPCT as numeric(5,4)) as COMMITALLOCATIONPCTPCT
				,cast(CONSUMPTIONNOALLOCATIONPCT as numeric(5,4)) as CONSUMPTIONNOALLOCATIONPCT
				,cast(COMSSCHEDULEMATCHPCT as numeric(5,4)) as COMSSCHEDULEMATCHPCT
				,cast(BKGFINALROUTELINKSMATCHPCT as numeric(5,4)) as BKGFINALROUTELINKSMATCHPCT
				,cast(FROMSITEPCT as numeric(5,4)) as FROMSITEPCT
				,cast(TOSITEPCT as numeric(5,4)) as TOSITEPCT
				,cast(FROMSITE_TOSITEPCT as numeric(5,4)) as FROMSITE_TOSITEPCT
				,cast(MINOVERBOOKPCT as numeric(5,4)) as MINOVERBOOKPCT
				,cast(MAXOVERBOOKPCT as numeric(5,4)) as MAXOVERBOOKPCT
				,NUMLEGS
				,MINDEPARTUREDATE
				,MAXDEPARTUREDATE
				,cast(UBOATOVERBOOKINGPCT as numeric(5,4)) as UBOATOVERBOOKINGPCT
				,cast(NEGUBOATOVERBOOKINGPCT as numeric(5,4)) as NEGUBOATOVERBOOKINGPCT
				,cast(UBOATCOMMITCONSUMPTIONPCT as numeric(5,4)) as UBOATCOMMITCONSUMPTIONPCT
				,cast(UBOATCOMMITFILLINGSPCT as numeric(5,4)) as UBOATCOMMITFILLINGSPCT
				,cast(UBOATALLOCATIONPCT as numeric(5,4)) as UBOATALLOCATIONPCT
		INTO #CALNUMBERS
		FROM COMMITMENTISC a, ISC b, FREESALECONSUMPTION c
		,CONSUMPTIONNOALLOCATION d
		,SCHEDULE_COMS e
		,#ROUTELINKSSCHEDULE f
		,OVERBOOK g
		, #BOOKINGFINAL_ROUTELINKS h;

		/*********************************************************
							Statistics
		*********************************************************/
		SET @v_xml = CAST((
		 SELECT			  rowNum AS 'td', '',
						  [Check Name] AS 'td', '',
						  [Check Result]  AS 'td'
		from 
		(
			select cast(1 as int) as rowNum
				,cast('UBoat output: Percent of 0 Allocation: ' as varchar(255)) as [Check Name]
				,cast((select cast(UBOATALLOCATIONPCT * 100 as float) from #CALNUMBERS) as VARCHAR(10))+'%' AS [Check Result]
			union
			select cast(2 as int) as rowNum,'UBoat output: Percent of 0 Commitment Fillings: ', cast((select cast(UBOATCOMMITFILLINGSPCT * 100 as float) from #CALNUMBERS) as VARCHAR(10))+'%'
			union
			select cast(3 as int) as rowNum,'UBoat output: Percent of 0 Commitment Consumption: ', cast((select cast(uboatCommitConsumptionPct * 100 as float) from #CALNUMBERS) as VARCHAR(10))+'%'
			union
			select cast(4 as int) as rowNum,'UBoat output: Number of Legs processed: ',cast((select numLegs from #CALNUMBERS) as VARCHAR)
			union
			select cast(5 as int) as rowNum,'UBoat output: Minimum Departure Date: ',cast((select MINDEPARTUREDATE from #CALNUMBERS) as VARCHAR)
			union
			select cast(6 as int) as rowNum,'UBoat output: Maximum Departure Date: ',cast((select MAXDEPARTUREDATE from #CALNUMBERS) as VARCHAR)
			union
			select cast(7 as int) as rowNum,'UBoat output: Percent of 0 Overbooking percent: ', cast((select cast(uboatOverbookingPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union
			select cast(8 as int) as rowNum,'UBoat output: Percent of Negative Overbooking percent: ', cast((select cast(neguboatOverbookingPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union
			select cast(9 as int) as rowNum,'UBoat output: Minimum overbooking percent is: ',cast((select cast(MINOVERBOOKPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union
			select cast(10 as int) as rowNum,'UBoat output: Maximum overbooking percent is: ',cast((select cast(MAXOVERBOOKPCT  * 100 as float) from #CALNUMBERS)  as varchar(10))+'%'
			union
			select cast(11 as int) as rowNum,'Match rate between COMS SITECODE and GSIS Schedule SITECODE at VESSEL/VOYAGE/SERVICE Level ',cast((select cast(COMSSCHEDULEMATCHPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union 
			select cast(12 as int) as rowNum,'Match rate between COMS LEGS and GSIS Schedule LEGS at the VESSEL/VOYAGE/SERVICE Level ',cast((select cast((1 - COMSROUTELEGPCT) * 100 as float) from #COMS_ROUTELEG_MATCH) as varchar(10))+'%'
			union 
			select cast(13 as int) as rowNum,'Match rate between GSIS Schedule LEGS and COMS LEGS at the VESSEL/VOYAGE/SERVICE Level ',cast((select cast((1 - ROUTELEGCOMSPCT) * 100 as float) from #ROUTELEG_COMS_MATCH) as varchar(10))+'%'
			union
			select cast(14 as int) as rowNum,'Percent of Consumption not matching allocation legs',cast((select cast(consumptionNoAllocationPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union 
			select cast(15 as int) as rowNum,'Percent of Commitment Filings that are LEAD',cast((select cast(COMMITleadPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union 
			select cast(16 as int) as rowNum,'Percent of Commitment Filings that are Steered ISCs',cast((select cast(COMMITISCPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union 
			select cast(17 as int) as rowNum,'Percent of UBoat output that are LEAD',cast((select cast(UBOATleadPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union 
			select cast(18 as int) as rowNum,'Percent of UBoat output that are Steered ISCs',cast((select cast(UBOATISCPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union
			Select cast(19 as int) as rowNum,'Percent of Shipments in BOOKING_FINAL with no ROUTELINKS Data', cast((select cast(BKGFINALROUTELINKSMATCHPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union
			Select cast(20 as int) as rowNum,'Percent of Shipments from ROUTELINKS where FromSiteCode does not match GSIS Schedules ', cast((select cast(FromSitePct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union
			Select cast(21 as int) as rowNum,'Percent of Shipments from ROUTELINKS where ToSiteCode does not match GSIS Schedules ', cast((select cast(ToSitePct  * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			union
			Select cast(22 as int) as rowNum,'Percent of Shipments from ROUTELINKS where both FromSiteCode and ToSiteCode does not match GSIS Schedules ', cast((select cast(FROMSITE_TOSITEPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
		)gg
		order by rowNum
				FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)
		)

		 SET @V_Results =  '<br /><br />' +

					 '<div style="color:#0000FF">'+
					  '<h3>'+@V_SUBJECT+'</h3>'+
					  '<p>All,</p>'+
					  '<p>Please see below statistics on this run.</p>'+
					  '<p>Thanks,</p>'+
					  '<p>Capacity Forecast Team.</p>'+
					'</div>'+
					'<table cellpadding=1, cellspacing=0 border=1 width=100%>' +
						  '<tr>' +
								'<th colspan=7 style="border:none; text-align:left">Table of Statistics</th>' +
						  '</tr>' +
						  '<tr>' +
								'<th>ID</th>' +
								'<th>Statistical Test</th>' +
								'<th>Result</th>' +
						  '</tr>' +
						  @v_xml +
					'</table>'

		/***************************************************
				Get Ingestion Prcocesses
		***************************************************/
		SET @v_xml = CAST(( 
				select	a.PROCESS_ID AS 'td', '',	
						a.PROCESS_NAME AS 'td', '',	
						a.USER_NAME AS 'td', '',	
						a.START_DT AS 'td', '',	
						a.END_DT AS 'td', '',	
						a.STATUS AS 'td', '',	
						a.NOTE AS 'td'
				from analyticsdatamart.dbo.ml_process_log a
				inner join 
				(
					select process_name, max(process_id) as process_id
					from analyticsdatamart.dbo.ml_process_log
					where user_name <> 'RAAppUser'
					and upper(process_name) not like '%_UDF_%'
					and upper(process_name) not in (select process_name from  analyticsdatamart.dbo.capinv_exclude_process_from_report)
					group by process_name
				)g
				on a.process_name = g.process_name
				and a.process_id = g.process_id
				order by a.process_id
				FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)
		)

		 SET @V_Results = @V_Results+'<br /><br />' +
					'<table cellpadding=1, cellspacing=0 border=1 width=100%>' +
						  '<tr>' +
								'<th colspan=7 style="border:none; text-align:left">Ingestion Run Processes</th>' +
						  '</tr>' +
						  '<tr>' +
								'<th>PROCESS ID</th>' +
								'<th>PROCESS NAME</th>' +
								'<th>USER NAME</th>' +
								'<th>START DATE</th>' +
								'<th>END DATE</th>' +
								'<th>STATUS</th>' +
								'<th>NOTE</th>' +
						  '</tr>' +
						  @v_xml +
					'</table>'

		/***************************************************
				Get Forecast Process
		***************************************************/
		SET @v_xml = CAST(( 
				select	a.PROCESS_ID AS 'td', '',	
						a.PROCESS_NAME AS 'td', '',	
						a.USER_NAME AS 'td', '',	
						dt.step_id AS 'td', '',	
						dt.step_name AS 'td', '',	
						dt.start_dt AS 'td', '',	
						dt.end_dt AS 'td', '',	
						dt.status AS 'td', '',	
						dt.rows_processed AS 'td', '',	
						dt.note AS 'td', ''	
				from capinvrepository.dbo.ml_process_log a
				inner join 
				(
					select process_name, max(process_id) as process_id
					from capinvrepository.dbo.ml_process_log
					where user_name <> 'RAAppUser'
					and UPPER(PROCESS_NAME) <> 'DBO.USP_CAPFCST_RUN_FCST'
					group by process_name
				)g
				on a.process_id = g.process_id
				inner join capinvrepository.dbo.ml_process_log_detail dt
				on a.process_id = dt.process_id
				order by a.process_id, dt.step_id
				FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX)
		)

		 SET @V_Results =  @V_Results+'<br /><br />' +
					'<table cellpadding=1, cellspacing=0 border=1 width=100%>' +
						  '<tr>' +
								'<th colspan=7 style="border:none; text-align:left">Forecast Run Processes</th>' +
						  '</tr>' +
						  '<tr>' +
								'<th>PROCESS ID</th>' +
								'<th>PROCESS NAME</th>' +
								'<th>USER NAME</th>' +
								'<th>STEP ID</th>' +
								'<th>STEP NAME</th>' +
								'<th>START DATE</th>' +
								'<th>END DATE</th>' +
								'<th>STATUS</th>' +
								'<th>ROWS PROCESSED</th>' +
								'<th>NOTE</th>' +
						  '</tr>' +
						  @v_xml +
					'</table>'

			--Insert Mail data
			insert into CAPINVREPOSITORY.DBO.CAPINV_MAIL_LOG(rundate,rowNUm,[check Name], [check result])
			select cast(getutcdate() as datetime) as rundate,rowNUm,[check Name], [check result]
			from 
			(
				select cast(1 as int) as rowNum
					,cast('UBoat output: Percent of 0 Allocation: ' as varchar(255)) as [Check Name]
					,cast((select cast(UBOATALLOCATIONPCT * 100 as float) from #CALNUMBERS) as VARCHAR(10))+'%' AS [Check Result]
				union
				select cast(2 as int) as rowNum,'UBoat output: Percent of 0 Commitment Fillings: ', cast((select cast(UBOATCOMMITFILLINGSPCT * 100 as float) from #CALNUMBERS) as VARCHAR(10))+'%'
				union
				select cast(3 as int) as rowNum,'UBoat output: Percent of 0 Commitment Consumption: ', cast((select cast(uboatCommitConsumptionPct * 100 as float) from #CALNUMBERS) as VARCHAR(10))+'%'
				union
				select cast(4 as int) as rowNum,'UBoat output: Number of Legs processed: ',cast((select numLegs from #CALNUMBERS) as VARCHAR)
				union
				select cast(5 as int) as rowNum,'UBoat output: Minimum Departure Date: ',cast((select MINDEPARTUREDATE from #CALNUMBERS) as VARCHAR)
				union
				select cast(6 as int) as rowNum,'UBoat output: Maximum Departure Date: ',cast((select MAXDEPARTUREDATE from #CALNUMBERS) as VARCHAR)
				union
				select cast(7 as int) as rowNum,'UBoat output: Percent of 0 Overbooking percent: ', cast((select cast(uboatOverbookingPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union
				select cast(8 as int) as rowNum,'UBoat output: Percent of Negative Overbooking percent: ', cast((select cast(neguboatOverbookingPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union
				select cast(9 as int) as rowNum,'UBoat output: Minimum overbooking percent is: ',cast((select cast(MINOVERBOOKPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union
				select cast(10 as int) as rowNum,'UBoat output: Maximum overbooking percent is: ',cast((select cast(MAXOVERBOOKPCT  * 100 as float) from #CALNUMBERS)  as varchar(10))+'%'
				union
				select cast(11 as int) as rowNum,'Match rate between COMS SITECODE and GSIS Schedule SITECODE at VESSEL/VOYAGE/SERVICE Level ',cast((select cast(COMSSCHEDULEMATCHPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union 
				select cast(12 as int) as rowNum,'Match rate between COMS LEGS and GSIS Schedule LEGS at the VESSEL/VOYAGE/SERVICE Level ',cast((select cast((1 - COMSROUTELEGPCT) * 100 as float) from #COMS_ROUTELEG_MATCH) as varchar(10))+'%'
				union 
				select cast(13 as int) as rowNum,'Match rate between GSIS Schedule LEGS and COMS LEGS at the VESSEL/VOYAGE/SERVICE Level ',cast((select cast((1 - ROUTELEGCOMSPCT) * 100 as float) from #ROUTELEG_COMS_MATCH) as varchar(10))+'%'
				union
				select cast(14 as int) as rowNum,'Percent of Consumption not matching allocation legs',cast((select cast(consumptionNoAllocationPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union 
				select cast(15 as int) as rowNum,'Percent of Commitment Filings that are LEAD',cast((select cast(COMMITleadPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union 
				select cast(16 as int) as rowNum,'Percent of Commitment Filings that are Steered ISCs',cast((select cast(COMMITISCPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union 
				select cast(17 as int) as rowNum,'Percent of UBoat output that are LEAD',cast((select cast(UBOATleadPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union 
				select cast(18 as int) as rowNum,'Percent of UBoat output that are Steered ISCs',cast((select cast(UBOATISCPct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union
				Select cast(19 as int) as rowNum,'Percent of Shipments in BOOKING_FINAL with no ROUTELINKS Data', cast((select cast(BKGFINALROUTELINKSMATCHPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union
				Select cast(20 as int) as rowNum,'Percent of Shipments from ROUTELINKS where FromSiteCode does not match GSIS Schedules ', cast((select cast(FromSitePct * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union
				Select cast(21 as int) as rowNum,'Percent of Shipments from ROUTELINKS where ToSiteCode does not match GSIS Schedules ', cast((select cast(ToSitePct  * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
				union
				Select cast(22 as int) as rowNum,'Percent of Shipments from ROUTELINKS where both FromSiteCode and ToSiteCode does not match GSIS Schedules ', cast((select cast(FROMSITE_TOSITEPCT * 100 as float) from #CALNUMBERS) as varchar(10))+'%'
			)a		
				           
		EXEC msdb.dbo.sp_send_dbmail
				   @recipients = @Support_Email,
				   @body = @V_Results,
				   @subject = @V_SUBJECT,
				   @body_format ='HTML'
		SET @V_ERROR_CODE = 0
		RETURN @V_ERROR_CODE
	end try
	begin catch
		set @V_SUBJECT = 'Report Generation failed'
		SET @V_Results =  '<br /><br />' +

					 '<div style="color:#0000FF">'+
					  '<h3>'+@V_SUBJECT+'</h3>'+
					  '<p>Team,</p>'+
					  '<p>The report generation process failed.Please reach out to MA.</p>'+
					  '<p>Thanks.</p>'+
					  '<p>Forecast Team.</p>'+
					'</div>'

		EXEC msdb.dbo.sp_send_dbmail
				   @recipients = @Support_Email,
				   @body = @V_Results,
				   @subject = @V_SUBJECT,
				   @body_format ='HTML'

		SET @V_ERROR_CODE = -1
		RETURN @V_ERROR_CODE

	end catch
END
GO

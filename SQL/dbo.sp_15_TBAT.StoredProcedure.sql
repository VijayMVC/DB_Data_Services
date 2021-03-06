USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_15_TBAT]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_15_TBAT] @District varchar(255) = 'Standard'
AS
BEGIN
SET NOCOUNT ON;
	IF @district = 'SJ'
	BEGIN
	
delete from  Data_Services.dbo.SF_Assessment_TBAT where [SchoolForce__External_Id__c] like 'SJ%'
	
SELECT e.SF_ID Student_ID
		,(	select id as value 
	from [sdw_stage_prod_17].[dbo].[Picklist_Value__c] 
	where name = 'Cumulative Time Based Attendance Tracker - ATTENDANCE') AS SchoolForce__Type__c
		,'Time Based Attendance Tracker' AS SchoolForce__Assessment_Name__c
		,CAST(RTRIM(CAST(d.Month AS VARCHAR(5))) + '/1/' + CAST(d.Year AS VARCHAR(4)) AS DATE) [Date]
		,SUM(CASE WHEN A.Attendance_Status in ('EXCUSED','UNEXCUSED') THEN 1 ELSE 0 END) Number_Of_Absences
		,SUM(CASE WHEN A.Attendance_Status in ('EXCUSED') THEN 1 ELSE 0 END) Excused_Absences
		,SUM(CASE WHEN A.Attendance_Status in ('Tardy','Tardy < 30','Tardy > 30') THEN 1 ELSE 0 END) Number_of_Tardies
		,SUM(CASE WHEN A.Attendance_Status in ('UNEXCUSED') THEN 1 ELSE 0 END) Number_Of_Unexcused_Absences
		,null AS Days_Enrolled__c
		,e.District + '_' + cast(cast(e.School_ID AS INTEGER) as VARCHAR(4)) + '_' + e.Student_ID + '_' + CAST(d.YearMonth_Number AS VARCHAR(6)) [SchoolForce__External_Id__c]
	
INTO #TBAT1
	
FROM Data_Services.dbo.[Attendance] (NOLOCK) A INNER JOIN 
	SDW_Prod.dbo.DimDate(nolock) D ON 
		CAST(A.Date AS DATE) = D.Date INNER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) e ON 
		a.Student_ID = e.Student_ID AND A.District = 'SJ'
GROUP BY e.SF_ID, CAST(RTRIM(CAST(d.Month AS VARCHAR(5))) + '/1/' + CAST(d.Year AS VARCHAR(4)) AS DATE), A.Student_ID, e.District + '_' + CAST(CAST(e.School_ID AS INTEGER) AS VARCHAR(4)) + '_' + e.Student_ID+ '_' + CAST(d.YearMonth_Number AS VARCHAR(6))

INSERT INTO Data_Services.dbo.SF_Assessment_TBAT(Student_ID
	, SchoolForce__Type__c
	, SchoolForce__Assessment_Name__c, [Date]
	, Number_Of_Absences
	, Excused_Absences
	, Number_of_Tardies
	, Number_Of_Unexcused_Absences
	, Days_Enrolled__c
	, SchoolForce__External_Id__c)
		
SELECT a.Student_ID
	, a.SchoolForce__Type__c
	, a.SchoolForce__Assessment_Name__c
	, a.[Date]
	, a.Number_Of_Absences
	, a.Excused_Absences
	, a.Number_of_Tardies
	, a.Number_Of_Unexcused_Absences
	, a.Days_Enrolled__c
	, a.[SchoolForce__External_Id__c]
FROM #TBAT1 (NOLOCK) A LEFT OUTER JOIN 
	Data_Services.dbo.Master_Assessment_TBAT (NOLOCK) f ON 
		a.[SchoolForce__External_Id__c] = f.SchoolForce__External_Id__c
WHERE f.SchoolForce__External_Id__c IS NULL

INSERT INTO Data_Services.dbo.SF_Assessment_TBAT(Student_ID
	, SchoolForce__Type__c
	, SchoolForce__Assessment_Name__c
	, [Date]
	, Number_Of_Absences
	, Excused_Absences
	, Number_of_Tardies
	, Number_Of_Unexcused_Absences
	, Days_Enrolled__c
	, SchoolForce__External_Id__c)
		
SELECT a.Student_ID
	, a.SchoolForce__Type__c
	, a.SchoolForce__Assessment_Name__c
	, a.[Date]
	, a.Number_Of_Absences
	, a.Excused_Absences
	, a.Number_of_Tardies
	, a.Number_Of_Unexcused_Absences
	, a.Days_Enrolled__c
	, a.[SchoolForce__External_Id__c]
FROM #TBAT1 (NOLOCK) A INNER JOIN 
	Data_Services.dbo.Master_Assessment_TBAT (NOLOCK) f ON 
		a.[SchoolForce__External_Id__c] = f.SchoolForce__External_Id__c
WHERE a.Number_Of_Absences <> f.Number_Of_Absences OR 
	a.Excused_Absences <> f.Excused_Absences OR
	a.Number_of_Tardies <> f.Number_of_Tardies OR 
	a.Number_Of_Unexcused_Absences <> f.Number_Of_Unexcused_Absences OR
	a.Days_Enrolled__c <> f.Days_Enrolled__c


		
delete from Data_Services.dbo.SF_Assessment_TBAT
where date > getdate()


	END


	ELSE 
	BEGIN

	truncate table Data_Services.dbo.SF_Assessment_TBAT
	
	select e.SF_ID Student_ID,
	 (select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'TBAT.Type') as SchoolForce__Type__c,
	 'Time Based Attendance Tracker' as SchoolForce__Assessment_Name__c,
	cast(rtrim(cast(d.Month as varchar(5))) + '/1/' + cast(d.Year as varchar(4)) as date) [Date],
	sum(case when A.Attendance_Status in ('ABSENT EXCUSED','ABSENT UNEXCUSED') then 1 else 0 end) Number_Of_Absences,
	sum(case when A.Attendance_Status = 'ABSENT EXCUSED' then 1 else 0 end) Excused_Absences,
	sum(case when A.Attendance_Status = 'TARDY TO CLASS UNEXCUSED' then 1 else 0 end) Number_of_Tardies,
	sum(case when A.Attendance_Status = 'ABSENT UNEXCUSED' then 1 else 0 end) Number_Of_Unexcused_Absences
	,5 as Days_Enrolled__c
	,e.District + '_' + cast(cast(e.School_ID as integer) as varchar(4)) + '_' + e.Student_ID + '_' + cast(d.YearMonth_Number as varchar(6)) [SchoolForce__External_Id__c]
	into #TBAT
	from Data_Services.dbo.[Attendance] (nolock) A
	inner join SDW_Prod.dbo.DimDate(nolock) D on cast(A.Date as date) = D.Date
	inner join Data_Services.dbo.Master_Student (nolock) e on a.Student_ID = e.Student_ID
	group by e.SF_ID, cast(rtrim(cast(d.Month as varchar(5))) + '/1/' + cast(d.Year as varchar(4)) as date), A.Student_ID, e.District + '_' + cast(cast(e.School_ID as integer) as varchar(4)) + '_' + e.Student_ID+ '_' + cast(d.YearMonth_Number as varchar(6))

	insert into Data_Services.dbo.SF_Assessment_TBAT(Student_ID, SchoolForce__Type__c, SchoolForce__Assessment_Name__c, [Date], 
	Number_Of_Absences, Excused_Absences, Number_of_Tardies, Number_Of_Unexcused_Absences, Days_Enrolled__c, SchoolForce__External_Id__c)
	select a.Student_ID, a.SchoolForce__Type__c, a.SchoolForce__Assessment_Name__c, a.[Date], a.Number_Of_Absences, a.Excused_Absences, a.Number_of_Tardies, a.Number_Of_Unexcused_Absences, 
	a.Days_Enrolled__c, a.[SchoolForce__External_Id__c]
	from #TBAT (nolock) A
	left outer join Data_Services.dbo.Master_Assessment_TBAT (nolock) f on a.[SchoolForce__External_Id__c] = f.SchoolForce__External_Id__c
	where f.SchoolForce__External_Id__c is null

	insert into Data_Services.dbo.SF_Assessment_TBAT(Student_ID, SchoolForce__Type__c, SchoolForce__Assessment_Name__c, [Date], 
	Number_Of_Absences, Excused_Absences, Number_of_Tardies, Number_Of_Unexcused_Absences, Days_Enrolled__c, SchoolForce__External_Id__c)
	select a.Student_ID, a.SchoolForce__Type__c, a.SchoolForce__Assessment_Name__c, a.[Date], a.Number_Of_Absences, a.Excused_Absences, a.Number_of_Tardies, a.Number_Of_Unexcused_Absences, 
	a.Days_Enrolled__c, a.[SchoolForce__External_Id__c]
	from #TBAT (nolock) A
	inner join Data_Services.dbo.Master_Assessment_TBAT (nolock) f on a.[SchoolForce__External_Id__c] = f.SchoolForce__External_Id__c
	where a.Number_Of_Absences <> f.Number_Of_Absences or a.Excused_Absences <> f.Excused_Absences or a.Number_of_Tardies <> f.Number_of_Tardies or a.Number_Of_Unexcused_Absences <> f.Number_Of_Unexcused_Absences or a.Days_Enrolled__c <> f.Days_Enrolled__c

/*
	insert into Data_Services.dbo.SF_Assessment_TBAT(Student_ID, SchoolForce__Type__c, SchoolForce__Assessment_Name__c, [Date], 
	Number_Of_Absences, Excused_Absences, Number_of_Tardies, Number_Of_Unexcused_Absences, Days_Enrolled__c, SchoolForce__External_Id__c)
	select e.SF_ID Student_ID,
	 'a0r1a000000ot9YAAQ' as SchoolForce__Type__c,
	 'Time Based Attendance Tracker' as SchoolForce__Assessment_Name__c,
	cast(rtrim(cast(d.Month as varchar(5))) + '/1/' + cast(d.Year as varchar(4)) as date) [Date],
	sum(case when A.Attendance_Status in ('ABSENT EXCUSED','ABSENT UNEXCUSED') then 1 else 0 end) Number_Of_Absences,
	sum(case when A.Attendance_Status = 'ABSENT EXCUSED' then 1 else 0 end) Excused_Absences,
	sum(case when A.Attendance_Status = 'TARDY TO CLASS UNEXCUSED' then 1 else 0 end) Number_of_Tardies,
	sum(case when A.Attendance_Status = 'ABSENT UNEXCUSED' then 1 else 0 end) Number_Of_Unexcused_Absences
	,5 as Days_Enrolled__c
	,e.District + '_' + cast(cast(e.School_ID as integer) as varchar(4)) + '_' + e.Student_ID + '_' + cast(d.YearMonth_Number as varchar(6)) [SchoolForce__External_Id__c]
	from Data_Services.dbo.[Attendance] (nolock) A
	inner join SDW.dbo.DimDate(nolock) D on cast(A.Date as date) = D.Date
	inner join Data_Services.dbo.Master_Student (nolock) e on a.Student_ID = e.Student_ID
	left outer join Data_Services.dbo.Master_Assessment_TBAT (nolock) f on e.District + '_' + cast(cast(e.School_ID as integer) as varchar(4)) + '_' + e.Student_ID + '_' + cast(d.YearMonth_Number as varchar(6)) = f.SchoolForce__External_Id__c
	where f.SchoolForce__External_Id__c is null
	group by e.SF_ID, cast(rtrim(cast(d.Month as varchar(5))) + '/1/' + cast(d.Year as varchar(4)) as date), A.Student_ID, e.District + '_' + cast(cast(e.School_ID as integer) as varchar(4)) + '_' + e.Student_ID+ '_' + cast(d.YearMonth_Number as varchar(6))
*/
END
END


GO

USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_13_English]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_13_English] @District varchar(255) = 'Standard'
AS
BEGIN
SET NOCOUNT ON;
IF @DISTRICT = 'SJ'
BEGIN

SET NOCOUNT ON;

delete from Data_Services.dbo.SF_Assessment_English where [SchoolForce__External_Id__c] like 'sj%'

	select 
	b.SF_ID Student_ID, 
	(select ID FROM [sdw_stage_prod_17].[dbo].[Picklist_Value__c] where name = 'CAASPP - ELA') SchoolForce__Type__c,
	'ELA' [Subject],
	cast(a.Date as date) [Date_Administered__c],
	isnull(Scale_Score, 0) FSA_ELA_Score_c,
	isnulL(Profiency_Rating_Level, 'N/A') Local_Benchmark__c
	,b.District + '_' + cast(cast(b.School_ID as integer) as varchar(4)) + '_' + b.Student_ID + '_' [SchoolForce__External_Id__c]
	into #English1
	from Data_Services.dbo.Assessments (nolock) a
	inner join Data_Services.dbo.Master_Student (Nolock) b on a.Student_ID = b.Student_ID and a.district = 'sj'
	where a.Assessment_Name in ('CAASPP') AND A.Assessment_Subject_Topic = 'ELA'

	insert into Data_Services.dbo.SF_Assessment_English(Student_ID, SchoolForce__Type__c, SchoolForce__Assessment_Name__c, Date_Administered__c, FSA_ELA_Score_c, Local_Benchmark__c, [SchoolForce__External_Id__c])
	select a.Student_ID, a.SchoolForce__Type__c, a.Subject, a.[Date_Administered__c], a.FSA_ELA_Score_c, a.Local_Benchmark__c, a.[SchoolForce__External_Id__c]
	from #English1 (nolock) a
	left outer join Data_Services.dbo.Master_Assessment_english (nolock) c
	on a.Student_ID = c.Student_ID and a.SchoolForce__Type__c = c.SchoolForce__Type__c and a.Subject = c.SchoolForce__Assessment_Name__c and cast(a.Date_Administered__c as date) = cast(c.Date_Administered__c as date) and isnull(a.Local_Benchmark__c, 'N/A') = c.Local_Benchmark__c 
	where c.Student_ID is null	
	and c.SchoolForce__Type__c is null
	and c.SchoolForce__Assessment_Name__c is null	
	and cast(c.Date_Administered__c as date) is null
	and c.Local_Benchmark__c is null

	update Data_Services.dbo.SF_Assessment_English set [SchoolForce__External_Id__c] = [SchoolForce__External_Id__c] + cast(ID as varchar(5))
	where [SchoolForce__External_Id__c] like 'SJ%'
END

IF @DISTRICT = 'OCPS'
BEGIN

SET NOCOUNT ON;
	delete from Data_Services.dbo.SF_Assessment_English
	-- select count(*) from Assessments (nolock) where Assessment_Name in ('BENCHMARKS FSA READING')

	select 
	b.SF_ID Student_ID, 
	(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'English.Type') SchoolForce__Type__c,
	'Florida State Assessment English Language Arts' SchoolForce__Assessment_Name__c,
	cast(a.Date as date) [Date_Administered__c],
	Scale_Score FSA_ELA_Score_c,
	isnull(Profiency_Rating_Level, 'N/A') Local_Benchmark__c
	,b.District + '_' + cast(cast(b.School_ID as integer) as varchar(4)) + '_' + b.Student_ID + '_' [SchoolForce__External_Id__c]
	into #English
	from Data_Services.dbo.Assessments (nolock) a
	inner join Data_Services.dbo.Master_Student (Nolock) b on a.Student_ID = b.Student_ID
	inner join SDW_Prod.dbo.DimDate(nolock) D on cast(A.Date as date) = D.Date
	where a.Assessment_Name in ('BENCHMARKS FSA READING') and Scale_Score is not null and convert(datetime, a.[Date], 1) >= '1-JAN-15'
--	and e.Source_Student_ID is null 
--	and e.Assessment_Name is null 
--	and cast(e.Date_Administered__c as date) is null 
--	and e.FSA_ELA_Score_c is null 
--	and e.Local_Benchmark__c is null
	-- 54

	insert into Data_Services.dbo.SF_Assessment_English(Student_ID, SchoolForce__Type__c, SchoolForce__Assessment_Name__c, Date_Administered__c, FSA_ELA_Score_c, Local_Benchmark__c, [SchoolForce__External_Id__c])
	select a.Student_ID, a.SchoolForce__Type__c, a.SchoolForce__Assessment_Name__c, a.[Date_Administered__c], a.FSA_ELA_Score_c, a.Local_Benchmark__c, a.[SchoolForce__External_Id__c]
	from #English (nolock) a 
	left outer join Data_Services.dbo.Master_Assessment_English (nolock) e 
	on a.Student_ID = e.Student_ID and a.SchoolForce__Type__c = e.SchoolForce__Type__c and a.SchoolForce__Assessment_Name__c = e.SchoolForce__Assessment_Name__c and cast(a.Date_Administered__c as date) = cast(e.Date_Administered__c as date) 
	where e.Source_Student_ID is null 
	and e.Assessment_Name is null 
	and cast(e.Date_Administered__c as date) is null 
	and e.FSA_ELA_Score_c is null 
	and e.Local_Benchmark__c is null

	update Data_Services.dbo.SF_Assessment_English set [SchoolForce__External_Id__c] = [SchoolForce__External_Id__c] + cast(ID as varchar(5))
	where [SchoolForce__External_Id__c] like 'OCPS%'

END

END




GO

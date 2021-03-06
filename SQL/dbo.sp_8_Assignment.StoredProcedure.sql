USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_8_Assignment]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_8_Assignment] @District varchar(255) = 'Standard'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec Data_Services.dbo.sp_Index_Assignment_Grades_Create

	alter index all on Data_Services.dbo.Master_Assignment_Type REBUILD
	alter index all on Data_Services.dbo.Class_Processed REBUILD
	alter index all on Data_Services.dbo.Master_Section REBUILD
	alter index all on Data_Services.dbo.Master_Student REBUILD
	alter index all on Data_Services.dbo.School_Lookup REBUILD

	insert into Data_Services.dbo.Master_Assignment_Type(Assignment_Type, Assignment_Type_Normalized, District)
	select distinct a.Assignment_Type, 'Uncategorized', 'OCPS'
	from Data_Services.dbo.Assignment_Grades (nolock) a
	left outer join Data_Services.dbo.Master_Assignment_Type (nolock) b on a.Assignment_Type = b.Assignment_Type
	where b.Assignment_Type is null and a.Assignment_Type is not null

	update Data_Services.dbo.Assignment_Grades set Assignment_Name = ltrim(Assignment_Name)
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'º','')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'á','a')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'í','i')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'ó','o')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'ö','o')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'ä','a')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'é','e')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'ë','e')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'ú','u')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'ñ','n')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'ú','u')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'''','')
	update Data_Services.dbo.Assignment_Grades set Assignment_Name = replace(Assignment_Name,'*','')

	select * into #Master_Assignment_Library from Data_Services.dbo.vw_Master_Assignment_Library (nolock)
	create nonclustered index #a on #Master_Assignment_Library(Marking_Period_2)
	create nonclustered index #b on #Master_Assignment_Library(Assignment_Type)
	create nonclustered index #c on #Master_Assignment_Library(Section_Type_2)
	create nonclustered index #d on #Master_Assignment_Library(ID)
	
	select * into #Setup from SDW_Stage_Prod.dbo.Setup__c (nolock)
	create nonclustered index #a on #Setup(School__c)
	create nonclustered index #b on #Setup(Term__c)
	
	select * into #Time_Element from SDW_Stage_Prod.dbo.Time_Element__c (nolock)
	create nonclustered index #a on #Time_Element(Parent_Time_Element__c)

	select * into #Assignment from SDW_Stage_Prod.dbo.Assignment__c (nolock)
	create nonclustered index #a on #Assignment (Name )
	create nonclustered index #b on #Assignment (Assignment_Library__c)
	create nonclustered index #c on #Assignment (Due_Date__c)

	-- delete from Data_Services.dbo.SF_Assignment

if @District = 'OCPS'
	BEGIN

	
  delete from Data_Services.dbo.SF_Assignment where left(SchoolForce__External_Id__c,5) = 'OCPS_'

	insert into Data_Services.dbo.SF_Assignment(Name, Assignment_Library__c, SchoolForce__Due_Date__c, SchoolForce__Picklist_Value__c, SchoolForce__Include_in_Final_Grade__c, SchoolForce__Name_in_Gradebook__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Section__c, SchoolForce__Weighting_Value__c, Local_Assignment_Type__c)
	select distinct 
	Assignment_Name Name, 
	e.ID Assignment_Library__c, 
	cast(datepart(yyyy, [Date]) as varchar(4)) + '-' + 
	CASE len(cast(datepart(mm, [Date]) as varchar(2)))
		WHEN 1 then '0' + cast(datepart(mm, [Date]) as varchar(2))
		ELSE cast(datepart(mm, [Date]) as varchar(2))
	END
	 + '-' + 
	CASE len(cast(datepart(dd, [Date]) as varchar(2)))
		WHEN 1 then '0' + cast(datepart(dd, [Date]) as varchar(2))
		ELSE cast(datepart(dd, [Date]) as varchar(2))
	END [SchoolForce__Due_Date__c], 
	(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'Assignment.Picklist_Value') [SchoolForce__Picklist_Value__c], 
	1 [SchoolForce__Include_in_Final_Grade__c], 
	a.Marking_Period [SchoolForce__Name_in_Gradebook__c],
	100 [SchoolForce__Possible_Points__c], 
	j.ID [SchoolForce__Time__c], 
	f.SF_ID [SchoolForce__Section__c], 
	1 [SchoolForce__Weighting_Value__c],
	a.Assignment_Type Local_Assignment_Type__c
	from Data_Services.dbo.Assignment_Grades (nolock) a 
	inner join Data_Services.dbo.Master_Assignment_Type (nolock) b on isnull(a.Assignment_Type, 'N/A') = isnull(b.Assignment_Type, 'N/A')
--	inner join (SELECT distinct [Picklist_Value__c],[Type__c] FROM [SDW_Stage_Prod].[dbo].[Assignment_Lib__c] ) c on b.Assignment_Type_Normalized = c.[Type__c]
	inner join Data_Services.dbo.Class_Processed (nolock) d on a.Class_Section_ID = d.Class_Section_ID and a.Student_ID = d.Student_ID
	inner join #Master_Assignment_Library (nolock) e on e.Marking_Period_2 = a.Marking_Period and e.Assignment_Type = b.Assignment_Type_Normalized and e.Section_Type_2 = d.Section_Type
	inner join Data_Services.dbo.Master_Section (nolock) f on a.Class_Section_ID = f.Class_Section_ID and f.Source_School_ID = substring(a.Class_Section_ID, 1, 4)
	inner join Data_Services.dbo.Master_Student (nolock) g on d.Student_ID = g.Student_ID and g.School_ID = substring(a.Class_Section_ID, 1, 4)
	inner join Data_Services.dbo.School_Lookup (nolock) h on g.SchoolForce__Setup__C = h.Setup_14_15
	inner join #Setup (nolock) i on h.Account_ID = i.[School__c]
	inner join #Time_Element (nolock) j on i.[Term__c] = j.[Parent_Time_Element__c]
	left outer join #Assignment (nolock) k on a.Assignment_Name = k.Name and e.ID = k.Assignment_Library__c and cast([Due_Date__c] as date) = cast(k.Due_Date__c as date) 
	and j.ID = k.[Time__c] and f.SF_ID = k.[Section__c]
	where a.Marking_Period is not null 
	and (datepart(yyyy, i.[Year_Start__c]) = 2015 and datepart(yyyy, i.[Year_End__c]) = 2016)
	and a.[Date] between cast([Date_Start_Date__c] as date) and cast([End_Date__c] as date)
	and k.Name is null 
	and k.Assignment_Library__c is null
	and cast(k.Due_Date__c as date) is null
	and k.Time__c is null
	and k.Section__c is null
	and cast(a.Date as date) < getdate()
	and a.District = @District
	-- 32,447

	update Data_Services.dbo.SF_Assignment set [SchoolForce__External_Id__c] = 'OCPS_' + cast(ID as varchar(10)) where [SchoolForce__External_Id__c] is null
	END

If @district = 'KCPS'

delete from Data_Services.dbo.SF_Assignment where left(SchoolForce__External_Id__c,5) = 'KCPS_'
	BEGIN
		insert into Data_Services.dbo.Master_Assignment_Type(Assignment_Type, Assignment_Type_Normalized, District)
	select distinct a.Assignment_Type
	, CASE (a.assignment_type)
		WHEN 'CLS' then 'Classwork'
		WHEN 'QIZ' then 'Quiz'
		WHEN 'PRJ' then 'Project'
		WHEN 'TST' then 'Test'
		WHEN 'HWK' then 'Homework'
		ELSE 'Uncategorized'
		END
	--'Uncategorized'
	, 'KCPS'
	from Data_Services.dbo.Assignment_Grades (nolock) a
	left outer join Data_Services.dbo.Master_Assignment_Type (nolock) b on a.Assignment_Type = b.Assignment_Type
	where b.Assignment_Type is null and a.Assignment_Type is not null and a.district = 'kcps'

	select * into #Master_Assignment_Library2 from Data_Services.dbo.vw_Master_Assignment_Library_17 (nolock)
	create nonclustered index #a on #Master_Assignment_Library2(Marking_Period_2)
	create nonclustered index #b on #Master_Assignment_Library2(Assignment_Type)
	create nonclustered index #c on #Master_Assignment_Library2(Section_Type_2)
	create nonclustered index #d on #Master_Assignment_Library2(ID)
	
	select * into #Setup2 from SDW_Stage_Prod_17.dbo.Setup__c (nolock)
	create nonclustered index #a on #Setup2(School__c)
	create nonclustered index #b on #Setup2(Term__c)
	
	select * into #Time_Element2 from SDW_Stage_Prod_17.dbo.Time_Element__c (nolock)
	create nonclustered index #a on #Time_Element2(Parent_Time_Element__c)

	select * into #Assignment2 from SDW_Stage_Prod_17.dbo.Assignment__c (nolock)
	create nonclustered index #a on #Assignment2 (Name )
	create nonclustered index #b on #Assignment2 (Assignment_Library__c)
	create nonclustered index #c on #Assignment2 (Due_Date__c)

	delete from Data_Services.dbo.SF_Assignment where [SchoolForce__External_Id__c] like 'KCPS%'

	Update [Data_Services].[dbo].[Assignment_Grades]
  Set Marking_Period = Replace(Marking_Period, 'Term-', 'Q')
  where district = 'kcps'


	insert into Data_Services.dbo.SF_Assignment(Name, Assignment_Library__c, SchoolForce__Due_Date__c, SchoolForce__Picklist_Value__c, SchoolForce__Include_in_Final_Grade__c, SchoolForce__Name_in_Gradebook__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Section__c, SchoolForce__Weighting_Value__c, Local_Assignment_Type__c)
	select distinct 
	Assignment_Name Name, 
	e.ID Assignment_Library__c, 
	End_Date__c [SchoolForce__Due_Date__c], 
	'a1h36000000yQ4CAAU' [SchoolForce__Picklist_Value__c], 
	1 [SchoolForce__Include_in_Final_Grade__c], 
	a.Marking_Period [SchoolForce__Name_in_Gradebook__c],
	'0' [SchoolForce__Possible_Points__c], 
	j.ID [SchoolForce__Time__c], 
	f.SF_ID [SchoolForce__Section__c], 
	1 [SchoolForce__Weighting_Value__c],
	a.Assignment_Type Local_Assignment_Type__c
	from Data_Services.dbo.Assignment_Grades (nolock) a 
	inner join Data_Services.dbo.Master_Assignment_Type (nolock) b on isnull(a.Assignment_Type, 'N/A') = isnull(b.Assignment_Type, 'N/A')
	inner join (SELECT distinct [Picklist_Value__c],[Type__c] FROM [SDW_Stage_Prod_17].[dbo].[Assignment_Lib__c] ) c on b.Assignment_Type_Normalized = c.[Type__c]
	inner join Data_Services.dbo.Class_Processed (nolock) d on a.Class_Section_ID = d.Class_Section_ID and a.Student_ID = d.Student_ID
	inner join #Master_Assignment_Library2 (nolock) e on e.Marking_Period_2 = a.Marking_Period and e.Assignment_Type = b.Assignment_Type_Normalized and e.Section_Type_2 = d.Section_Type
	inner join Data_Services.dbo.Master_Section (nolock) f on a.Class_Section_ID = f.Class_Section_ID 
	inner join Data_Services.dbo.Master_Student (nolock) g on d.Student_ID = g.Student_ID 
	inner join Data_Services.dbo.School_Lookup_16_17 (nolock) h on g.SchoolForce__Setup__C = h.Setup_14_15
	inner join #Setup2 (nolock) i on h.Account_ID = i.[School__c]
	inner join #Time_Element2 (nolock) j on i.[Term__c] = j.[Parent_Time_Element__c]
	left outer join #Assignment2 (nolock) k on a.Assignment_Name = k.Name and e.ID = k.Assignment_Library__c and cast([Due_Date__c] as date) = cast(k.Due_Date__c as date) 
	and j.ID = k.[Time__c] and f.SF_ID = k.[Section__c]
	where a.Marking_Period is not null and a.district ='kcps' 
	AND REPLACE(j.Name__c,'Quarter ','Q') = a.Marking_Period
	and (datepart(yyyy, i.[Year_Start__c]) = 2016 and datepart(yyyy, i.[Year_End__c]) = 2017)
	and k.Name is null 
	and k.Assignment_Library__c is null
	and cast(k.Due_Date__c as date) is null
	and k.Time__c is null
	and k.Section__c is null


	update Data_Services.dbo.SF_Assignment set [SchoolForce__External_Id__c] = 'KCPS_' + cast(ID as varchar(10)) 
	where [SchoolForce__External_Id__c] is null

	END
IF @DISTRICT = 'SJ'
	BEGIN

	insert into Data_Services.dbo.Master_Assignment_Type(Assignment_Type, Assignment_Type_Normalized, District)
	select distinct a.Assignment_Type, 
	 CASE (a.assignment_type)
		WHEN 'CW' then 'Classwork'
		WHEN 'QUIZ' then 'Quiz'
		WHEN 'PROJ' then 'Project'
		WHEN 'TEST' then 'Test'
		WHEN 'HW' then 'Homework'
		WHEN 'CP' then 'Participation'
		ELSE 'Uncategorized'
		END
	, 'SJ'
	from Data_Services.dbo.Assignment_Grades (nolock) a
	left outer join Data_Services.dbo.Master_Assignment_Type (nolock) b on a.Assignment_Type = b.Assignment_Type 
	where b.Assignment_Type is null and a.Assignment_Type is not null and a.assignment_type = 'sj'
	
	select * into #Master_Assignment_Library1 from Data_Services.dbo.vw_Master_Assignment_Library_17 (nolock)
	create nonclustered index #a on #Master_Assignment_Library1(Marking_Period_2)
	create nonclustered index #b on #Master_Assignment_Library1(Assignment_Type)
	create nonclustered index #c on #Master_Assignment_Library1(Section_Type_2)
	create nonclustered index #d on #Master_Assignment_Library1(ID)
	
	select * into #Setup1 from SDW_Stage_Prod_17.dbo.Setup__c (nolock)
	create nonclustered index #a on #Setup1(School__c)
	create nonclustered index #b on #Setup1(Term__c)
	
	select * into #Time_Element1 from SDW_Stage_Prod_17.dbo.Time_Element__c (nolock)
	create nonclustered index #a on #Time_Element1(Parent_Time_Element__c)

	select * into #Assignment1 from SDW_Stage_Prod_17.dbo.Assignment__c (nolock)
	create nonclustered index #a on #Assignment1 (Name )
	create nonclustered index #b on #Assignment1 (Assignment_Library__c)
	create nonclustered index #c on #Assignment1 (Due_Date__c)

	delete from Data_Services.dbo.SF_Assignment where [SchoolForce__External_Id__c] like 'SJ%'

	insert into Data_Services.dbo.SF_Assignment(Name, Assignment_Library__c, SchoolForce__Due_Date__c, SchoolForce__Picklist_Value__c, SchoolForce__Include_in_Final_Grade__c, SchoolForce__Name_in_Gradebook__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Section__c, SchoolForce__Weighting_Value__c, Local_Assignment_Type__c)
	select  distinct
	Assignment_Name Name, 
	e.ID Assignment_Library__c, 
	End_Date__c [SchoolForce__Due_Date__c], 
	(select id as value  from [sdw_stage_prod_17].[dbo].Picklist_Value__c where Category__c = 'points' and type__C = 'Grade Scale') [SchoolForce__Picklist_Value__c], 
	1 [SchoolForce__Include_in_Final_Grade__c], 
	a.Marking_Period [SchoolForce__Name_in_Gradebook__c],
	100 [SchoolForce__Possible_Points__c], 
	j.ID [SchoolForce__Time__c], 
	f.SF_ID [SchoolForce__Section__c], 
	1 [SchoolForce__Weighting_Value__c],
	a.Assignment_Type Local_Assignment_Type__c
	from Data_Services.dbo.Assignment_Grades (nolock) a 
	inner join Data_Services.dbo.Master_Assignment_Type (nolock) b on isnull(a.Assignment_Type, 'N/A') = isnull(b.Assignment_Type, 'N/A') and a.district = 'sj'
	inner join (SELECT distinct id as [Picklist_Value__c],name as [Type__c]  FROM [sdw_stage_prod_17].[dbo].Picklist_Value__c ) c on b.Assignment_Type_Normalized = c.[Type__c]-- and b.District = 'sj'
	inner join Data_Services.dbo.Class_Processed (nolock) d on a.Class_Section_ID = d.Class_Section_ID and a.Student_ID = d.Student_ID and a.district = 'sj'
	inner join #Master_Assignment_Library1 (nolock) e on e.Marking_Period_2 = a.Marking_Period and e.Assignment_Type = b.Assignment_Type_Normalized and e.Section_Type_2 = d.Section_Type
	--and f.Source_School_ID = substring(a.Class_Section_ID, 1, 4)
	inner join Data_Services.dbo.Master_Student (nolock) g on d.Student_ID = g.Student_ID 
	inner join Data_Services.dbo.Master_Section (nolock) f on a.Class_Section_ID = f.Class_Section_ID and f.source_school_id = g.school_id
	--and g.School_ID = substring(a.Class_Section_ID, 1, 4)
	inner join Data_Services.dbo.School_Lookup_16_17 (nolock) h on g.SchoolForce__Setup__C = h.Setup_14_15 and h.Source_School_ID = g.School_ID
	inner join #Setup1 (nolock) i on h.Account_ID = i.[School__c]
	inner join #Time_Element1 (nolock) j  
	ON 
(i.[Term__c] = j.[Parent_Time_Element__c] AND a.Marking_Period = REPLACE(j.Name__c,'Quarter ','Q')) or
 (i.[Term__c] = j.[Parent_Time_Element__c] AND a.Marking_Period = REPLACE(j.Name__c,'Trimester ','T')) or
 (i.[Term__c] = j.[Parent_Time_Element__c] AND a.Marking_Period = REPLACE(j.Name__c,'Semester ','S'))
	left outer join #Assignment1 (nolock) k on a.Assignment_Name = k.Name and e.ID = k.Assignment_Library__c and cast([Due_Date__c] as date) = cast(k.Due_Date__c as date) 
	and j.ID = k.[Time__c] and f.SF_ID = k.[Section__c]
	where a.Marking_Period is not null and a.district ='sj'  
	--(REPLACE(j.Name__c,'Quarter ','Q') = a.Marking_Period or REPLACE(j.Name__c,'Trimester ','T') = a.Marking_Period)
	and (datepart(yyyy, i.[Year_Start__c]) = 2016 and datepart(yyyy, i.[Year_End__c]) = 2017)
	--and a.[Date] between cast([Date_Start_Date__c] as date) and cast([End_Date__c] as date)
	and k.Name is null 
	and k.Assignment_Library__c is null
	and cast(k.Due_Date__c as date) is null
	and k.Time__c is null
	and k.Section__c is null
	--and cast(a.Date as date) < getdate()
	-- 32,447

	update Data_Services.dbo.SF_Assignment set [SchoolForce__External_Id__c] = 'SJ_' + cast(ID as varchar(10))
	where [SchoolForce__External_Id__c] is null

	update  Data_Services.dbo.sf_Assignment  set SchoolForce__Due_Date__c = (
 cast(datepart(yyyy, SchoolForce__Due_Date__c) as varchar(4)) + '-' + 
	CASE len(cast(datepart(mm, SchoolForce__Due_Date__c) as varchar(2)))
		WHEN 1 then '0' + cast(datepart(mm, SchoolForce__Due_Date__c) as varchar(2))
		ELSE cast(datepart(mm, SchoolForce__Due_Date__c) as varchar(2))
	END
	 + '-' + 
	CASE len(cast(datepart(dd, SchoolForce__Due_Date__c) as varchar(2)))
		WHEN 1 then '0' + cast(datepart(dd, SchoolForce__Due_Date__c) as varchar(2))
		ELSE cast(datepart(dd, SchoolForce__Due_Date__c) as varchar(2))
	END 
	)
	
alter table Data_Services.dbo.sf_Assignment alter column SchoolForce__Due_Date__c date null
	END
	exec Data_Services.dbo.sp_Index_Assignment_Grades_Drop
END



GO

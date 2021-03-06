USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_9_Grade]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_9_Grade] @District varchar(255) = 'Standard'
AS
BEGIN

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

	select * into #Course from SDW_Stage_Prod.dbo.Course__c (nolock)
	create nonclustered index #a on #Course(Name)
	
if @District = 'OCPS'
	BEGIN	
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
	(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'Grade.Picklist_Value') [SchoolForce__Picklist_Value__c], 
	1 [SchoolForce__Include_in_Final_Grade__c], 
	a.Marking_Period [SchoolForce__Name_in_Gradebook__c],
	100 [SchoolForce__Possible_Points__c], 
	j.ID [SchoolForce__Time__c], 
	f.SF_ID [SchoolForce__Section__c], 
	0 [SchoolForce__Weighting_Value__c],
	a.Student_ID,
	a.Class_Section_ID,
	a.Marking_Period,
	b.Assignment_Type_Normalized,
	isnull(a.Grade_Value, 0) SchoolForce__Grade_Number__c,
	f.Section_Type
	into #Temp_Grades
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
	--left outer join SDW_Stage_Prod.dbo.SchoolForce__Assignment__c (nolock) k on a.Assignment_Name = k.Name and e.ID = k.SchoolForce__Assignment_Library__c and cast([SchoolForce__Due_Date__c] as date) = cast(k.SchoolForce__Due_Date__c as date) 
	--and j.ID = k.[SchoolForce__Time__c] and f.SF_ID = k.[SchoolForce__Section__c]
	where a.Marking_Period is not null 
	and (datepart(yyyy, i.[Year_Start__c]) = 2015 and datepart(yyyy, i.[Year_End__c]) = 2016)
	and a.[Date] between cast([Date_Start_Date__c] as date) and cast([End_Date__c] as date)
	and cast(a.Date as date) < getdate()
	and a.Marking_Period in ('Q1','Q2','Q3','Q4')
	and a.District = @District
	-- 331,999
	
	create nonclustered index #a on #Temp_Grades(Student_ID)
	create nonclustered index #b on #Temp_Grades(Class_Section_ID)
	create nonclustered index #c on #Temp_Grades(SchoolForce__Section__c)
	create nonclustered index #d on #Temp_Grades(Name)
	create nonclustered index #e on #Temp_Grades(Assignment_Library__c)
	create nonclustered index #f on #Temp_Grades(SchoolForce__Due_Date__c)
	create nonclustered index #g on #Temp_Grades(SchoolForce__Section__c)
	create nonclustered index #h on #Temp_Grades(SchoolForce__Name_in_Gradebook__c)
	create nonclustered index #i on #Temp_Grades(Section_Type)
	create nonclustered index #j on #Temp_Grades(SchoolForce__Time__c)

	delete from Data_Services.dbo.SF_Grade

	insert into Data_Services.dbo.SF_Grade(SchoolForce__Assignment__c, SchoolForce__Assignment_Weighting__c, SchoolForce__Course__c, SchoolForce__Grade_Number__c, SchoolForce__Points_Grade__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Student__c, SchoolForce__Student_Section__c, SchoolForce__Valid_Grade__c)
	select 
	d.SF_ID SchoolForce__Assignment__c,
	1 SchoolForce__Assignment_Weighting__c,
	e.ID SchoolForce__Course__c, 
	isnull(a.SchoolForce__Grade_Number__c, 0) SchoolForce__Grade_Number__c,
	0 SchoolForce__Points_Grade__c,
	100 SchoolForce__Possible_Points__c,
	a.SchoolForce__Time__c,
	b.SF_ID SchoolForce__Student__c,
	c.ID SchoolForce__Student_Section__c,
	1 SchoolForce__Valid_Grade__c
	from #Temp_Grades (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID and rtrim(SUBSTRING(a.Class_Section_ID, 0, 5)) = b.School_ID
	inner join Data_Services.dbo.Master_Student_Section (nolock) c on a.SchoolForce__Section__c = c.SchoolForce__Section__c and b.SF_ID = c.SchoolForce__Student__c
	inner join Data_Services.dbo.Master_Assignment (nolock) d 
			on a.Name = d.Name 
			and a.Assignment_Library__c = d.Assignment_Library__c 
			and cast(a.SchoolForce__Due_Date__c as date) = cast(d.SchoolForce__Due_Date__c as date) 
			and a.SchoolForce__Section__c = d.SchoolForce__Section__c 
			and a.SchoolForce__Name_in_Gradebook__c = d.SchoolForce__Name_in_Gradebook__c
	inner join #Course (nolock) e on a.Section_Type = e.Name
	left outer join Data_Services.dbo.Master_Grade (nolock) f 
			on d.SF_ID = f.SchoolForce__Assignment__c 
			and e.ID = f.SchoolForce__Course__c 
			and a.SchoolForce__Time__c = f.SchoolForce__Time__c
			and b.SF_ID = f.SchoolForce__Student__c 
			and c.ID = f.SchoolForce__Student_Section__c
	where f.SchoolForce__Assignment__c is null and f.SchoolForce__Course__c is null and f.SchoolForce__Time__c is null and f.SchoolForce__Student__c is null and f.SchoolForce__Student_Section__c is null 
	and e.Reference_Id__c like '%CY%'
	
	update Data_Services.dbo.SF_Grade set [SchoolForce__External_Id__c] = 'OCPS_' + cast(ID as varchar(10))

	insert into Data_Services.dbo.SF_Grade(SchoolForce__Assignment__c, SchoolForce__Assignment_Weighting__c, SchoolForce__Course__c, SchoolForce__Grade_Number__c, SchoolForce__Points_Grade__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Student__c, SchoolForce__Student_Section__c, SchoolForce__Valid_Grade__c, SchoolForce__External_Id__c)
	select 	
	d.SF_ID SchoolForce__Assignment__c,
	1 SchoolForce__Assignment_Weighting__c,
	e.ID SchoolForce__Course__c, 
	isnull(a.SchoolForce__Grade_Number__c, 0) SchoolForce__Grade_Number__c,
	0 SchoolForce__Points_Grade__c,
	100 SchoolForce__Possible_Points__c,
	a.SchoolForce__Time__c,
	b.SF_ID SchoolForce__Student__c,
	c.ID SchoolForce__Student_Section__c,
	1 SchoolForce__Valid_Grade__c,
	f.SchoolForce__External_Id__c
	from #Temp_Grades (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join Data_Services.dbo.Master_Student_Section (nolock) c on a.SchoolForce__Section__c = c.SchoolForce__Section__c and b.SF_ID = c.SchoolForce__Student__c
	inner join Data_Services.dbo.Master_Assignment (nolock) d 
		on a.Name = d.Name 
		and a.Assignment_Library__c = d.Assignment_Library__c 
		and dateadd(yy, 1, cast(a.SchoolForce__Due_Date__c as date)) = cast(d.SchoolForce__Due_Date__c as date) 
		and a.SchoolForce__Section__c = d.SchoolForce__Section__c 
		and a.SchoolForce__Name_in_Gradebook__c = d.SchoolForce__Name_in_Gradebook__c
	inner join #Course (nolock) e on a.Section_Type = e.Name
	inner join Data_Services.dbo.Master_Grade (nolock) f on d.SF_ID = f.SchoolForce__Assignment__c and e.ID = f.SchoolForce__Course__c and a.SchoolForce__Time__c = f.SchoolForce__Time__c
	and b.SF_ID = f.SchoolForce__Student__c and c.ID = f.SchoolForce__Student_Section__c
	where a.SchoolForce__Grade_Number__c <> f.SchoolForce__Grade_Number__c and e.Reference_Id__c like '%CY%'
END

if @District = 'KCPS'
	BEGIN
		select distinct 
	Assignment_Name Name, 
	e.ID Assignment_Library__c, 
	--cast(datepart(yyyy, [Date]) as varchar(4)) + '-' + 
	--CASE len(cast(datepart(mm, [Date]) as varchar(2)))
	--	WHEN 1 then '0' + cast(datepart(mm, [Date]) as varchar(2))
	--	ELSE cast(datepart(mm, [Date]) as varchar(2))
	--END
	-- + '-' + 
	--CASE len(cast(datepart(dd, [Date]) as varchar(2)))
	--	WHEN 1 then '0' + cast(datepart(dd, [Date]) as varchar(2))
	--	ELSE cast(datepart(dd, [Date]) as varchar(2))
	--END [SchoolForce__Due_Date__c], 
	End_Date__c [SchoolForce__Due_Date__c], 
	(select [Value] from [Data_Services_DEV].[dbo].[Settings] where [Name] = 'Grade.Picklist_Value') [SchoolForce__Picklist_Value__c], 
	1 [SchoolForce__Include_in_Final_Grade__c], 
	a.Marking_Period [SchoolForce__Name_in_Gradebook__c],
	100 [SchoolForce__Possible_Points__c], 
	j.ID [SchoolForce__Time__c], 
	f.SF_ID [SchoolForce__Section__c], 
	0 [SchoolForce__Weighting_Value__c],
	a.Student_ID,
	a.Class_Section_ID,
	a.Marking_Period,
	b.Assignment_Type_Normalized,
	a.Grade_Value SchoolForce__Grade_Number__c,
	f.Section_Type
	into #Temp_Grades1
	from Data_Services_DEV.dbo.Assignment_Grades (nolock) a 
	inner join Data_Services_DEV.dbo.Master_Assignment_Type (nolock) b on isnull(a.Assignment_Type, 'N/A') = isnull(b.Assignment_Type, 'N/A')
--	inner join (SELECT distinct [Picklist_Value__c],[Type__c] FROM [SDW_Stage_Dev].[dbo].[Assignment_Lib__c] ) c on b.Assignment_Type_Normalized = c.[Type__c]
	inner join Data_Services_DEV.dbo.Class_Processed (nolock) d on a.Class_Section_ID = d.Class_Section_ID and a.Student_ID = d.Student_ID
	inner join #Master_Assignment_Library (nolock) e on e.Marking_Period_2 = a.Marking_Period and e.Assignment_Type = b.Assignment_Type_Normalized and e.Section_Type_2 = d.Section_Type
	inner join Data_Services_DEV.dbo.Master_Section (nolock) f on a.Class_Section_ID = f.Class_Section_ID 
	--and f.Source_School_ID = substring(a.Class_Section_ID, 1, 4)
	inner join Data_Services_DEV.dbo.Master_Student (nolock) g on d.Student_ID = g.Student_ID 
	--and g.School_ID = substring(a.Class_Section_ID, 1, 4)
	inner join Data_Services_DEV.dbo.School_Lookup (nolock) h on g.SchoolForce__Setup__C = h.Setup_14_15
	inner join #Setup (nolock) i on h.Account_ID = i.[School__c]
	inner join #Time_Element (nolock) j on i.[Term__c] = j.[Parent_Time_Element__c]
	--left outer join SDW_Stage_Dev.dbo.SchoolForce__Assignment__c (nolock) k on a.Assignment_Name = k.Name and e.ID = k.SchoolForce__Assignment_Library__c and cast([SchoolForce__Due_Date__c] as date) = cast(k.SchoolForce__Due_Date__c as date) 
	--and j.ID = k.[SchoolForce__Time__c] and f.SF_ID = k.[SchoolForce__Section__c]
	where a.Marking_Period is not null 
	and (datepart(yyyy, i.[Year_Start__c]) = 2015 and datepart(yyyy, i.[Year_End__c]) = 2016)
	----and a.[Date] between cast([Date_Start_Date__c] as date) and cast([End_Date__c] as date)
	----and cast(a.Date as date) < getdate()
	and a.Marking_Period in ('Q1','Q2','Q3','Q4')
	and a.District = 'kcps'

	-- 331,999
	
	create nonclustered index #a on #Temp_Grades1(Student_ID)
	create nonclustered index #b on #Temp_Grades1(Class_Section_ID)
	create nonclustered index #c on #Temp_Grades1(SchoolForce__Section__c)
	create nonclustered index #d on #Temp_Grades1(Name)
	create nonclustered index #e on #Temp_Grades1(Assignment_Library__c)
	create nonclustered index #f on #Temp_Grades1(SchoolForce__Due_Date__c)
	create nonclustered index #g on #Temp_Grades1(SchoolForce__Section__c)
	create nonclustered index #h on #Temp_Grades1(SchoolForce__Name_in_Gradebook__c)
	create nonclustered index #i on #Temp_Grades1(Section_Type)
	create nonclustered index #j on #Temp_Grades1(SchoolForce__Time__c)

	delete from Data_Services_DEV.dbo.SF_Grade

	insert into Data_Services_DEV.dbo.SF_Grade(SchoolForce__Assignment__c, SchoolForce__Assignment_Weighting__c, SchoolForce__Course__c, SchoolForce__Grade_Number__c, SchoolForce__Points_Grade__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Student__c, SchoolForce__Student_Section__c, SchoolForce__Valid_Grade__c)
	select 
	d.SF_ID SchoolForce__Assignment__c,
	1 SchoolForce__Assignment_Weighting__c,
	e.ID SchoolForce__Course__c, 
	a.SchoolForce__Grade_Number__c SchoolForce__Grade_Number__c,
	0 SchoolForce__Points_Grade__c,
	100 SchoolForce__Possible_Points__c,
	a.SchoolForce__Time__c,
	b.SF_ID SchoolForce__Student__c,
	c.ID SchoolForce__Student_Section__c,
	1 SchoolForce__Valid_Grade__c
	from #Temp_Grades1 (nolock) a 
	inner join Data_Services_DEV.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join Data_Services_DEV.dbo.Master_Student_Section (nolock) c on a.SchoolForce__Section__c = c.SchoolForce__Section__c and b.SF_ID = c.SchoolForce__Student__c
	inner join Data_Services_DEV.dbo.Master_Assignment (nolock) d on a.Name = d.Name 
			and a.Assignment_Library__c = d.Assignment_Library__c 
			and cast(a.SchoolForce__Due_Date__c as date) = cast(d.SchoolForce__Due_Date__c as date) 
			and a.SchoolForce__Section__c = d.SchoolForce__Section__c 
			and a.SchoolForce__Name_in_Gradebook__c = d.SchoolForce__Name_in_Gradebook__c
	inner join #Course (nolock) e on a.Section_Type = e.Name
	left outer join Data_Services_DEV.dbo.Master_Grade (nolock) f 
			on d.SF_ID = f.SchoolForce__Assignment__c 
			and e.ID = f.SchoolForce__Course__c 
			and a.SchoolForce__Time__c = f.SchoolForce__Time__c
			and b.SF_ID = f.SchoolForce__Student__c 
			and c.ID = f.SchoolForce__Student_Section__c
	where f.SchoolForce__Assignment__c is null and f.SchoolForce__Course__c is null and f.SchoolForce__Time__c is null and f.SchoolForce__Student__c is null and f.SchoolForce__Student_Section__c is null 
	and e.Reference_Id__c like '%CY%'
	
	update Data_Services_DEV.dbo.SF_Grade set [SchoolForce__External_Id__c] = 'KCPS_' + cast(ID as varchar(10))

	insert into Data_Services_DEV.dbo.SF_Grade(SchoolForce__Assignment__c, SchoolForce__Assignment_Weighting__c, SchoolForce__Course__c, SchoolForce__Grade_Number__c, SchoolForce__Points_Grade__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Student__c, SchoolForce__Student_Section__c, SchoolForce__Valid_Grade__c, SchoolForce__External_Id__c)
	select 	
	d.SF_ID SchoolForce__Assignment__c,
	1 SchoolForce__Assignment_Weighting__c,
	e.ID SchoolForce__Course__c, 
	a.SchoolForce__Grade_Number__c SchoolForce__Grade_Number__c,
	0 SchoolForce__Points_Grade__c,
	100 SchoolForce__Possible_Points__c,
	a.SchoolForce__Time__c,
	b.SF_ID SchoolForce__Student__c,
	c.ID SchoolForce__Student_Section__c,
	1 SchoolForce__Valid_Grade__c,
	f.SchoolForce__External_Id__c
	from #Temp_Grades1 (nolock) a 
	inner join Data_Services_DEV.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join Data_Services_DEV.dbo.Master_Student_Section (nolock) c on a.SchoolForce__Section__c = c.SchoolForce__Section__c and b.SF_ID = c.SchoolForce__Student__c
	inner join Data_Services_DEV.dbo.Master_Assignment (nolock) d on a.Name = d.Name 
		and a.Assignment_Library__c = d.Assignment_Library__c 
		and cast(a.SchoolForce__Due_Date__c as date) = cast(d.SchoolForce__Due_Date__c as date)  
		and a.SchoolForce__Section__c = d.SchoolForce__Section__c 
		and a.SchoolForce__Name_in_Gradebook__c = d.SchoolForce__Name_in_Gradebook__c
	inner join #Course (nolock) e on a.Section_Type = e.Name
	inner join Data_Services_DEV.dbo.Master_Grade (nolock) f on d.SF_ID = f.SchoolForce__Assignment__c and e.ID = f.SchoolForce__Course__c and a.SchoolForce__Time__c = f.SchoolForce__Time__c
	and b.SF_ID = f.SchoolForce__Student__c and c.ID = f.SchoolForce__Student_Section__c
	where a.SchoolForce__Grade_Number__c <> f.SchoolForce__Grade_Number__c and e.Reference_Id__c like '%CY%'

	END
IF @DISTRICT = 'SJ'
BEGIN

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

	select * into #Course1 from SDW_Stage_Prod_17.dbo.Course__c (nolock)
	create nonclustered index #a on #Course1(Name)

select distinct 
	Assignment_Name Name, 
	e.ID Assignment_Library__c, 
	end_Date__c [SchoolForce__Due_Date__c], 
	(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'Grade.Picklist_Value') [SchoolForce__Picklist_Value__c], 
	1 [SchoolForce__Include_in_Final_Grade__c], 
	a.Marking_Period [SchoolForce__Name_in_Gradebook__c],
	100 [SchoolForce__Possible_Points__c], 
	j.ID [SchoolForce__Time__c], 
	f.SF_ID [SchoolForce__Section__c], 
	0 [SchoolForce__Weighting_Value__c],
	a.Student_ID,
	a.Class_Section_ID,
	a.Marking_Period,
	b.Assignment_Type_Normalized,
	isnull(a.Grade_Value, 0) SchoolForce__Grade_Number__c,
	f.Section_Type
	into #Temp_Grades2
	from Data_Services.dbo.Assignment_Grades (nolock) a 
	inner join Data_Services.dbo.Master_Assignment_Type (nolock) b on isnull(a.Assignment_Type, 'N/A') = isnull(b.Assignment_Type, 'N/A') --and a.District = 'SJ'
--	inner join (SELECT distinct [Picklist_Value__c],[Type__c] FROM [sdw_stage_prod].[dbo].[Assignment_Lib__c] ) c on b.Assignment_Type_Normalized = c.[Type__c]
	inner join Data_Services.dbo.Class_Processed (nolock) d on a.Class_Section_ID = d.Class_Section_ID and a.Student_ID = d.Student_ID and a.District = 'sj'
	inner join #Master_Assignment_Library1 (nolock) e on e.Marking_Period_2 = a.Marking_Period and e.Assignment_Type = b.Assignment_Type_Normalized and e.Section_Type_2 = d.Section_Type
	inner join Data_Services.dbo.Master_Student (nolock) g on d.Student_ID = g.Student_ID 
	inner join Data_Services.dbo.Master_Section (nolock) f on a.Class_Section_ID = f.Class_Section_ID and f.source_school_id = g.school_id
	inner join Data_Services.dbo.School_Lookup_16_17 (nolock) h on g.SchoolForce__Setup__C = h.Setup_14_15 and h.Source_School_ID = g.School_ID
	inner join #Setup1 (nolock) i on h.Account_ID = i.[School__c]
	inner join #Time_Element1 (nolock) j on 
	(i.[Term__c] = j.[Parent_Time_Element__c] AND a.Marking_Period = REPLACE(j.Name__c,'Quarter ','Q')) or
 (i.[Term__c] = j.[Parent_Time_Element__c] AND a.Marking_Period = REPLACE(j.Name__c,'Trimester ','T')) or
 (i.[Term__c] = j.[Parent_Time_Element__c] AND a.Marking_Period = REPLACE(j.Name__c,'Semester ','S'))
	--left outer join sdw_stage_prod.dbo.SchoolForce__Assignment__c (nolock) k on a.Assignment_Name = k.Name and e.ID = k.SchoolForce__Assignment_Library__c and cast([SchoolForce__Due_Date__c] as date) = cast(k.SchoolForce__Due_Date__c as date) 
	--and j.ID = k.[SchoolForce__Time__c] and f.SF_ID = k.[SchoolForce__Section__c]
	where a.Marking_Period is not null 
	and (datepart(yyyy, i.[Year_Start__c]) = 2016 and datepart(yyyy, i.[Year_End__c]) = 2017)
	--and a.[Date] between cast([Date_Start_Date__c] as date) and cast([End_Date__c] as date)
	--and cast(a.Date as date) < getdate()
	--and a.Marking_Period in ('Q1','Q2','Q3','Q4') 
	and a.District = 'SJ'
	-- 331,999
	
	create nonclustered index #a on #Temp_Grades2(Student_ID)
	create nonclustered index #b on #Temp_Grades2(Class_Section_ID)
	create nonclustered index #c on #Temp_Grades2(SchoolForce__Section__c)
	create nonclustered index #d on #Temp_Grades2(Name)
	create nonclustered index #e on #Temp_Grades2(Assignment_Library__c)
	create nonclustered index #f on #Temp_Grades2(SchoolForce__Due_Date__c)
	create nonclustered index #g on #Temp_Grades2(SchoolForce__Section__c)
	create nonclustered index #h on #Temp_Grades2(SchoolForce__Name_in_Gradebook__c)
	create nonclustered index #i on #Temp_Grades2(Section_Type)
	create nonclustered index #j on #Temp_Grades2(SchoolForce__Time__c)

	delete from Data_Services.dbo.SF_Grade where SchoolForce__External_Id__c like 'sj%'

	insert into Data_Services.dbo.SF_Grade(SchoolForce__Assignment__c, SchoolForce__Assignment_Weighting__c, SchoolForce__Course__c, SchoolForce__Grade_Number__c, SchoolForce__Points_Grade__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Student__c, SchoolForce__Student_Section__c, SchoolForce__Valid_Grade__c)
	select DISTINCT 
	d.SF_ID SchoolForce__Assignment__c,
	1 SchoolForce__Assignment_Weighting__c,
	e.ID SchoolForce__Course__c, 
	isnull(a.SchoolForce__Grade_Number__c, 0) SchoolForce__Grade_Number__c,
	0 SchoolForce__Points_Grade__c,
	100 SchoolForce__Possible_Points__c,
	a.SchoolForce__Time__c,
	b.SF_ID SchoolForce__Student__c,
	c.ID SchoolForce__Student_Section__c,
	1 SchoolForce__Valid_Grade__c
	from #Temp_Grades2 (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID --and rtrim(SUBSTRING(a.Class_Section_ID, 0, 5)) = b.School_ID
	inner join Data_Services.dbo.Master_Student_Section (nolock) c on a.SchoolForce__Section__c = c.SchoolForce__Section__c and b.SF_ID = c.SchoolForce__Student__c
	inner join Data_Services.dbo.Master_Assignment (nolock) d 
			on a.Name = d.Name 
			and a.Assignment_Library__c = d.Assignment_Library__c 
			and cast(a.SchoolForce__Due_Date__c as date) = cast(d.SchoolForce__Due_Date__c as date) 
			and a.SchoolForce__Section__c = d.SchoolForce__Section__c 
			and a.SchoolForce__Name_in_Gradebook__c = d.SchoolForce__Name_in_Gradebook__c
	inner join #Course1 (nolock) e on a.Section_Type = e.Name
	left outer join Data_Services.dbo.Master_Grade (nolock) f 
			on d.SF_ID = f.SchoolForce__Assignment__c 
			and e.ID = f.SchoolForce__Course__c 
			and a.SchoolForce__Time__c = f.SchoolForce__Time__c
			and b.SF_ID = f.SchoolForce__Student__c 
			and c.ID = f.SchoolForce__Student_Section__c
	where f.SchoolForce__Assignment__c is null and f.SchoolForce__Course__c is null and f.SchoolForce__Time__c is null and f.SchoolForce__Student__c is null and f.SchoolForce__Student_Section__c is null 
	and e.Reference_Id__c like '%CY%'
	
	update Data_Services.dbo.SF_Grade set [SchoolForce__External_Id__c] = 'SJ_' + cast(ID as varchar(10))
	where [SchoolForce__External_Id__c] is null

	insert into Data_Services.dbo.SF_Grade(SchoolForce__Assignment__c, SchoolForce__Assignment_Weighting__c, SchoolForce__Course__c, SchoolForce__Grade_Number__c, SchoolForce__Points_Grade__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Student__c, SchoolForce__Student_Section__c, SchoolForce__Valid_Grade__c, SchoolForce__External_Id__c)
	select 	DISTINCT 
	d.SF_ID SchoolForce__Assignment__c,
	1 SchoolForce__Assignment_Weighting__c,
	e.ID SchoolForce__Course__c, 
	isnull(a.SchoolForce__Grade_Number__c, 0) SchoolForce__Grade_Number__c,
	0 SchoolForce__Points_Grade__c,
	100 SchoolForce__Possible_Points__c,
	a.SchoolForce__Time__c,
	b.SF_ID SchoolForce__Student__c,
	c.ID SchoolForce__Student_Section__c,
	1 SchoolForce__Valid_Grade__c,
	f.SchoolForce__External_Id__c
	from #Temp_Grades2 (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join Data_Services.dbo.Master_Student_Section (nolock) c on a.SchoolForce__Section__c = c.SchoolForce__Section__c and b.SF_ID = c.SchoolForce__Student__c
	inner join Data_Services.dbo.Master_Assignment (nolock) d 
		on a.Name = d.Name 
		and a.Assignment_Library__c = d.Assignment_Library__c 
		and dateadd(yy, 1, cast(a.SchoolForce__Due_Date__c as date)) = cast(d.SchoolForce__Due_Date__c as date) 
		and a.SchoolForce__Section__c = d.SchoolForce__Section__c 
		and a.SchoolForce__Name_in_Gradebook__c = d.SchoolForce__Name_in_Gradebook__c
	inner join #Course1 (nolock) e on a.Section_Type = e.Name
	inner join Data_Services.dbo.Master_Grade (nolock) f on d.SF_ID = f.SchoolForce__Assignment__c and e.ID = f.SchoolForce__Course__c and a.SchoolForce__Time__c = f.SchoolForce__Time__c
	and b.SF_ID = f.SchoolForce__Student__c and c.ID = f.SchoolForce__Student_Section__c
	where a.SchoolForce__Grade_Number__c <> f.SchoolForce__Grade_Number__c and e.Reference_Id__c like '%CY%'

	update SF_grade set schoolforce__grade_number__C = '100.00'
where schoolforce__grade_number__C = '1020.0000'
END
	update Data_Services.dbo.SF_Grade set SchoolForce__Entered_Grade__c = [SchoolForce__Grade_Number__c]

END

	-- 331,999
GO

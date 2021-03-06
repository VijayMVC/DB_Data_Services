USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_5_Section]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_5_Section] @District varchar(255) = 'Standard'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--delete from Data_Services.dbo.SF_Sections
	-- delete from Data_Services.dbo.Master_Section

	-- [Teacher Last Name] - [Section Name] - [Period] - [Indicator Area]

if @District = 'OCPS'
	BEGIN

	delete from Data_Services.dbo.SF_Sections where Salesforce__External_ID__c like 'OCPS%'

	insert into Data_Services.dbo.SF_Sections(Name, Salesforce__External_ID__c, SchoolForce__Active__c, SchoolForce__All_Grades__c, Schoolforce__Course__c, SchoolForce__Period__c, SchoolForce__Daily_Attendance__c, SchoolForce__Is_Section__c, Schoolforce__Reporting_Period__c, Schoolforce__School__c, Schoolforce__Time__c, SchoolForce__Number_of_Reporting_Periods__c, SchoolForce__Record_Type__c, SchoolForce__Color__c, SchoolForce__Text_Color__c)
	select distinct 
	case
	when len(
	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)) <= 80
	then 
		a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)
	else
		a.Teacher_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)
	END
	 as [Name], 
	b.District + '_' + a.Class_Section_ID + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID SalesForce__External_ID__c,
	'1' Active__c, 
	d.School_Grades All_Grades__c, 
	f.ID Course__c, 
	a.Section_Type Period__c, 
	'0' AS Daily_Attendance__c, 
	'1' AS Is_Section__c, 
	e.Reporting_Period__c,
	d.Account_ID AS School__c,
	j.Id AS Time__c, 
	Number_of_Reporting_Periods__c, 
	(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'Section.Record_Type') AS Record_Type__c, 
	-- 012E0000000UD8jIAG (OLD ID)
	'#BEBEBE' AS Color__c, 
	'#2F4F4F' AS Text_Color__c
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Student (nolock) b on a.Student_ID = b.Student_ID
	inner join SDW_Stage_Prod.dbo.Contact (nolock) c on replace(a.District + '_' + School_ID + '_' + substring(Teacher_Name, charindex(',', Teacher_Name) + 2, len(Teacher_Name) - charindex(',', Teacher_Name) - 1) + '_' + substring(Teacher_Name, 0, charindex(',', Teacher_Name)), ' ', '_') = c.ID__c
	INNER JOIN Data_Services.dbo.School_Lookup AS d ON b.School_ID = d.Source_School_ID 
	INNER JOIN (SELECT d.Id AS Reporting_Period__c, a.Setup_14_15 AS setup__c, [Year_Start__c], [Year_End__c], [Date_Start_Date__c], [End_Date__c] FROM Data_Services.dbo.School_Lookup AS a INNER JOIN SDW_Stage_Prod.dbo.Setup__c AS b ON a.Setup_14_15 = b.Id INNER JOIN SDW_Stage_Prod.dbo.Time_Element__c AS d ON b.Term__c = d.Parent_Time_Element__c where d.Name__c like '%Q1%') AS e ON d.Setup_14_15 = e.setup__c 
	INNER JOIN (SELECT Id, [Name] Course FROM SDW_Stage_Prod.dbo.Course__c (nolock) where [Reference_Id__c] like '%C%') as f ON a.Section_Type = f.Course 
	INNER JOIN SDW_Stage_Prod.dbo.Time_Element__c AS g ON e.Reporting_Period__c = g.Id 
	INNER JOIN SDW_Stage_Prod.dbo.Time_Element__c AS h ON h.Parent_Time_Element__c = g.Id 
	INNER JOIN SDW_Stage_Prod.dbo.Time_Element__c AS i ON g.Parent_Time_Element__c = i.Id 
	INNER JOIN SDW_Stage_Prod.dbo.Time_Element__c AS j ON i.Parent_Time_Element__c = j.Id 
	INNER JOIN (SELECT COUNT(Name) AS Number_of_Reporting_Periods__c, setup__c SchoolForce__setup__c FROM Data_Services.dbo.vw_LookUp_School_Reporting_Periods GROUP BY setup__c) k on d.Setup_14_15 = k.SchoolForce__setup__c
	left outer join Data_Services.dbo.Master_Section (nolock) l on b.District + '_' + b.School_ID + '_' + a.Class_Section_ID + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID
	where l.SF_Section_External_ID is null and a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type is not null
	and b.District = @District
	group by 
	case
	when len(
	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)) <= 80
	then 
		a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)
	else
		a.Teacher_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)
	END,
	b.District + '_' + a.Class_Section_ID + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID, d.School_Grades, e.Reporting_Period__c, f.ID, a.Section_Type, d.Account_ID, j.Id, Number_of_Reporting_Periods__c
	-- 395

--	update Data_Services.dbo.SF_Sections set Name = Name + ' - ' + cast(ID as varchar(10))
	END

If @District = 'KCPS'
	BEGIN
	delete from Data_Services.dbo.SF_Sections where Salesforce__External_ID__c like 'KCPS%'
	-- delete from Data_Services_DEV.dbo.Master_Section

	-- [Teacher Last Name] - [Section Name] - [Period] - [Indicator Area]

	insert into Data_Services.dbo.SF_Sections(Name
	, Salesforce__External_ID__c
	, SchoolForce__Active__c
	, SchoolForce__All_Grades__c
	, Schoolforce__Course__c
	, SchoolForce__Period__c
	, SchoolForce__Daily_Attendance__c
	, SchoolForce__Is_Section__c
	, Schoolforce__Reporting_Period__c
	, Schoolforce__School__c
	, Schoolforce__Time__c
	, SchoolForce__Number_of_Reporting_Periods__c
	, SchoolForce__Record_Type__c
	, SchoolForce__Color__c
	, SchoolForce__Text_Color__c)
	select distinct 
	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + a.Class_Section_ID + ' - '  + d.Source_School_Name as [Name], 
	b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID SalesForce__External_ID__c,
	'1' Active__c, 
	d.School_Grades All_Grades__c, 
	f.ID Course__c,
	a.Section_Type Period__c, 
	'0' AS Daily_Attendance__c, 
	'1' AS Is_Section__c, 
	e.Reporting_Period__c,
	d.Account_ID AS School__c,
	j.Id AS Time__c,
	Number_of_Reporting_Periods__c,
	(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'Section.Record_Type') AS Record_Type__c, 
	-- 012E0000000UD8jIAG (OLD ID)
	'#BEBEBE' AS Color__c, 
	'#2F4F4F' AS Text_Color__c
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Student (nolock) b on a.Student_ID = b.Student_ID
	inner join SDW_Stage_Prod_17.dbo.Contact (nolock) c on replace(a.District + '_' + School_ID + '_' + LEFT(a.Teacher_Name, charindex(' ', a.Teacher_Name)- 1) + '_' + substring(a.Teacher_Name, charindex(' ', a.Teacher_Name) + 1, len(a.Teacher_Name) - charindex('_', a.Teacher_Name)), ' ', '_') = c.ID__c
	INNER JOIN Data_Services.dbo.School_Lookup_16_17 AS d ON b.School_ID = d.Source_School_ID
	INNER JOIN (SELECT 
	d.Id AS Reporting_Period__c
	, a.Setup_14_15 AS setup__c
	, [Year_Start__c]
	, [Year_End__c]
	, [Date_Start_Date__c]
	, [End_Date__c] 
	FROM Data_Services.dbo.School_Lookup_16_17 AS a 
	INNER JOIN SDW_Stage_Prod_17.dbo.Setup__c AS b ON a.Setup_14_15 = b.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS d ON b.Term__c = d.Parent_Time_Element__c 
	where d.Name__c like '%Quarter%1%' or d.Name__c like '%Trimester%1%') AS e ON d.Setup_14_15 = e.setup__c 
	INNER JOIN (SELECT Id, [Name] Course FROM SDW_Stage_Prod_17.dbo.Course__c (nolock) where [Reference_Id__c] like '%C%') as f ON a.Section_Type = f.Course 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS g ON e.Reporting_Period__c = g.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS h ON h.Parent_Time_Element__c = g.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS i ON g.Parent_Time_Element__c = i.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS j ON i.Parent_Time_Element__c = j.Id 
	INNER JOIN (SELECT COUNT(Name) AS Number_of_Reporting_Periods__c, setup__c SchoolForce__setup__c FROM  Data_Services.dbo.vw_LookUp_School_Reporting_Periods2 GROUP BY setup__c) k on d.Setup_14_15 = k.SchoolForce__setup__c
	left outer join Data_Services.dbo.Master_Section (nolock) l on b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID
	where l.SF_Section_External_ID is null and a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type is not null and a.District = 'KCPS'
		group by 
/*	case
	when len(
	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)) <= 80
	then 
		a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)
	else
		a.Teacher_Name + ' - ' + isnull(a.Period, '0') + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID 
	+ ' - ' + SUBSTRING(a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) + 1) - CHARINDEX('-', a.Class_Section_ID, CHARINDEX('-', a.Class_Section_ID, 1) + 1) - 1)
	END,
*/
	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + a.Class_Section_ID + ' - '  + d.Source_School_Name, 
	b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID, d.School_Grades, e.Reporting_Period__c, f.ID, a.Section_Type, d.Account_ID, j.Id, Number_of_Reporting_Periods__c
	-- 395
	END
IF @district = '1STLN'
BEGIN

DELETE FROM Data_Services.dbo.SF_Sections WHERE LEFT([Salesforce__External_ID__c],LEN(@district)) = @district

INSERT INTO Data_Services.dbo.SF_Sections(Name
	, Salesforce__External_ID__c
	, SchoolForce__Active__c
	, SchoolForce__All_Grades__c
	, Schoolforce__Course__c
	, SchoolForce__Period__c
	, SchoolForce__Daily_Attendance__c
	, SchoolForce__Is_Section__c
	, Schoolforce__Reporting_Period__c
	, Schoolforce__School__c
	, Schoolforce__Time__c
	, SchoolForce__Number_of_Reporting_Periods__c
	, SchoolForce__Record_Type__c
	, SchoolForce__Color__c
	, SchoolForce__Text_Color__c)

SELECT DISTINCT a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID AS [Name]
	, b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID SalesForce__External_ID__c
	,'1' Active__c
	, d.School_Grades All_Grades__c
	, f.ID Course__c
	, a.Section_Type Period__c
	, '0' AS Daily_Attendance__c
	, '1' AS Is_Section__c
	, e.Reporting_Period__c
	, d.Account_ID AS School__c
	, j.Id AS Time__c
	, Number_of_Reporting_Periods__c
	, '012360000007jgwAAA' AS Record_Type__c
	, '#BEBEBE' AS Color__c
	, '#2F4F4F' AS Text_Color__c
	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID INNER JOIN
	SDW_Stage_Prod_17.dbo.Contact (NOLOCK) c ON 
		REPLACE(a.District + '_' + School_ID + '_' + SUBSTRING(Teacher_Name, 0, CHARINDEX(',', Teacher_Name))  + '_' + SUBSTRING(Teacher_Name, CHARINDEX(',', Teacher_Name) + 2, LEN(Teacher_Name) - CHARINDEX(',', Teacher_Name) - 1), ' ', '_') = c.ID__c INNER JOIN 
	Data_Services.dbo.School_Lookup_16_17 AS d ON
		b.School_ID = d.Source_School_ID INNER JOIN 
	
	(SELECT d.Id AS Reporting_Period__c
		, a.Setup_14_15 AS setup__c
		, [Year_Start__c]
		, [Year_End__c]
		, [Date_Start_Date__c]
		, [End_Date__c] 
	FROM Data_Services.dbo.School_Lookup_16_17 AS a INNER JOIN
	SDW_Stage_Prod_17.dbo.Setup__c AS b ON 
		a.Setup_14_15 = b.Id INNER JOIN 
	SDW_Stage_PROD_17.dbo.Time_Element__c AS d ON 
		b.Term__c = d.Parent_Time_Element__c
	WHERE d.Name__c LIKE '%Quarter%1%' OR d.Name__c LIKE '%Trimester%1%') AS e ON 
		d.Setup_14_15 = e.setup__c INNER JOIN 
		
	(SELECT Id
		, [Name] Course
	FROM SDW_Stage_Prod_17.dbo.Course__c (NOLOCK) 
	WHERE [Reference_Id__c] like '%C%') AS f ON 
		a.Section_Type = f.Course INNER JOIN 
	
	SDW_Stage_Prod_17.dbo.Time_Element__c AS g ON 
		e.Reporting_Period__c = g.Id INNER JOIN 
	SDW_Stage_Prod_17.dbo.Time_Element__c AS h ON 
		h.Parent_Time_Element__c = g.Id INNER JOIN 
	SDW_Stage_Prod_17.dbo.Time_Element__c AS i ON 
		g.Parent_Time_Element__c = i.Id INNER JOIN 
	SDW_Stage_Prod_17.dbo.Time_Element__c AS j ON 
		i.Parent_Time_Element__c = j.Id INNER JOIN 
	
	(SELECT COUNT(Name) AS Number_of_Reporting_Periods__c
		, setup__c SchoolForce__setup__c 
	FROM Data_Services.dbo.vw_LookUp_School_Reporting_Periods2 
	GROUP BY setup__c) k ON
		d.Setup_14_15 = k.SchoolForce__setup__c LEFT OUTER JOIN 
	
	Data_Services.dbo.Master_Section (NOLOCK) l ON b.District + '_' + b.School_ID + '_' + a.Class_Section_ID + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID
	WHERE l.SF_Section_External_ID IS NULL AND a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type IS NOT NULL AND
	a.District = '1STLN' 
	GROUP BY a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID
		, b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID
		, d.School_Grades
		, e.Reporting_Period__c
		, f.ID, a.Section_Type
		, d.Account_ID, j.Id
		, Number_of_Reporting_Periods__c

END

IF @district = 'LRA'
BEGIN

DELETE FROM Data_Services.dbo.SF_Sections WHERE LEFT([Salesforce__External_ID__c],LEN(@district)) = @district

INSERT INTO Data_Services.dbo.SF_Sections(Name
	, Salesforce__External_ID__c
	, SchoolForce__Active__c
	, SchoolForce__All_Grades__c
	, Schoolforce__Course__c
	, SchoolForce__Period__c
	, SchoolForce__Daily_Attendance__c
	, SchoolForce__Is_Section__c
	, Schoolforce__Reporting_Period__c
	, Schoolforce__School__c
	, Schoolforce__Time__c
	, SchoolForce__Number_of_Reporting_Periods__c
	, SchoolForce__Record_Type__c
	, SchoolForce__Color__c
	, SchoolForce__Text_Color__c)

SELECT DISTINCT a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID AS [Name]
	, b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID SalesForce__External_ID__c
	,'1' Active__c
	, d.School_Grades All_Grades__c
	, f.ID Course__c
	, a.Section_Type Period__c
	, '0' AS Daily_Attendance__c
	, '1' AS Is_Section__c
	, e.Reporting_Period__c
	, d.Account_ID AS School__c
	, j.Id AS Time__c
	, Number_of_Reporting_Periods__c
	, '012360000007jgwAAA' AS Record_Type__c
	, '#BEBEBE' AS Color__c
	, '#2F4F4F' AS Text_Color__c
	
	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID INNER JOIN
	SDW_Stage_Prod_17.dbo.Contact (NOLOCK) c ON /*districtCode_sourceSchoolID_LName_Fname*/ 
		REPLACE(a.District + '_' + School_ID + '_' +/*LastName*/ SUBSTRING(Teacher_Name, CHARINDEX(' ', Teacher_Name) + 1, LEN(Teacher_Name) - CHARINDEX(',', Teacher_Name) - 1)  + '_' + /*FirstName*/ SUBSTRING(Teacher_Name, 0, CHARINDEX(' ', Teacher_Name)), ' ', '_')= c.ID__c INNER JOIN
	Data_Services.dbo.School_Lookup_16_17 AS d ON
		b.School_ID = d.Source_School_ID INNER JOIN 
	
	(SELECT d.Id AS Reporting_Period__c
		, a.Setup_14_15 AS setup__c
		, [Year_Start__c]
		, [Year_End__c]
		, [Date_Start_Date__c]
		, [End_Date__c] 
	FROM Data_Services.dbo.School_Lookup_16_17 AS a INNER JOIN
	SDW_Stage_Prod_17.dbo.Setup__c AS b ON 
		a.Setup_14_15 = b.Id INNER JOIN 
	SDW_Stage_PROD_17.dbo.Time_Element__c AS d ON 
		b.Term__c = d.Parent_Time_Element__c
	WHERE d.Name__c LIKE '%Quarter%1%') AS e ON 
		d.Setup_14_15 = e.setup__c INNER JOIN 
		
	(SELECT Id
		, [Name] Course
	FROM SDW_Stage_Prod_17.dbo.Course__c (NOLOCK) 
	WHERE [Reference_Id__c] like '%C%') AS f ON 
		a.Section_Type = f.Course INNER JOIN 
	
	SDW_Stage_Prod_17.dbo.Time_Element__c AS g ON 
		e.Reporting_Period__c = g.Id INNER JOIN 
	SDW_Stage_Prod_17.dbo.Time_Element__c AS h ON 
		h.Parent_Time_Element__c = g.Id INNER JOIN 
	SDW_Stage_Prod_17.dbo.Time_Element__c AS i ON 
		g.Parent_Time_Element__c = i.Id INNER JOIN 
	SDW_Stage_Prod_17.dbo.Time_Element__c AS j ON 
		i.Parent_Time_Element__c = j.Id INNER JOIN 
	
	(SELECT COUNT(Name) AS Number_of_Reporting_Periods__c
		, setup__c SchoolForce__setup__c 
	FROM Data_Services.dbo.vw_LookUp_School_Reporting_Periods2 
	GROUP BY setup__c) k ON
		d.Setup_14_15 = k.SchoolForce__setup__c LEFT OUTER JOIN 
	
	Data_Services.dbo.Master_Section (NOLOCK) l ON b.District + '_' + b.School_ID + '_' + a.Class_Section_ID + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID
	WHERE l.SF_Section_External_ID IS NULL AND a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type IS NOT NULL AND
	a.District = 'LRA' 
	GROUP BY a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID
		, b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID
		, d.School_Grades
		, e.Reporting_Period__c
		, f.ID, a.Section_Type
		, d.Account_ID, j.Id
		, Number_of_Reporting_Periods__c

UPDATE Data_Services.dbo.SF_Sections SET Name = Convert(Varchar,ID) +'_'+ Name 
WHERE Salesforce__External_ID__c like 'LRA_%'

END

IF @district = 'LA'
BEGIN

DELETE FROM Data_Services.dbo.SF_Sections WHERE LEFT([Salesforce__External_ID__c],LEN(@district)) = @district

INSERT INTO Data_Services.dbo.SF_Sections(Name
	, Salesforce__External_ID__c
	, SchoolForce__Active__c
	, SchoolForce__All_Grades__c
	, Schoolforce__Course__c
	, SchoolForce__Period__c
	, SchoolForce__Daily_Attendance__c
	, SchoolForce__Is_Section__c
	, Schoolforce__Reporting_Period__c
	, Schoolforce__School__c
	, Schoolforce__Time__c
	, SchoolForce__Number_of_Reporting_Periods__c
	, SchoolForce__Record_Type__c
	, SchoolForce__Color__c
	, SchoolForce__Text_Color__c)

SELECT DISTINCT a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - '  +  d.Source_School_ID AS [Name]
	, b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_'  +  d.Source_School_ID SalesForce__External_ID__c
	,'1' Active__c
	, d.School_Grades All_Grades__c
	, f.ID Course__c
	, a.Section_Type Period__c
	, '0' AS Daily_Attendance__c
	, '1' AS Is_Section__c
	, e.Reporting_Period__c
	, d.Account_ID AS School__c
	, j.Id AS Time__c
	, Number_of_Reporting_Periods__c
	, '012360000007jgwAAA' AS Record_Type__c
	--, (SELECT [Value] FROM [Data_Services].[dbo].[Settings] WHERE [Name] = 'Section.Record_Type') AS Record_Type__c
	, '#BEBEBE' AS Color__c
	, '#2F4F4F' AS Text_Color__c
	
	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID INNER JOIN
	SDW_Stage_Prod_17.dbo.Contact (NOLOCK) c ON 
		REPLACE(a.District + '_' + School_ID + '_' + SUBSTRING(Teacher_Name, CHARINDEX(',', Teacher_Name) + 2, LEN(Teacher_Name) - CHARINDEX(',', Teacher_Name) - 1) + '_' + SUBSTRING(Teacher_Name, 0, CHARINDEX(',', Teacher_Name)), ' ', '_') = c.ID__c INNER JOIN 
	Data_Services.dbo.School_Lookup_16_17 AS d ON
		b.School_ID = d.Source_School_ID INNER JOIN 
	
	(SELECT d.Id AS Reporting_Period__c
		, a.Setup_14_15 AS setup__c
		, [Year_Start__c]
		, [Year_End__c]
		, [Date_Start_Date__c]
		, [End_Date__c] 
	FROM Data_Services.dbo.School_Lookup_16_17 AS a INNER JOIN
	SDW_Stage_PROD_17.dbo.Setup__c AS b ON 
		a.Setup_14_15 = b.Id INNER JOIN 
	SDW_Stage_PROD_17.dbo.Time_Element__c AS d ON 
		b.Term__c = d.Parent_Time_Element__c
	WHERE d.Name__c LIKE '%Quarter%1%' OR d.Name__c LIKE '%Trimester%1%') AS e ON 
		d.Setup_14_15 = e.setup__c INNER JOIN 
		
	(SELECT Id
		, [Name] Course
	FROM SDW_Stage_Prod_17.dbo.Course__c (NOLOCK) 
	WHERE [Reference_Id__c] like '%C%') AS f ON 
		a.Section_Type = f.Course INNER JOIN 
	
	SDW_Stage_PROD_17.dbo.Time_Element__c AS g ON 
		e.Reporting_Period__c = g.Id INNER JOIN 
	SDW_Stage_PROD_17.dbo.Time_Element__c AS h ON 
		h.Parent_Time_Element__c = g.Id INNER JOIN 
	SDW_Stage_PROD_17.dbo.Time_Element__c AS i ON 
		g.Parent_Time_Element__c = i.Id INNER JOIN 
	SDW_Stage_PROD_17.dbo.Time_Element__c AS j ON 
		i.Parent_Time_Element__c = j.Id INNER JOIN 
	
	(SELECT COUNT(Name) AS Number_of_Reporting_Periods__c
		, setup__c SchoolForce__setup__c 
	FROM Data_Services.dbo.vw_LookUp_School_Reporting_Periods2 
	GROUP BY setup__c) k ON
		d.Setup_14_15 = k.SchoolForce__setup__c LEFT OUTER JOIN 
	
	Data_Services.dbo.Master_Section (NOLOCK) l ON b.District + '_' + b.School_ID + '_' + a.Class_Section_ID + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID
	WHERE l.SF_Section_External_ID IS NULL AND a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type IS NOT NULL AND
	a.District = 'LA'
	 
	GROUP BY a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID
		, b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + REPLACE(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID
		, d.School_Grades
		, e.Reporting_Period__c
		, f.ID, a.Section_Type
		, d.Account_ID, j.Id
		, Number_of_Reporting_Periods__c

UPDATE Data_Services.dbo.SF_Sections SET Name = Convert(Varchar,ID) + '_' + Name
WHERE Salesforce__External_ID__c LIKE 'LA_%'
END
	
IF @district = 'SJ'
BEGIN
	
	delete from Data_Services.dbo.SF_Sections where Salesforce__External_ID__c like 'SJ%'

	insert into Data_Services.dbo.SF_Sections(Name, Salesforce__External_ID__c, SchoolForce__Active__c, SchoolForce__All_Grades__c, Schoolforce__Course__c, SchoolForce__Period__c, SchoolForce__Daily_Attendance__c, SchoolForce__Is_Section__c, Schoolforce__Reporting_Period__c, Schoolforce__School__c, Schoolforce__Time__c, SchoolForce__Number_of_Reporting_Periods__c, SchoolForce__Record_Type__c, SchoolForce__Color__c, SchoolForce__Text_Color__c)
	select distinct 
	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID
	 as [Name], 
	b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID SalesForce__External_ID__c,
	'1' Active__c, 
	d.School_Grades All_Grades__c, 
	f.ID Course__c, 
	a.Section_Type Period__c, 
	'0' AS Daily_Attendance__c, 
	'1' AS Is_Section__c, 
	e.Reporting_Period__c,
	d.Account_ID AS School__c,
	j.Id AS Time__c, 
	Number_of_Reporting_Periods__c,--, e.name__C,
	'012360000007jgwAAA' AS Record_Type__c, 
	-- 012E0000000UD8jIAG (OLD ID)
	'#BEBEBE' AS Color__c, 
	'#2F4F4F' AS Text_Color__c
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Student (nolock) b on a.Student_ID = b.Student_ID and a.district = 'sj'
	inner join sdw_stage_prod_17.dbo.Contact (nolock) c on replace(a.District + '_' + School_ID + '_' + substring(Teacher_Name, charindex(',', Teacher_Name) + 2, len(Teacher_Name) - charindex(',', Teacher_Name) - 1) + '_' + substring(Teacher_Name, 0, charindex(',', Teacher_Name)), ' ', '_') = c.ID__c
	INNER JOIN Data_Services.dbo.School_Lookup_16_17 AS d ON b.School_ID = d.Source_School_ID 
	INNER JOIN (SELECT d.Id AS Reporting_Period__c, a.Setup_14_15 AS setup__c, [Year_Start__c], [Year_End__c], [Date_Start_Date__c], [End_Date__c] FROM Data_Services.dbo.School_Lookup_16_17 AS a INNER JOIN sdw_stage_prod_17.dbo.Setup__c AS b ON a.Setup_14_15 = b.Id INNER JOIN sdw_stage_prod_17.dbo.Time_Element__c AS d ON b.Term__c = d.Parent_Time_Element__c 
	where d.Name__c like '%Semester%1%' or d.Name__c like '%Quarter%1%' or d.Name__c like '%Trimester%1%' )--or d.Name__c like '%Semester%1%') --or d.Name__c like '%Trimester%3%'
	--or d.Name__c like '%Quarter%4%' or d.Name__c like '%Semester%1%' or d.Name__c like '%Trimester%2%'
--	or d.Name__c like '%Quarter%1%' or d.Name__c like '%Trimester%1%') 
	AS e ON d.Setup_14_15 = e.setup__c 
	INNER JOIN (SELECT Id, [Name] Course FROM sdw_stage_prod_17.dbo.Course__c (nolock) where [Reference_Id__c] like '%C%') as f ON a.Section_Type = f.Course 
	INNER JOIN sdw_stage_prod_17.dbo.Time_Element__c AS g ON e.Reporting_Period__c = g.Id 
	INNER JOIN sdw_stage_prod_17.dbo.Time_Element__c AS h ON h.Parent_Time_Element__c = g.Id 
	INNER JOIN sdw_stage_prod_17.dbo.Time_Element__c AS i ON g.Parent_Time_Element__c = i.Id 
	INNER JOIN sdw_stage_prod_17.dbo.Time_Element__c AS j ON i.Parent_Time_Element__c = j.Id 
	INNER JOIN (SELECT COUNT(Name) AS Number_of_Reporting_Periods__c, setup__c SchoolForce__setup__c FROM Data_Services.dbo.vw_LookUp_School_Reporting_Periods2 GROUP BY setup__c) k on d.Setup_14_15 = k.SchoolForce__setup__c
	left outer join Data_Services.dbo.Master_Section (nolock) l on  a.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID 
	where l.SF_Section_External_ID is null and a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type is not null and a.District = 'SJ'
	group by 

	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID,
	b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID, d.School_Grades, e.Reporting_Period__c, f.ID, a.Section_Type, d.Account_ID, j.Id, Number_of_Reporting_Periods__c
	-- 395



	END
		IF @district = 'MKE'
BEGIN
	
	delete from Data_services.dbo.SF_Sections where Salesforce__External_ID__c like 'MKE%'


	insert into Data_services.dbo.SF_Sections(Name, Salesforce__External_ID__c, SchoolForce__Active__c, SchoolForce__All_Grades__c, Schoolforce__Course__c, SchoolForce__Period__c, SchoolForce__Daily_Attendance__c, SchoolForce__Is_Section__c, Schoolforce__Reporting_Period__c, Schoolforce__School__c, Schoolforce__Time__c, SchoolForce__Number_of_Reporting_Periods__c, SchoolForce__Record_Type__c, SchoolForce__Color__c, SchoolForce__Text_Color__c)
	select distinct 
	a.Teacher_Name + ' - '+ a.Class_Section_ID + '-'  + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID
	 as [Name], 
	b.District + '_' + a.Class_Section_ID + '_' + a.Period + ' - ' + a.Class_Period_Name + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID SalesForce__External_ID__c,
	'1' Active__c, 
	d.School_Grades All_Grades__c, 
	f.ID Course__c, 
	a.Section_Type Period__c, 
	'0' AS Daily_Attendance__c, 
	'1' AS Is_Section__c, 
	e.Reporting_Period__c,
	d.Account_ID AS School__c,
	j.Id AS Time__c, 
	Number_of_Reporting_Periods__c,--, e.name__C,
	'012360000007jgwAAA' AS Record_Type__c, 
	-- 012E0000000UD8jIAG (OLD ID)
	'#BEBEBE' AS Color__c, 
	'#2F4F4F' AS Text_Color__c
	from Data_services.dbo.Class_Processed (nolock) a 
	inner join Data_services.dbo.Student (nolock) b on a.Student_ID = b.Student_ID
	inner join SDW_Stage_Prod_17.dbo.Contact (nolock) c on replace(a.District + '_' + School_ID + '_' +LTRIM(RTRIM(SUBSTRING(Teacher_Name, CHARINDEX(' ', Teacher_Name)+1, 8000)))  + '_' + LTRIM(RTRIM(SUBSTRING(Teacher_Name, 0, CHARINDEX(' ', Teacher_Name)))), ' ', '_') = c.ID__c
	INNER JOIN Data_services.dbo.School_Lookup_16_17 AS d ON b.School_ID = d.Source_School_ID 
	INNER JOIN (SELECT d.Id AS Reporting_Period__c, a.Setup_14_15 AS setup__c, [Year_Start__c], [Year_End__c], [Date_Start_Date__c], [End_Date__c] FROM Data_services.dbo.School_Lookup_16_17 AS a INNER JOIN SDW_Stage_Prod_17.dbo.Setup__c AS b ON a.Setup_14_15 = b.Id INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS d ON b.Term__c = d.Parent_Time_Element__c 
	where d.Name__c like '%Semester%1%' or d.Name__c like '%Quarter%1%' or d.Name__c like '%Trimester%1%' )--or d.Name__c like '%Semester%1%') --or d.Name__c like '%Trimester%3%'
	--or d.Name__c like '%Quarter%4%' or d.Name__c like '%Semester%1%' or d.Name__c like '%Trimester%2%'
--	or d.Name__c like '%Quarter%1%' or d.Name__c like '%Trimester%1%') 
	AS e ON d.Setup_14_15 = e.setup__c 
	INNER JOIN (SELECT Id, [Name] Course FROM SDW_Stage_Prod_17.dbo.Course__c (nolock) where [Reference_Id__c] like '%C%') as f ON a.Section_Type = f.Course 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS g ON e.Reporting_Period__c = g.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS h ON h.Parent_Time_Element__c = g.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS i ON g.Parent_Time_Element__c = i.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS j ON i.Parent_Time_Element__c = j.Id 
	INNER JOIN (SELECT COUNT(Name) AS Number_of_Reporting_Periods__c, setup__c SchoolForce__setup__c FROM Data_services.dbo.vw_LookUp_School_Reporting_Periods2 GROUP BY setup__c) k on d.Setup_14_15 = k.SchoolForce__setup__c
	left outer join Data_services.dbo.Master_Section (nolock) l on b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID
	where l.SF_Section_External_ID is null and a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type is not null and a.District = 'MKE'
	group by 

	a.Teacher_Name + ' - ' + a.Class_Section_ID + '-' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID,
	b.District + '_' + a.Class_Section_ID + '_' + a.Period +  ' - ' + a.Class_Period_Name + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID, d.School_Grades, e.Reporting_Period__c, f.ID, a.Section_Type, d.Account_ID, j.Id, Number_of_Reporting_Periods__c

--	update Data_services.dbo.SF_Sections set Name = Name + ' - ' + cast(ID as varchar(10))

	END
	IF @district = 'CLM'
BEGIN
	
	delete from Data_services.dbo.SF_Sections where Salesforce__External_ID__c like 'CLM%'


	insert into Data_services.dbo.SF_Sections(Name, Salesforce__External_ID__c, SchoolForce__Active__c, SchoolForce__All_Grades__c, Schoolforce__Course__c, SchoolForce__Period__c, SchoolForce__Daily_Attendance__c, SchoolForce__Is_Section__c, Schoolforce__Reporting_Period__c, Schoolforce__School__c, Schoolforce__Time__c, SchoolForce__Number_of_Reporting_Periods__c, SchoolForce__Record_Type__c, SchoolForce__Color__c, SchoolForce__Text_Color__c)
	select distinct 
	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID
	 as [Name], 
	b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID SalesForce__External_ID__c,
	'1' Active__c, 
	d.School_Grades All_Grades__c, 
	f.ID Course__c, 
	a.Section_Type Period__c, 
	'0' AS Daily_Attendance__c, 
	'1' AS Is_Section__c, 
	e.Reporting_Period__c,
	d.Account_ID AS School__c,
	j.Id AS Time__c, 
	Number_of_Reporting_Periods__c,--, e.name__C,
	'012360000007jgwAAA' AS Record_Type__c, 
	-- 012E0000000UD8jIAG (OLD ID)
	'#BEBEBE' AS Color__c, 
	'#2F4F4F' AS Text_Color__c
	from Data_services.dbo.Class_Processed (nolock) a 
	inner join Data_services.dbo.Student (nolock) b on a.Student_ID = b.Student_ID and a.district = 'CLM'
	inner join SDW_Stage_Prod_17.dbo.Contact (nolock) c on C.ID__C LIKE 'CLM%' AND replace(a.District + '_' + School_ID + '_' + substring(Teacher_Name, charindex(',', Teacher_Name) + 2, len(Teacher_Name) - charindex(',', Teacher_Name) - 1) + '_' + substring(Teacher_Name, 0, charindex(',', Teacher_Name)), ' ', '_') = c.ID__c
	INNER JOIN Data_services.dbo.School_Lookup_16_17 AS d ON b.School_ID = d.Source_School_ID 
	INNER JOIN (SELECT d.Id AS Reporting_Period__c, a.Setup_14_15 AS setup__c, [Year_Start__c], [Year_End__c], [Date_Start_Date__c], [End_Date__c] FROM Data_services.dbo.School_Lookup_16_17 AS a INNER JOIN SDW_Stage_Prod_17.dbo.Setup__c AS b ON a.Setup_14_15 = b.Id INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS d ON b.Term__c = d.Parent_Time_Element__c 
	where d.Name__c like '%Semester%1%' or d.Name__c like '%Quarter%1%' or d.Name__c like '%Trimester%1%' )--or d.Name__c like '%Semester%1%') --or d.Name__c like '%Trimester%3%'
	--or d.Name__c like '%Quarter%4%' or d.Name__c like '%Semester%1%' or d.Name__c like '%Trimester%2%'
--	or d.Name__c like '%Quarter%1%' or d.Name__c like '%Trimester%1%') 
	AS e ON d.Setup_14_15 = e.setup__c 
	INNER JOIN (SELECT Id, [Name] Course FROM SDW_Stage_Prod_17.dbo.Course__c (nolock) where [Reference_Id__c] like '%C%') as f ON a.Section_Type = f.Course 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS g ON e.Reporting_Period__c = g.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS h ON h.Parent_Time_Element__c = g.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS i ON g.Parent_Time_Element__c = i.Id 
	INNER JOIN SDW_Stage_Prod_17.dbo.Time_Element__c AS j ON i.Parent_Time_Element__c = j.Id 
	INNER JOIN (SELECT COUNT(Name) AS Number_of_Reporting_Periods__c, setup__c SchoolForce__setup__c FROM Data_services.dbo.vw_LookUp_School_Reporting_Periods2 GROUP BY setup__c) k on d.Setup_14_15 = k.SchoolForce__setup__c
	left outer join Data_services.dbo.Master_Section (nolock) l on b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID = l.SF_Section_External_ID
	where l.SF_Section_External_ID is null and 
	 a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type is not null and a.District = 'CLM'
	group by 

	a.Teacher_Name + ' - ' + a.Class_Period_Name + ' - ' + a.Period + ' - ' + a.Section_Type + ' - ' + d.Source_School_ID,
	b.District + '_' + a.Class_Section_ID + '_' + a.Period + '_' + replace(a.Teacher_Last_Name, ' ', '_') + '_' + a.Teacher_First_Name + '_' + d.Source_School_ID, d.School_Grades, e.Reporting_Period__c, f.ID, a.Section_Type, d.Account_ID, j.Id, Number_of_Reporting_Periods__c

--	update Data_services.dbo.SF_Sections set Name = Name + ' - ' + cast(ID as varchar(10))

	END


END





GO

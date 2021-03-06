USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_7a_Student_Section]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_7a_Student_Section] @district varchar(256) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @district = 'SJ'
	BEGIN
	insert into Data_Services.dbo.Master_Student_Section(ID, SchoolForce__Section__c, SchoolForce__Student__c, SchoolForce__External_Id__c)
	select distinct  e.ID, c.SF_ID Section_ID, b.SF_ID Student_ID, b.SchoolForce__External_Id__c
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID and b.SchoolForce__External_Id__c like 'sj%'
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID, Source_School_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName and b.School_ID = c.Source_School_ID
	inner join sdw_stage_prod_17.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c
	left outer join Data_Services.dbo.Master_Student_Section (nolock) f on b.SF_ID = f.SchoolForce__Student__c and c.SF_ID = f.SchoolForce__Section__c
	where f.ID is null

Delete Data_Services.dbo.SF_Enrollment_Tracking

	insert into Data_Services.dbo.SF_Enrollment_Tracking(SchoolForce__Active__c, SchoolForce__Current_Record__c, SchoolForce__Start_Date__c, SchoolForce__Student_Section__c, SchoolForce__Student__c)
	select distinct 1 [SchoolForce__Active__c], 1 [SchoolForce__Current_Record__c], cast('7/1/2016' as date) [SchoolForce__Start_Date__c],
	e.ID [SchoolForce__Student_Section__c], b.SF_ID [SchoolForce__Student__c]
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID and b.SchoolForce__External_Id__c like 'sj%'
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID, Source_School_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName and b.School_ID = c.Source_School_ID
	inner join sdw_stage_prod_17.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c

		delete a
	from Data_Services.dbo.SF_Enrollment_Tracking (nolock) a
	inner join Data_Services.dbo.Master_Enrollment_Tracking (nolock) f on a.SchoolForce__Student__c = f.SchoolForce__Student__c and a.SchoolForce__Student_Section__c = f.SchoolForce__Student_Section__c

	update Data_Services.dbo.SF_Enrollment_Tracking
	set Reference_Id__c = SchoolForce__Student_Section__c + '_' + SchoolForce__Student__c
	where Reference_Id__c is null

	END

	IF @district = 'Standard'
	BEGIN

	insert into Data_Services.dbo.Master_Student_Section(ID, SchoolForce__Section__c, SchoolForce__Student__c, SchoolForce__External_Id__c)
	select e.ID, c.SF_ID Section_ID, b.SF_ID Student_ID, b.SchoolForce__External_Id__c
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName
	inner join sdw_stage_prod.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c
	left outer join Data_Services.dbo.Master_Student_Section (nolock) f on b.SF_ID = f.SchoolForce__Student__c and c.SF_ID = f.SchoolForce__Section__c
	where f.ID is null

Delete Data_Services.dbo.SF_Enrollment_Tracking

	insert into Data_Services.dbo.SF_Enrollment_Tracking(SchoolForce__Active__c, SchoolForce__Current_Record__c, SchoolForce__Start_Date__c, SchoolForce__Student_Section__c, SchoolForce__Student__c)
	select 1 [SchoolForce__Active__c], 1 [SchoolForce__Current_Record__c], cast('7/1/2015' as date) [SchoolForce__Start_Date__c],
	e.ID [SchoolForce__Student_Section__c], b.SF_ID [SchoolForce__Student__c]
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName
	inner join sdw_stage_prod.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c

	delete a
	from Data_Services.dbo.SF_Enrollment_Tracking (nolock) a
	inner join Data_Services.dbo.Master_Enrollment_Tracking (nolock) f on a.SchoolForce__Student__c = f.SchoolForce__Student__c and a.SchoolForce__Student_Section__c = f.SchoolForce__Student_Section__c

	update Data_Services.dbo.SF_Enrollment_Tracking
	set Reference_Id__c = SchoolForce__Student_Section__c + '_' + SchoolForce__Student__c
	where Reference_Id__c is null
	END


		IF @district = 'KCPS'
	BEGIN
	insert into Data_Services.dbo.Master_Student_Section(ID, SchoolForce__Section__c, SchoolForce__Student__c, SchoolForce__External_Id__c)
	select distinct  e.ID, c.SF_ID Section_ID, b.SF_ID Student_ID, b.SchoolForce__External_Id__c
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID and b.SchoolForce__External_Id__c like 'kcps%'
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID, Source_School_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName and b.School_ID = c.Source_School_ID
	inner join sdw_stage_prod_17.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c
	left outer join Data_Services.dbo.Master_Student_Section (nolock) f on b.SF_ID = f.SchoolForce__Student__c and c.SF_ID = f.SchoolForce__Section__c
	where f.ID is null

Delete Data_Services.dbo.SF_Enrollment_Tracking

	insert into Data_Services.dbo.SF_Enrollment_Tracking(SchoolForce__Active__c, SchoolForce__Current_Record__c, SchoolForce__Start_Date__c, SchoolForce__Student_Section__c, SchoolForce__Student__c)
	select distinct 1 [SchoolForce__Active__c], 1 [SchoolForce__Current_Record__c], cast('7/1/2016' as date) [SchoolForce__Start_Date__c],
	e.ID [SchoolForce__Student_Section__c], b.SF_ID [SchoolForce__Student__c]
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID and b.SchoolForce__External_Id__c like 'kcps%'
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID, Source_School_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName and b.School_ID = c.Source_School_ID
	inner join sdw_stage_prod_17.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c

		delete a
	from Data_Services.dbo.SF_Enrollment_Tracking (nolock) a
	inner join Data_Services.dbo.Master_Enrollment_Tracking (nolock) f on a.SchoolForce__Student__c = f.SchoolForce__Student__c and a.SchoolForce__Student_Section__c = f.SchoolForce__Student_Section__c

	update Data_Services.dbo.SF_Enrollment_Tracking
	set Reference_Id__c = SchoolForce__Student_Section__c + '_' + SchoolForce__Student__c
	where Reference_Id__c is null
END

IF @district = 'LA'
BEGIN

	INSERT INTO Data_Services.dbo.Master_Student_Section(ID
		, SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolForce__External_Id__c)

	SELECT DISTINCT  e.ID
	, c.SF_ID Section_ID
	, b.SF_ID Student_ID
	, b.SchoolForce__External_Id__c

	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID and b.SchoolForce__External_Id__c LIKE 'LA_%' INNER JOIN 
		
		(SELECT DISTINCT SF_ID
			, FirstName
			, LastName
			, Class_Section_ID
			, Source_School_ID 
		FROM Data_Services.dbo.Master_Section (NOLOCK)) c ON 
			a.Class_Section_ID = c.Class_Section_ID AND 
			LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName AND 
			LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName AND 
			b.School_ID = c.Source_School_ID INNER JOIN 
		sdw_stage_prod_17.dbo.Student_Section__c (NOLOCK) e ON 
		b.SF_ID = e.Student__c AND 
		c.SF_ID = e.Section__c LEFT OUTER JOIN 
		Data_Services.dbo.Master_Student_Section (NOLOCK) f ON 
		b.SF_ID = f.SchoolForce__Student__c AND 
		c.SF_ID = f.SchoolForce__Section__c
		WHERE f.ID IS NULL
	
	DELETE Data_Services.dbo.SF_Enrollment_Tracking 
	WHERE SchoolForce__Student_Section__c IN 
	(SELECT ID FROM dbo.Master_Student_Section 
		WHERE SchoolForce__External_Id__c LIKE 'LA_%')
	
	INSERT INTO Data_Services.dbo.SF_Enrollment_Tracking(SchoolForce__Active__c
		, SchoolForce__Current_Record__c
		, SchoolForce__Start_Date__c
		, SchoolForce__Student_Section__c
		, SchoolForce__Student__c)
	SELECT DISTINCT 1 [SchoolForce__Active__c]
		, 1 [SchoolForce__Current_Record__c]
		, CAST('7/1/2016' AS DATE) [SchoolForce__Start_Date__c]
		, e.ID [SchoolForce__Student_Section__c]
		, b.SF_ID [SchoolForce__Student__c]
	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID AND 
		b.SchoolForce__External_Id__c LIKE 'LA_%'
	inner join (SELECT DISTINCT SF_ID
		, FirstName
		, LastName
		, Class_Section_ID
		, Source_School_ID 
		from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName and b.School_ID = c.Source_School_ID
	inner join sdw_stage_prod_17.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c


End
IF @district = 'LRA'
BEGIN

	INSERT INTO Data_Services.dbo.Master_Student_Section(ID
		, SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolForce__External_Id__c)

	SELECT DISTINCT  e.ID
	, c.SF_ID Section_ID
	, b.SF_ID Student_ID
	, b.SchoolForce__External_Id__c

	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID and b.SchoolForce__External_Id__c like 'LRA_%' INNER JOIN 
		
		(SELECT DISTINCT SF_ID
			, FirstName
			, LastName
			, Class_Section_ID
			, Source_School_ID 
		FROM Data_Services.dbo.Master_Section (NOLOCK)) c ON 
			a.Class_Section_ID = c.Class_Section_ID AND 
			LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName AND 
			LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName AND 
			b.School_ID = c.Source_School_ID INNER JOIN 
		sdw_stage_prod_17.dbo.Student_Section__c (NOLOCK) e ON 
		b.SF_ID = e.Student__c AND 
		c.SF_ID = e.Section__c LEFT OUTER JOIN 
		Data_Services.dbo.Master_Student_Section (NOLOCK) f ON 
		b.SF_ID = f.SchoolForce__Student__c AND 
		c.SF_ID = f.SchoolForce__Section__c
		WHERE f.ID IS NULL
	
	DELETE Data_Services.dbo.SF_Enrollment_Tracking 
	WHERE SchoolForce__Student_Section__c IN 
	(SELECT ID FROM dbo.Master_Student_Section 
		WHERE SchoolForce__External_Id__c LIKE 'LRA_%')
	
	INSERT INTO Data_Services.dbo.SF_Enrollment_Tracking(SchoolForce__Active__c
		, SchoolForce__Current_Record__c
		, SchoolForce__Start_Date__c
		, SchoolForce__Student_Section__c
		, SchoolForce__Student__c)
	SELECT DISTINCT 1 [SchoolForce__Active__c]
		, 1 [SchoolForce__Current_Record__c]
		, CAST('7/1/2016' AS DATE) [SchoolForce__Start_Date__c]
		, e.ID [SchoolForce__Student_Section__c]
		, b.SF_ID [SchoolForce__Student__c]
	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID AND 
		b.SchoolForce__External_Id__c LIKE 'LRA_%'
	inner join (SELECT DISTINCT SF_ID
		, FirstName
		, LastName
		, Class_Section_ID
		, Source_School_ID 
		from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName and LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName and b.School_ID = c.Source_School_ID
	inner join sdw_stage_prod_17.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c and c.SF_ID = e.Section__c


End
IF @district = '1STLN'
BEGIN

	INSERT INTO Data_Services.dbo.Master_Student_Section(ID
		, SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolForce__External_Id__c)

	SELECT DISTINCT  e.ID
	, c.SF_ID Section_ID
	, b.SF_ID Student_ID
	, b.SchoolForce__External_Id__c

	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID and b.SchoolForce__External_Id__c like '1STLN_%' INNER JOIN 
		
		(SELECT DISTINCT SF_ID
			, FirstName
			, LastName
			, Class_Section_ID
			, Source_School_ID 
		FROM Data_Services.dbo.Master_Section (NOLOCK)) c ON 
			a.Class_Section_ID = c.Class_Section_ID AND 
			LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName AND 
			LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName AND 
			b.School_ID = c.Source_School_ID INNER JOIN 
		sdw_stage_prod_17.dbo.Student_Section__c (NOLOCK) e ON 
		b.SF_ID = e.Student__c AND 
		c.SF_ID = e.Section__c LEFT OUTER JOIN 
		Data_Services.dbo.Master_Student_Section (NOLOCK) f ON 
		b.SF_ID = f.SchoolForce__Student__c AND 
		c.SF_ID = f.SchoolForce__Section__c
		WHERE f.ID IS NULL
	
	DELETE Data_Services.dbo.SF_Enrollment_Tracking 
	WHERE SchoolForce__Student_Section__c IN 
	(SELECT ID FROM dbo.Master_Student_Section 
		WHERE SchoolForce__External_Id__c LIKE '1STLN_%')
	
	INSERT INTO Data_Services.dbo.SF_Enrollment_Tracking(SchoolForce__Active__c
		, SchoolForce__Current_Record__c
		, SchoolForce__Start_Date__c
		, SchoolForce__Student_Section__c
		, SchoolForce__Student__c)
	SELECT DISTINCT 1 [SchoolForce__Active__c]
		, 1 [SchoolForce__Current_Record__c]
		, CAST('7/1/2016' AS DATE) [SchoolForce__Start_Date__c]
		, e.ID [SchoolForce__Student_Section__c]
		, b.SF_ID [SchoolForce__Student__c]
	FROM Data_Services.dbo.Class_Processed (NOLOCK) a INNER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) b ON 
		a.Student_ID = b.Student_ID AND 
		b.SchoolForce__External_Id__c LIKE '1STLN_%'
	INNER JOIN (SELECT DISTINCT SF_ID
		, FirstName
		, LastName
		, Class_Section_ID
		, Source_School_ID 
		FROM Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID AND LTRIM(RTRIM(a.Teacher_First_Name)) = c.FirstName AND LTRIM(RTRIM(a.Teacher_Last_Name)) = c.LastName and b.School_ID = c.Source_School_ID
	INNER JOIN sdw_stage_prod_17.dbo.Student_Section__c (nolock) e on b.SF_ID = e.Student__c AND c.SF_ID = e.Section__c

END
END


GO

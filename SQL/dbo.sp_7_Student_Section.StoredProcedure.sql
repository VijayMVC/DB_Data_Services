USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_7_Student_Section]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_7_Student_Section] @District varchar(255) = 'Standard'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--delete from Data_Services.dbo.SF_Student_Section

	if @District = 'Standard'
	BEGIN

	-- truncate table Data_Services.dbo.Master_Student_Section
	insert into Data_Services.dbo.SF_Student_Section(SchoolForce__Section__c, SchoolForce__Student__c, SchoolFore__Active__c)
	select c.SF_ID Section_ID, b.SF_ID Student_ID, '1' Active
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and a.Teacher_First_Name = c.FirstName and a.Teacher_Last_Name = c.LastName
	left outer join Data_Services.dbo.Master_Student_Section (nolock) d on c.SF_ID = d.SchoolForce__Section__c and b.SF_ID = d.SchoolForce__Student__c
	where d.SchoolForce__Student__c is null and d.SchoolForce__Section__c is null
	
	END

IF @District='SJ'
	BEGIN

	DELETE FROM Data_Services.dbo.SF_Student_Section
	WHERE [SchoolForce__Section__c] IN (SELECT SF_ID
									FROM Data_Services.[dbo].[Master_Section] 
									WHERE [SF_Section_External_ID] LIKE 'SJ%')

	INSERT INTO Data_Services.dbo.SF_Student_Section(SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolFore__Active__c)
	SELECT distinct c.SF_ID Section_ID
		, b.SF_ID Student_ID
		, '1' Active
	FROM Data_Services.dbo.Class_Processed (nolock) a INNER JOIN 
	Data_Services.dbo.Master_Student (nolock) b ON 
		a.Student_ID = b.Student_ID and a.District = 'sj' and b.SchoolForce__External_Id__c like 'sj%'INNER JOIN 
	(SELECT DISTINCT SF_ID
		, FirstName, LastName
		, Class_Section_ID , Source_School_ID
	 FROM Data_Services.dbo.Master_Section (nolock) where SF_Section_External_ID like 'sj%') c ON
		a.Class_Section_ID = c.Class_Section_ID AND 
		a.Teacher_First_Name = c.FirstName AND 
		a.Teacher_Last_Name = c.LastName 
		and b.School_ID = c.Source_School_ID left  OUTER JOIN 
	Data_Services.dbo.Master_Student_Section (nolock) d ON 
		c.SF_ID = d.SchoolForce__Section__c AND 
		b.SF_ID = d.SchoolForce__Student__c
	WHERE d.SchoolForce__Student__c is null and d.SchoolForce__Section__c is null 
	END

	IF @District='MKE'
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

	DELETE FROM Data_services.dbo.SF_Student_Section
	WHERE [SchoolForce__Section__c] IN (SELECT SF_ID
									FROM Data_services.[dbo].[Master_Section] 
									WHERE [SF_Section_External_ID] LIKE 'MKE%')

	-- truncate table Data_services.dbo.Master_Student_Section
	INSERT INTO Data_services.dbo.SF_Student_Section(SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolFore__Active__c)
	SELECT distinct  c.SF_ID Section_ID,
		 b.SF_ID Student_ID
		, '1' Active
	FROM Data_services.dbo.Class_Processed (nolock) a INNER JOIN 
	Data_services.dbo.Master_Student (nolock) b ON 
		a.Student_ID = b.Student_ID and a.District = 'MKE' and b.SchoolForce__External_Id__c like 'MKE%'INNER JOIN 
	(SELECT DISTINCT SF_ID
		, FirstName, LastName
		, Class_Section_ID , Source_School_ID
	 FROM Data_services.dbo.Master_Section (nolock) where SF_Section_External_ID like 'mke%') c ON
		a.Class_Section_ID = c.Class_Section_ID AND 
		a.Teacher_First_Name = c.FirstName AND 
		a.Teacher_Last_Name = c.LastName 
		and b.School_ID = c.Source_School_ID left  OUTER JOIN 
	Data_services.dbo.Master_Student_Section (nolock) d ON 
		c.SF_ID = d.SchoolForce__Section__c AND 
		b.SF_ID = d.SchoolForce__Student__c
	WHERE d.SchoolForce__Student__c is null and d.SchoolForce__Section__c is null 


END
IF @District='CLM'
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

	DELETE FROM Data_services.dbo.SF_Student_Section
	WHERE [SchoolForce__Section__c] IN (SELECT SF_ID
									FROM Data_services.[dbo].[Master_Section] 
									WHERE [SF_Section_External_ID] LIKE 'CLM%')

	-- truncate table Data_services.dbo.Master_Student_Section
	INSERT INTO Data_services.dbo.SF_Student_Section(SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolFore__Active__c)
	SELECT distinct c.SF_ID Section_ID
		, b.SF_ID Student_ID
		, '1' Active
	FROM Data_services.dbo.Class_Processed (nolock) a INNER JOIN 
	Data_services.dbo.Master_Student (nolock) b ON 
		a.Student_ID = b.Student_ID and a.District = 'CLM' and b.SchoolForce__External_Id__c like 'CLM%'INNER JOIN 
	(SELECT DISTINCT SF_ID
		, FirstName, LastName
		, Class_Section_ID , Source_School_ID
	 FROM Data_services.dbo.Master_Section (nolock) where SF_Section_External_ID like 'CLM%') c ON
		a.Class_Section_ID = c.Class_Section_ID AND 
		a.Teacher_First_Name = c.FirstName AND 
		a.Teacher_Last_Name = c.LastName 
		and b.School_ID = c.Source_School_ID left  OUTER JOIN 
	Data_services.dbo.Master_Student_Section (nolock) d ON 
		c.SF_ID = d.SchoolForce__Section__c AND 
		b.SF_ID = d.SchoolForce__Student__c
	WHERE d.SchoolForce__Student__c is null and d.SchoolForce__Section__c is null 


END



IF @District='1STLN'
	BEGIN

	DELETE FROM Data_Services.dbo.SF_Student_Section
	WHERE [SchoolForce__Section__c] IN (SELECT SF_ID
										FROM Data_Services.[dbo].[Master_Section] 
										WHERE [SF_Section_External_ID] LIKE '1STLN_%')

	INSERT INTO Data_Services.dbo.SF_Student_Section(SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolFore__Active__c
		)
	
	SELECT DISTINCT c.SF_ID Section_ID
		, b.SF_ID Student_ID
		, '1' Active
	
	FROM Data_Services.dbo.Class_Processed (nolock) a INNER JOIN 
	Data_Services.dbo.Master_Student (nolock) b ON 
		a.Student_ID = b.Student_ID and a.District = '1STLN' AND 
		b.SchoolForce__External_Id__c LIKE '1STLN_%'INNER JOIN 
	(SELECT DISTINCT SF_ID
		, FirstName, LastName
		, Class_Section_ID , Source_School_ID
	 FROM Data_Services.dbo.Master_Section (NOLOCK) 
	 WHERE SF_Section_External_ID like '1STLN_%') c ON
		a.Class_Section_ID = c.Class_Section_ID AND 
		a.Teacher_First_Name = c.FirstName AND 
		a.Teacher_Last_Name = c.LastName AND 
		b.School_ID = c.Source_School_ID LEFT OUTER JOIN 
	Data_Services.dbo.Master_Student_Section (NOLOCK) d ON 
		c.SF_ID = d.SchoolForce__Section__c AND 
		b.SF_ID = d.SchoolForce__Student__c
	
	WHERE d.SchoolForce__Student__c IS NULL AND 
		d.SchoolForce__Section__c is null 
	END
IF @District='LRA'
	BEGIN

	DELETE FROM Data_Services.dbo.SF_Student_Section
	WHERE [SchoolForce__Section__c] IN (SELECT SF_ID
										FROM Data_Services.[dbo].[Master_Section] 
										WHERE [SF_Section_External_ID] LIKE 'LRA_%')

	INSERT INTO Data_Services.dbo.SF_Student_Section(SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolFore__Active__c
		)
	
	SELECT DISTINCT c.SF_ID Section_ID
		, b.SF_ID Student_ID
		, '1' Active
	
	FROM Data_Services.dbo.Class_Processed (nolock) a INNER JOIN 
	Data_Services.dbo.Master_Student (nolock) b ON 
		a.Student_ID = b.Student_ID and a.District = 'LRA' AND 
		b.SchoolForce__External_Id__c LIKE 'LRA_%'INNER JOIN 
	(SELECT DISTINCT SF_ID
		, FirstName, LastName
		, Class_Section_ID , Source_School_ID
	 FROM Data_Services.dbo.Master_Section (NOLOCK) 
	 WHERE SF_Section_External_ID like 'LRA_%') c ON
		a.Class_Section_ID = c.Class_Section_ID AND 
		a.Teacher_First_Name = c.FirstName AND 
		a.Teacher_Last_Name = c.LastName AND 
		b.School_ID = c.Source_School_ID LEFT OUTER JOIN 
	Data_Services.dbo.Master_Student_Section (NOLOCK) d ON 
		c.SF_ID = d.SchoolForce__Section__c AND 
		b.SF_ID = d.SchoolForce__Student__c
	
	WHERE d.SchoolForce__Student__c IS NULL AND 
		d.SchoolForce__Section__c is null 
	END
	IF @District='LA'
	BEGIN

	DELETE FROM Data_Services.dbo.SF_Student_Section
	WHERE [SchoolForce__Section__c] IN (SELECT SF_ID
										FROM Data_Services.[dbo].[Master_Section] 
										WHERE [SF_Section_External_ID] LIKE 'LA_%')

	INSERT INTO Data_Services.dbo.SF_Student_Section(SchoolForce__Section__c
		, SchoolForce__Student__c
		, SchoolFore__Active__c
		)
	
	SELECT DISTINCT c.SF_ID Section_ID
		, b.SF_ID Student_ID
		, '1' Active
	
	FROM Data_Services.dbo.Class_Processed (nolock) a INNER JOIN 
	Data_Services.dbo.Master_Student (nolock) b ON 
		a.Student_ID = b.Student_ID and a.District = 'LA' AND 
		b.SchoolForce__External_Id__c LIKE 'LA_%'INNER JOIN 
	(SELECT DISTINCT SF_ID
		, FirstName, LastName
		, Class_Section_ID , Source_School_ID
	 FROM Data_Services.dbo.Master_Section (NOLOCK) 
	 WHERE SF_Section_External_ID like 'LA_%') c ON
		a.Class_Section_ID = c.Class_Section_ID AND 
		a.Teacher_First_Name = c.FirstName AND 
		a.Teacher_Last_Name = c.LastName AND 
		b.School_ID = c.Source_School_ID LEFT OUTER JOIN 
	Data_Services.dbo.Master_Student_Section (NOLOCK) d ON 
		c.SF_ID = d.SchoolForce__Section__c AND 
		b.SF_ID = d.SchoolForce__Student__c
	
	WHERE d.SchoolForce__Student__c IS NULL AND 
		d.SchoolForce__Section__c is null 
	END

		if @District = 'KCPS'
	BEGIN

	DELETE FROM Data_Services.dbo.SF_Student_Section
	WHERE [SchoolForce__Section__c] IN (SELECT SF_ID
										FROM Data_Services.[dbo].[Master_Section] 
										WHERE [SF_Section_External_ID] LIKE 'KCPS%')

	insert into Data_Services.dbo.SF_Student_Section(SchoolForce__Section__c, SchoolForce__Student__c, SchoolFore__Active__c)
	select c.SF_ID Section_ID, b.SF_ID Student_ID, '1' Active
	from Data_Services.dbo.Class_Processed (nolock) a 
	inner join Data_Services.dbo.Master_Student (nolock) b on a.Student_ID = b.Student_ID
	inner join (select distinct SF_ID, FirstName, LastName, Class_Section_ID from Data_Services.dbo.Master_Section (nolock)) c on a.Class_Section_ID = c.Class_Section_ID and a.Teacher_First_Name = c.FirstName and a.Teacher_Last_Name = c.LastName
	left outer join Data_Services.dbo.Master_Student_Section (nolock) d on c.SF_ID = d.SchoolForce__Section__c and b.SF_ID = d.SchoolForce__Student__c
	where d.SchoolForce__Student__c is null and d.SchoolForce__Section__c is null and a.District='KCPS'
	
	END
END



GO

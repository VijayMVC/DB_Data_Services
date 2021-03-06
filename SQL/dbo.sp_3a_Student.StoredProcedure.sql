USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_3a_Student]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_3a_Student]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO Data_Services.dbo.Master_Student(Student_ID
		, School_ID
		, School_Name
		, School_Year
		, First_Name
		, Last_Name
		, Grade
		, Date_Of_Birth
		, Sex
		, Ethnicity
		, Disability_Flag
		, ELL_Flag
		, Home_Language
		, Address_Line_1
		, Address_Line_2
		, City
		, [State]
		, Zip
		, Home_Phone
		, Race
		, District
		, RunDate
		, SchoolForce__Grade__c
		, SchoolForce__School__c
		, SchoolForce__Individual__c
		, SchoolForce__External_Id__c
		, SchoolForce__Setup__c
		, SF_ID
		)
	SELECT a.Student_ID
		, a.School_ID
		, a.School_Name
		, a.School_Year
		, a.First_Name
		, a.Last_Name
		, a.Grade
		, a.Date_Of_Birth
		, a.Sex
		, a.Ethnicity
		, a.Disability_Flag
		, a.ELL_Flag
		, a.Home_Language
		, a.Address_Line_1
		, a.Address_Line_2
		, a.City
		, a.State
		, a.Zip
		, a.Home_Phone
		, a.Race
		, a.District
		, a.RunDate
		, a.Grade  SchoolForce__Grade__c
-- [NOTE CSD 8/8/16] Cast a.Grade to int fails on text valued grade levels in the student table e.g. 'PK'  master_student table needs field converted. Ideally all values passed should conform to existing picklist values in cyschoolhouse
		, b.Account_ID SchoolForce__School__c
		, c.Id SchoolForce__Individual__c
-- [NOTE CSD (9/14/16] Changed Cast of a.School_ID AS VARCHAR(7) from VARCHAR(4) to fix a join issue for LA SCHOOLS with longer school IDs (lines 76,84,86) 
		, a.District + '_' + CAST(CAST(a.School_ID AS INTEGER) AS VARCHAR(7)) + '_' + a.Student_ID [SchoolForce__External_Id__c]
		, b.Setup_14_15 [SchoolForce__Setup__c]
		, b.Account_ID SF_ID
	
	FROM Data_Services.dbo.Student (NOLOCK) a 	INNER JOIN 
	Data_Services.dbo.School_Lookup_16_17 (NOLOCK) b ON 
		a.School_Name = b.Source_School_Name  and a.school_id = b.source_school_id INNER JOIN 
	SDW_Stage_Prod_17.dbo.Contact (NOLOCK) c ON 
		a.District + '_' + CAST(CAST(a.School_ID AS INTEGER) AS VARCHAR(7)) + '_' + a.Student_ID = c.ID__c LEFT OUTER JOIN 
	Data_Services.dbo.Master_Student (NOLOCK) d ON 
		a.District + '_' + cast(cast(a.School_ID AS INTEGER) AS VARCHAR(7)) + '_' + a.Student_ID = d.[SchoolForce__External_Id__c]
	--inner join #Student (nolock) e on a.District + '_' + cast(cast(a.School_ID as integer) as varchar(7)) + '_' + a.Student_ID = e.[SchoolForce__Legacy_Id__c]
	WHERE d.[SchoolForce__External_Id__c] IS NULL

	UPDATE Data_Services.dbo.Master_Student SET SF_ID = b.ID ,SchoolForce__Reference_Id__c = b.Reference_Id__c
	FROM Data_Services.dbo.Master_Student (NOLOCK) a INNER JOIN 
	SDW_Stage_Prod_17.dbo.Student__c (NOLOCK) b ON a.SchooLForce__External_Id__c = b.External_Id__c

	DELETE FROM Data_Services.dbo.Master_Student 
	WHERE SchoolForce__Reference_Id__c IS NULL 

END

GO

USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_1_Student_Contact]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date	 <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_1_Student_Contact] @District varchar(255) = 'Standard'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	


	--truncate table Data_Services.dbo.Master_Contact_Student

	update Data_Services.dbo.Student set Race = 'African American' where Race LIKE '%Black%' or (Race like '%Afr%' and Race <>'African American') and District = 'OCPS'

if @District = 'OCPS' or @District = 'KCPS' 
	BEGIN

	
	truncate table Data_Services.dbo.SF_Contact_Student

	-- SF_Contact_Student
	INSERT INTO Data_Services.dbo.SF_Contact_Student(AccountID
			,RecordType
			,Student_ID
			,Last_Name
			,First_Name
			,Date_Of_Birth
			,Sex
			,Ethnicity
			,Disability_Flag
			,ELL_Flag
			,Home_Language
			,Address_Line_1
			,City
			,State
			,Zip
			,Home_Phone
			,Race)
	SELECT 
	(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'Contact.Account_ID') AccountID 
	,(select [Value] from [Data_Services].[dbo].[Settings] where [Name] = 'Contact.Record_Type') RecordType
	-- 012550000008VdFAAU (OLD ID)
	,a.District + '_' + cast(cast(a.School_ID as integer) as varchar(4)) + '_' + a.Student_ID Student_ID
	,Last_Name
	,First_Name
	,Date_Of_Birth
	,CASE Sex WHEN 'M' THEN 'Male'
			  ELSE 'Female'
	 END 
	,Ethnicity
	,Disability_Flag
	,CASE ELL_Flag WHEN 'Y' THEN '1' 
				   ELSE '0' 
	 END
	,Home_Language
	,Address_Line_1
	,City
	,State
	,Zip
	,Home_Phone
	,Race
	FROM Data_Services.dbo.Student (nolock) a 
	left outer join SDW_Stage_Prod_17.dbo.Contact (nolock) b on a.District + '_' + cast(cast(a.School_ID as integer) as varchar(4)) + '_' + a.Student_ID = b.ID__c
	where b.ID__c is null and a.DIstrict = @DIstrict
	END

IF @District = '1STLN' or @District = 'LRA'

BEGIN


	truncate table Data_Services.dbo.SF_Contact_Student

--Delete from Data_Services.dbo.SF_Contact_Student where substring(Student_ID,1,2) = ''

INSERT INTO Data_Services.dbo.SF_Contact_Student(AccountID
			,RecordType
			,Student_ID
			,Last_Name
			,First_Name
			,Date_Of_Birth
			,Sex
			,Ethnicity
			,Disability_Flag
			,ELL_Flag
			,Home_Language
			,Address_Line_1
			,City
			,State
			,Zip
			,Home_Phone
			,Race)


--[CSD]-- Hardcoding 16-17 'Individual' Account ID and 'Student' RecordType 	
SELECT '0013600000QJeqz' AccountID
	, '012360000007jgNAAQ' RecordType

--(SELECT [Value] FROM [Data_Services].[dbo].[Settings] WHERE [Name] = 'Contact.Account_ID') AccountID 
--, (SELECT [Value] FROM [Data_Services].[dbo].[Settings] WHERE [Name] = 'Contact.Record_Type') RecordType 
	
	, a.District + '_' + cast(cast(a.School_ID as integer) as varchar(10)) + '_' + a.Student_ID Student_ID
	, Last_Name
	, First_Name
	, Date_Of_Birth
	, CASE Sex WHEN 'M' THEN 'Male'
			   ELSE 'Female'
	  END 
	, Ethnicity
	, Disability_Flag
	, CASE ELL_Flag WHEN 'Y' THEN '1' 
				   ELSE '0' 
	  END
	, Home_Language
	, Address_Line_1
	, City
	, State
	, Zip
	, Home_Phone
	, CASE WHEN Race LIKE '%Black%' THEN 'African American'
		   WHEN Race LIKE '%Afr%'   THEN 'African American'
		   ELSE Race
	  END
FROM Data_Services.dbo.Student (NOLOCK) a LEFT OUTER JOIN 
	SDW_Stage_PROD_17.dbo.Contact (NOLOCK) b ON 
		a.District + '_' + cast(cast(a.School_ID AS INTEGER) AS VARCHAR(10)) + '_' + a.Student_ID = b.ID__c
	WHERE b.ID__c IS NULL 
	AND a.district = @District
END

IF @District = 'SJ'
BEGIN

delete from Data_Services.dbo.student where district = 'sj' and  School_ID = '491'

	Delete from Data_Services.dbo.SF_Contact_Student where substring(Student_ID,1,2) = 'SJ' 

	-- SF_Contact_Student
	INSERT INTO Data_Services.dbo.SF_Contact_Student(AccountID
			,RecordType
			,Student_ID
			,Last_Name
			,First_Name
			,Date_Of_Birth
			,Sex
			,Ethnicity
			,Disability_Flag
			,ELL_Flag
			,Home_Language
			,Address_Line_1
			,City
			,State
			,Zip
			,Home_Phone
			,Race)
	SELECT distinct
	'0013600000QJeqz'	 AccountID 
	, '012360000007jgNAAQ' RecordType
	-- 012550000008VdFAAU (OLD ID)
	,a.District + '_' + cast(cast(a.School_ID as integer) as varchar(10)) + '_' + a.Student_ID Student_ID
	,Last_Name
	,First_Name
	,Date_Of_Birth
	,CASE Sex WHEN 'M' THEN 'Male'
			  ELSE 'Female'
	 END 
	,Ethnicity
	,Disability_Flag
	,CASE ELL_Flag WHEN 'Y' THEN '1' 
			   ELSE '0' 
	 END
	,Home_Language
	,Address_Line_1
	,City
	,State
	,Zip
	,Home_Phone
	,Race
	FROM Data_Services.dbo.Student (nolock) a 
	left outer join sdw_stage_prod_17.dbo.Contact (nolock) b on a.District + '_' + cast(cast(a.School_ID as integer) as varchar(4)) + '_' + a.Student_ID = b.ID__c and a.district = 'SJ'
	where 
	b.ID__c is null AND 
	district = 'SJ';

	
	with mycte as (
	select row_number() over (partition by student_id order by student_id) as rownum , * 
	from Data_Services.dbo.SF_Contact_Student where substring(Student_ID,1,2) = 'SJ' )
	delete from mycte where rownum > 1



END
IF @District = 'MKE'
BEGIN


			with mycte as (
	select row_number() over (partition by student_id order by student_id) as rownum , * 
	from Data_Services.dbo.Student where district = 'MKE' )
	delete from mycte where rownum > 1
	
	Delete from Data_Services.dbo.SF_Contact_Student where substring(Student_ID,1,3) = 'MKE' 
	--truncate table Data_Services.dbo.Master_Contact_Student

	-- SF_Contact_Student
	INSERT INTO Data_Services.dbo.SF_Contact_Student(AccountID
			,RecordType
			,Student_ID
			,Last_Name
			,First_Name
			,Date_Of_Birth
			,Sex
			,Ethnicity
			,Disability_Flag
			,ELL_Flag
			,Home_Language
			,Address_Line_1
			,City
			,State
			,Zip
			,Home_Phone
			,Race)
	SELECT distinct
	'0013600000QJeqz'	 AccountID 
	, '012360000007jgNAAQ' RecordType
	-- 012550000008VdFAAU (OLD ID)
	,a.District + '_' + cast(cast(a.School_ID as integer) as varchar(10)) + '_' + a.Student_ID Student_ID
	,Last_Name
	,First_Name
	,Date_Of_Birth
	,CASE Sex WHEN 'M' THEN 'Male'
			  ELSE 'Female'
	 END 
	,Ethnicity
	,Disability_Flag
	,CASE ELL_Flag WHEN 'Y' THEN '1' 
			   ELSE '0' 
	 END
	,Home_Language
	,Address_Line_1
	,City
	,State
	,Zip
	,Home_Phone
	,Race
	FROM Data_Services.dbo.Student (nolock) a 
	left outer join SDW_Stage_prod_17.dbo.Contact (nolock) b on a.District + '_' + cast(cast(a.School_ID as integer) as varchar(4)) + '_' + a.Student_ID = b.ID__c AND A.DISTRICT = 'mke'
	where b.ID__c is null
	AND district = 'MKE';

	
	with mycte as (
	select row_number() over (partition by student_id order by student_id) as rownum , * 
	from Data_Services.dbo.SF_Contact_Student where substring(Student_ID,1,3) = 'MKE' )
	delete from mycte where rownum > 1




END
IF @District = 'CLM'
BEGIN
	Delete from Data_Services.dbo.SF_Contact_Student where substring(Student_ID,1,3) = 'CLM' 

	-- SF_Contact_Student
	INSERT INTO Data_Services.dbo.SF_Contact_Student(AccountID
			,RecordType
			,Student_ID
			,Last_Name
			,First_Name
			,Date_Of_Birth
			,Sex
			,Ethnicity
			,Disability_Flag
			,ELL_Flag
			,Home_Language
			,Address_Line_1
			,City
			,State
			,Zip
			,Home_Phone
			,Race)
	SELECT distinct
	'0013600000QJeqz'	 AccountID 
	, '012360000007jgNAAQ' RecordType
	-- 012550000008VdFAAU (OLD ID)
	,a.District + '_' + cast(cast(a.School_ID as integer) as varchar(10)) + '_' + a.Student_ID Student_ID
	,Last_Name
	,First_Name
	,Date_Of_Birth
	,CASE Sex WHEN 'M' THEN 'Male'
			  ELSE 'Female'
	 END 
	,Ethnicity
	,Disability_Flag
	,CASE ELL_Flag WHEN 'Y' THEN '1' 
			   ELSE '0' 
	 END
	,Home_Language
	,Address_Line_1
	,City
	,State
	,Zip
	,Home_Phone
	,Race
	FROM Data_Services.dbo.Student (nolock) a 
	left outer join sdw_stage_prod_17.dbo.Contact (nolock) b on a.District + '_' + cast(cast(a.School_ID as integer) as varchar(4)) + '_' + a.Student_ID = b.ID__c and a.district = 'CLM'
	where b.ID__c is null
	AND district = 'CLM'
	AND A.SCHOOL_NAME IN  ('Frances Mack Intermediate School','Sandhills Elementary School');

	
	with mycte as (
	select row_number() over (partition by student_id order by student_id) as rownum , * 
	from Data_Services.dbo.SF_Contact_Student where substring(Student_ID,1,3) = 'CLM' )
	delete from mycte where rownum > 1



END
END





GO

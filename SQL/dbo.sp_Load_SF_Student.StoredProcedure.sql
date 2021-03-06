USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_SF_Student]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_SF_Student]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--Clear Table for Student load
TRUNCATE TABLE dbo.SF_Student
--Pull and structure data to load for transfer students to SchoolForce
INSERT INTO dbo.SF_Student (Student_ID, School_ID, First_Name, Last_Name, Grade, Date_Of_Birth, Gender, Ethnicity, Disability_Flag, ELL_Flag, Home_Language, Race, Contact_ID, Ref_ID, Setup)
SELECT a.[Student_ID]
	  ,d.Account_ID
      ,a.[First_Name]
      ,a.[Last_Name]
      ,b.Grade
      ,a.[Date_Of_Birth]
      ,a.[Sex] AS Gender
      ,a.[Ethnicity]
      ,a.[Disability_Flag]
      ,a.[ELL_Flag]
      ,a.[Home_Language]
      ,a.[Race]
      ,c.Id AS Contact_ID
      ,a.[Student_ID]+'_2014-2015' AS Ref_ID
      ,d.Setup_14_15 AS Setup     
  FROM 
	[Data_Services].[dbo].[SF_Contact_Student] a inner join 
	dbo.Student b ON
		a.Student_ID = b.Student_ID inner join 
	SDW_Stage.dbo.Contact c ON
		a.Student_ID = c.SchoolForce__ID__c inner join
	dbo.School_Lookup d ON
		b.School_ID = d.Source_School_ID
END




GO

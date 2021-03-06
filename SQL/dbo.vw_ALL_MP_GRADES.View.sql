USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_ALL_MP_GRADES]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_ALL_MP_GRADES]
AS
SELECT [Student_ID]
      ,CASE WHEN [Marking_Period] = 'RC1' THEN 'Q1' WHEN [Marking_Period] = 'RC2' THEN 'Q2' ELSE Marking_Period END as [Marking_Period] 
      ,[Math_Grade_Value] AS [GRADE VALUE]
      ,b.SchoolForce__Course__c as [SECTION_TYPE]
      ,[Math_Weighted_Value] AS [WEIGHTED_VALUE]
      --,[Math_GPA_Value] AS [GPA_VALUE]
  FROM [Data_Services].[dbo].[MP_Grades] a  INNER JOIN 
  dbo.vw_Sections b ON
	a.Math_Class_Section_ID = b.Legacy_SectionID
   
  WHERE Student_ID IS NOT NULL
  Group by [Student_ID]
      ,[Marking_Period]
      ,[Math_Grade_Value]
      ,[Math_Weighted_Value]
      --,[Math_GPA_Value]
      ,[SchoolForce__Course__c]
           
UNION

SELECT [Student_ID]
    ,CASE WHEN [Marking_Period] = 'RC1' THEN 'Q1' WHEN [Marking_Period] = 'RC2' THEN 'Q2' ELSE Marking_Period END 
     ,[ELA_Grade_Value] AS [GRADE_VALUE]
     ,b.SchoolForce__Course__c as [SECTION_TYPE]
     ,[ELA_Weighted_Value] AS [WEIGHTED_VALUE]
     --,[ELA_GPA_Value] AS [GPA_VALUE]
  FROM [Data_Services].[dbo].[MP_Grades] a INNER JOIN 
  dbo.vw_Sections b ON
	 a.ELA_Class_Section_ID = b.Legacy_SectionID
 Where Student_ID is not null  
  Group by [Student_ID]
	 ,[ELA_Grade_Value]
	 ,[SchoolForce__Course__c] 
     ,[Marking_Period]
     ,[ELA_Weighted_Value]
     --,[ELA_GPA_Value]


GO

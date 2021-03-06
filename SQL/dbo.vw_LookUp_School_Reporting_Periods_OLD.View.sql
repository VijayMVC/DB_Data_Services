USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_LookUp_School_Reporting_Periods_OLD]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_LookUp_School_Reporting_Periods_OLD]
AS
SELECT d.Id AS [Schoolforce__Reporting_Period__c]
	  ,d.SchoolForce__Name__c AS [Name]
	  ,[School_Name]
      ,[Account_ID]
      ,[School_Grades]
      ,[County]
      ,[Source_School_Name]
      ,[Source_School_ID]
      ,[Setup_14_15] AS [Schoolforce__setup__c]
  FROM [Data_Services].[dbo].[School_Lookup] a INNER JOIN 
		SDW_Stage.dbo.SchoolForce__Setup__c b on 
			a.Setup_14_15 = b.Id inner join 
		SDW_Stage.dbo.SchoolForce__Time_Element__c d ON
			b.SchoolForce__Term__c = d.SchoolForce__Parent_Time_Element__c




GO

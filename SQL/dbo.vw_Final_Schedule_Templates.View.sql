USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_Final_Schedule_Templates]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vw_Final_Schedule_Templates]
AS

 SELECT [OwnerId]
      ,[IsDeleted]
      ,A.[Name]
      ,[CreatedDate]
      ,[CreatedById]
      ,[LastModifiedDate]
      ,[LastModifiedById]
      ,[SystemModstamp]
      ,[SchoolForce__Color__c]
      ,[SchoolForce__End_Time_Text__c]
      ,[SchoolForce__End_Time__c]
      ,[SchoolForce__External_Id__c] = B.[SchoolForce__Reporting_Period__c]+'_'+A.Name
      ,[SchoolForce__Has_Class__c]
      ,[SchoolForce__Is_Master__c]
      ,[SchoolForce__Reference_Id__c]
      ,B.[SchoolForce__Reporting_Period__c]
      ,A.[SchoolForce__Setup__c]
      ,[SchoolForce__Start_Time_Text__c]
      ,[SchoolForce__Start_Time__c]
      ,'4' [SchoolForce__Number_of_Periods__c]
  FROM [Data_Services].[dbo].[vw_Schedule_templates_Ins_A] A INNER JOIN
	dbo.vw_LookUp_School_Reporting_Periods B ON
		A.Name = B.Name AND A.SchoolForce__Setup__c = B.SchoolForce__Setup__c



GO

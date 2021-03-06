USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_Schedule_Templates_Ins_A]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_Schedule_Templates_Ins_A]
AS
Select b.[OwnerId]
      ,b.[IsDeleted]
      ,b.[Name]
      ,b.[CreatedDate]
      ,b.[CreatedById]
      ,b.[LastModifiedDate]
      ,b.[LastModifiedById]
      ,b.[SystemModstamp]
      ,b.[SchoolForce__Color__c]
      ,b.[SchoolForce__End_Time_Text__c]
      ,b.[SchoolForce__End_Time__c]
      ,b.[SchoolForce__External_Id__c]
      ,b.[SchoolForce__Has_Class__c]
      ,b.[SchoolForce__Is_Master__c]
      ,b.[SchoolForce__Reference_Id__c]
      ,b.[SchoolForce__Reporting_Period__c]
      ,a.Setup_14_15 AS [SchoolForce__Setup__c]
      ,b.[SchoolForce__Start_Time_Text__c]
      ,b.[SchoolForce__Start_Time__c]
      ,b.[SchoolForce__Number_of_Periods__c] 
FROM School_lookup a cross join
(SELECT [OwnerId]
      ,[IsDeleted]
      ,[Name]
      ,[CreatedDate]
      ,[CreatedById]
      ,[LastModifiedDate]
      ,[LastModifiedById]
      ,[SystemModstamp]
      ,[SchoolForce__Color__c]
      ,[SchoolForce__End_Time_Text__c]
      ,[SchoolForce__End_Time__c]
      ,[SchoolForce__External_Id__c]
      ,[SchoolForce__Has_Class__c]
      ,[SchoolForce__Is_Master__c]
      ,[SchoolForce__Reference_Id__c]
      ,[SchoolForce__Reporting_Period__c]
      ,[SchoolForce__Setup__c]
      ,[SchoolForce__Start_Time_Text__c]
      ,[SchoolForce__Start_Time__c]
      ,[SchoolForce__Number_of_Periods__c]
  FROM [SDW_Stage].[dbo].[SchoolForce__Schedule_Template__c]) b 
  WHERE SchoolForce__Setup__c ='a1DE0000000S2rMMAS'

GO

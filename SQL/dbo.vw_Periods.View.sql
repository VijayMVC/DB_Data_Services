USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_Periods]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vw_Periods]
AS
SELECT 0 as [isDeleted]
 ,NULL AS Name
 ,NULL AS [SchoolForce__Abbreviation__c]
 ,NULL[SchoolForce__Class_Minutes__c]
 ,NULL[SchoolForce__Description__c]

,[SchoolForce__End_Time_Text__c] = CASE WHEN e.Period_Key = 'Attendance' THEN '10:00 AM'
	WHEN e.Period_Key = 'Behavior' THEN '12:00 PM'
	WHEN e.Period_Key = 'ELA' THEN '02:00 PM'
	ELSE '04:00 PM'
	END
,a.SchoolForce__End_Time__c AS [SchoolForce__End_Time__c]
,a.Id AS [Schoolforce__Schedule_Template__c]
,[SchoolForce__External_Id__c] = a.Id+'_'+Left(e.Period_Key,3)+'_'+a.Name
,e.Period_Key AS [SchoolForce__Key__c]
,e.Period_Order AS [SchoolForce__Order__c]
,[SchoolForce__Start_Time_Text__c] = CASE WHEN e.Period_Key = 'Attendance' THEN '08:00 AM'
	WHEN e.Period_Key = 'Behavior' THEN '10:00 PM'
	WHEN e.Period_Key = 'ELA' THEN '12:00 PM'
	ELSE '02:00 PM'
	END
,a.SchoolForce__Start_Time__c AS [SchoolForce__Start_Time__c]
,0 as [SchoolForce__Passing_Time__c]
,NULL AS [SchoolForce__Time__c]
,NULL AS[SchoolForce__Type__c]
  FROM [SDW_Stage].[dbo].[SchoolForce__Schedule_Template__c] a inner join 
  Data_Services.dbo.School_Lookup b ON
	a.SchoolForce__Setup__c = b.Setup_14_15 inner join 
  SDW_Stage.dbo.SchoolForce__Time_Element__c c ON
	a.SchoolForce__Reporting_Period__c = c.Id inner join 
  SDW_Stage.dbo.SchoolForce__Time_Element__c d ON
	c.SchoolForce__Parent_Time_Element__c = d.Id inner join 
  Data_Services.dbo.Period_Subjects e ON
	d.SchoolForce__Parent_Time_Element__c = e.SchoolYear
  WHERE a.Name = 'Q1' 



GO

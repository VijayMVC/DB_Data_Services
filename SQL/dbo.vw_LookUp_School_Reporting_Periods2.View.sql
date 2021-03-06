USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_LookUp_School_Reporting_Periods2]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_LookUp_School_Reporting_Periods2]
AS
SELECT     d.Id AS Reporting_Period__c, d.Name__c AS Name, a_1.School_Name, a_1.Account_ID, a_1.School_Grades, a_1.County, a_1.Setup_14_15 AS setup__c
FROM         (SELECT DISTINCT School_Name, Account_ID, School_Grades, County, Setup_14_15
                       FROM          dbo.School_Lookup_16_17 AS a WITH (nolock)) AS a_1 INNER JOIN
                      SDW_Stage_PROD_17.dbo.Setup__c AS b ON a_1.Setup_14_15 = b.Id INNER JOIN
                      SDW_Stage_PROD_17.dbo.Time_Element__c AS d ON b.Term__c = d.Parent_Time_Element__c
WHERE     (NOT (d.Name__c LIKE '%Prior%'))



GO

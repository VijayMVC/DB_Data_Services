USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_School_Lookup_LA_16_17]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_School_Lookup_LA_16_17]
AS

SELECT Distinct a.Name School_Name
	,a.Id Account_ID
	,'' School_Grades
	,'LA' County
	, a.Name Source_School_Name
	,c.School_ID    [Source_School_ID]
	, b.ID Setup_14_15
	,'' School_Admin_Staff_ID 

FROM SDW_Stage_Prod_17.dbo.Account a INNER JOIN 
SDW_Stage_Prod_17.dbo.setup__c b ON
	a.Id = b.school__c INNER JOIN 
LA_Class_Sec_Enrollment c ON a.Name = c.School_Name
WHERE a.Site__c = 'Los Angeles' 



GO

USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_16a_TBBT]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_16a_TBBT]
AS
BEGIN
	insert into Data_Services.dbo.Master_Assessment_TBBT(SF_ID, Student_ID, SchoolForce__Type__c, SchoolForce__Assessment_Name__c, Date_Administered__c, Number_of_Office_Referrals__c, Number_of_Detentions__c, Number_of_Suspensions__c, SchoolForce__External_Id__c, Source_Student_ID)
	select a.ID SF_ID, b.*, c.Student_ID Source_Student_ID 
	from SDW_Stage_Prod_17.dbo.Assesment__c (nolock) a
	inner join Data_Services.dbo.SF_Assessment_TBBT (nolock) b on a.[External_Id__c] = b.[SchoolForce__External_Id__c]
	inner join Data_Services.dbo.Master_Student (nolock) c on b.Student_ID = c.SF_ID
	left outer join Data_Services.dbo.Master_Assessment_TBBT (nolock) d on a.External_Id__c = d.SchoolForce__External_Id__c
	where d.SchoolForce__External_Id__c is null
END

GO

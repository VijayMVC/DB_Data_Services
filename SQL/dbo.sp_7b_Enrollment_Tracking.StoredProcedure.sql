USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_7b_Enrollment_Tracking]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_7b_Enrollment_Tracking] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	insert into Data_Services.dbo.Master_Enrollment_Tracking(SchoolForce__Active__c, SchoolForce__Current_Record__c, SchoolForce__Start_Date__c, SchoolForce__Student_Section__c, SchoolForce__Student__c, Reference_Id__c, SF_ID)
	select a.SchoolForce__Active__c, a.SchoolForce__Current_Record__c, a.SchoolForce__Start_Date__c, a.SchoolForce__Student_Section__c, a.SchoolForce__Student__c, a.Reference_Id__c, b.ID SF_ID 
	from Data_Services.dbo.SF_Enrollment_Tracking (nolock) a
	inner join SDW_Stage_Prod_17.dbo.Enrollment_Tracking__c (nolock) b on a.SchoolForce__Student__c = b.Student__c and a.SchoolForce__Student_Section__c = b.Student_Section__c
	left outer join Data_Services.dbo.Master_Enrollment_Tracking (nolock) c on a.SchoolForce__Student__c = c.SchoolForce__Student__c and a.SchoolForce__Student_Section__c = c.SchoolForce__Student_Section__c
	where c.SchoolForce__Student__c is null and c.SchoolForce__Student_Section__c is null

END


GO

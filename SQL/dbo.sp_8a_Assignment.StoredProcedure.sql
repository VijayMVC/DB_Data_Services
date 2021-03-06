USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_8a_Assignment]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_8a_Assignment]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	insert into Data_Services.dbo.Master_Assignment(ID, Name, Assignment_Library__c, SchoolForce__Due_Date__c, SchoolForce__Picklist_Value__c, SchoolForce__Include_in_Final_Grade__c, SchoolForce__Name_in_Gradebook__c, SchoolForce__Possible_Points__c, SchoolForce__Time__c, SchoolForce__Section__c, SchoolForce__Weighting_Value__c, SchoolForce__External_Id__c, Local_Assignment_Type__c, SF_ID)
	select a.*, b.Id SF_ID
	from Data_Services.dbo.SF_Assignment (nolock) a
	inner join SDW_Stage_Prod_17.dbo.Assignment__c (nolock) b on a.SchoolForce__External_Id__c = b.External_Id__c
	left outer join Data_Services.dbo.Master_Assignment (nolock) c on a.SchoolForce__External_Id__c = c.SchoolForce__External_Id__c
	where c.SchoolForce__External_Id__c is null

	alter index all on Data_Services.dbo.Master_Assignment REBUILD

END



GO

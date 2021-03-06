USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_2a_Staff_Contact]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_2a_Staff_Contact]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO Data_Services.dbo.Master_Contact_Staff(AccountID
		, RecordType
		, Salutation
		, Last_Name
		, First_Name
		, Email
		, Mailing_Street
		, Mailing_City
		, Mailing_State
		, Mailing_Zip
		, Gender
		, Contact_Indv_Account_ID
		, OrgID
		, SF_ID
		)
	
	SELECT a.AccountID
		, a.RecordType
		, a.Salutation
		, a.Last_Name
		, a.First_Name
		, a.Email
		, a.Mailing_Street
		, a.Mailing_City
		, a.Mailing_State
		, a.Mailing_Zip
		, a.Gender
		, a.Contact_Indv_Account_ID
		, a.OrgID
		, b.Id 
	
	FROM Data_Services.dbo.SF_Contact_Staff (NOLOCK) a INNER JOIN 
	SDW_Stage_Prod_17.dbo.Contact (NOLOCK) b on a.Email = b.ID__c LEFT OUTER JOIN 
	Data_Services.dbo.Master_Contact_Staff (NOLOCK) c ON 
		a.Email = c.Email
	WHERE c.Email is null

END

GO

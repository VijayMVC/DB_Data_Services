USE [Data_Services]
GO
/****** Object:  Table [dbo].[SF_Contact_Staff]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Contact_Staff](
	[AccountID] [varchar](256) NULL,
	[RecordType] [varchar](256) NULL,
	[Salutation] [varchar](256) NULL,
	[Last_Name] [varchar](256) NULL,
	[First_Name] [varchar](256) NULL,
	[Email] [varchar](256) NULL,
	[Mailing_Street] [varchar](256) NULL,
	[Mailing_City] [varchar](256) NULL,
	[Mailing_State] [varchar](256) NULL,
	[Mailing_Zip] [varchar](256) NULL,
	[Gender] [varchar](256) NULL,
	[Contact_Indv_Account_ID] [varchar](256) NULL,
	[OrgID] [varchar](256) NULL
) ON [PRIMARY]

GO

USE [Data_Services]
GO
/****** Object:  Table [dbo].[SF_Assessment_RP_ADA]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Assessment_RP_ADA](
	[Student_ID] [varchar](18) NOT NULL,
	[SchoolForce__Type__c] [varchar](18) NOT NULL,
	[SchoolForce__Assessment_Name__c] [varchar](50) NOT NULL,
	[Date_Administered__c] [varchar](50) NULL,
	[Average_Daily_Attendance__c] [varchar](50) NULL,
	[Time_Period__c] [varchar](256) NULL,
	[SchoolForce__External_Id__c] [varchar](518) NULL
) ON [PRIMARY]

GO

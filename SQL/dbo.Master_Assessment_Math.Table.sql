USE [Data_Services]
GO
/****** Object:  Table [dbo].[Master_Assessment_Math]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Assessment_Math](
	[Student_ID] [varchar](18) NOT NULL,
	[SchoolForce__Type__c] [varchar](18) NOT NULL,
	[SchoolForce__Assessment_Name__c] [varchar](36) NOT NULL,
	[Date_Administered__c] [date] NULL,
	[FSA_Math_Score_c] [varchar](256) NOT NULL,
	[Local_Benchmark__c] [varchar](256) NULL,
	[SchoolForce__External_Id__c] [varchar](256) NULL,
	[SF_ID] [varchar](18) NOT NULL,
	[Assessment_Name] [varchar](19) NOT NULL,
	[Source_Student_ID] [varchar](256) NULL
) ON [PRIMARY]

GO

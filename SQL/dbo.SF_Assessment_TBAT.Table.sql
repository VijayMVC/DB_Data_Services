USE [Data_Services]
GO
/****** Object:  Table [dbo].[SF_Assessment_TBAT]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Assessment_TBAT](
	[Student_ID] [varchar](18) NOT NULL,
	[SchoolForce__Type__c] [varchar](18) NOT NULL,
	[SchoolForce__Assessment_Name__c] [varchar](29) NOT NULL,
	[Date] [date] NULL,
	[Number_Of_Absences] [int] NULL,
	[Excused_Absences] [int] NULL,
	[Number_of_Tardies] [int] NULL,
	[Number_Of_Unexcused_Absences] [int] NULL,
	[Days_Enrolled__c] [int] NULL,
	[SchoolForce__External_Id__c] [varchar](256) NULL
) ON [PRIMARY]

GO

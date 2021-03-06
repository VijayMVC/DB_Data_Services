USE [Data_Services]
GO
/****** Object:  Table [dbo].[SF_Assignment_Test]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Assignment_Test](
	[Name] [varchar](85) NULL,
	[Assignment_Library__c] [varchar](18) NULL,
	[SchoolForce__Due_Date__c] [datetime] NULL,
	[SchoolForce__Picklist_Value__c] [varchar](18) NULL,
	[SchoolForce__Include_in_Final_Grade__c] [int] NOT NULL,
	[SchoolForce__Name_in_Gradebook__c] [varchar](5) NULL,
	[SchoolForce__Possible_Points__c] [decimal](3, 0) NULL,
	[SchoolForce__Time__c] [varchar](18) NULL,
	[SchoolForce__Section__c] [varchar](18) NOT NULL,
	[SchoolForce__Weighting_Value__c] [decimal](2, 0) NULL,
	[SchoolForce__External_Id__c] [varchar](6) NOT NULL,
	[Local_Assignment_Type__c] [varchar](255) NULL,
	[ID] [varchar](20) NULL
) ON [PRIMARY]

GO

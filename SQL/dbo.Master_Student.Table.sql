USE [Data_Services]
GO
/****** Object:  Table [dbo].[Master_Student]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Student](
	[Student_ID] [varchar](256) NULL,
	[School_ID] [varchar](256) NULL,
	[School_Name] [varchar](256) NULL,
	[School_Year] [varchar](256) NULL,
	[First_Name] [varchar](256) NULL,
	[Last_Name] [varchar](256) NULL,
	[Grade] [varchar](256) NULL,
	[Date_Of_Birth] [varchar](256) NULL,
	[Sex] [varchar](256) NULL,
	[Ethnicity] [varchar](256) NULL,
	[Disability_Flag] [varchar](256) NULL,
	[ELL_Flag] [varchar](256) NULL,
	[Home_Language] [varchar](256) NULL,
	[Address_Line_1] [varchar](256) NULL,
	[Address_Line_2] [varchar](256) NULL,
	[City] [varchar](256) NULL,
	[State] [varchar](256) NULL,
	[Zip] [varchar](256) NULL,
	[Home_Phone] [varchar](256) NULL,
	[Race] [varchar](256) NULL,
	[District] [varchar](256) NULL,
	[RunDate] [varchar](256) NULL,
	[SchoolForce__Grade__c] [varchar](256) NULL,
	[SchoolForce__School__c] [varchar](250) NULL,
	[SchoolForce__Individual__c] [varchar](18) NOT NULL,
	[SchoolForce__External_Id__c] [varchar](518) NULL,
	[SchoolForce__Setup__c] [varchar](250) NULL,
	[SF_ID] [varchar](18) NOT NULL,
	[SchoolForce__Reference_Id__c] [varchar](250) NULL
) ON [PRIMARY]

GO

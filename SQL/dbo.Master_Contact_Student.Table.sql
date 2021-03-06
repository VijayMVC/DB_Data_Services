USE [Data_Services]
GO
/****** Object:  Table [dbo].[Master_Contact_Student]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Contact_Student](
	[AccountID] [varchar](256) NULL,
	[RecordType] [varchar](256) NULL,
	[Student_ID] [varchar](256) NULL,
	[Last_Name] [varchar](256) NULL,
	[First_Name] [varchar](256) NULL,
	[Date_Of_Birth] [datetime] NULL,
	[Sex] [varchar](256) NULL,
	[Ethnicity] [varchar](256) NULL,
	[Disability_Flag] [varchar](256) NULL,
	[ELL_Flag] [varchar](256) NULL,
	[Home_Language] [varchar](256) NULL,
	[Address_Line_1] [varchar](256) NULL,
	[City] [varchar](256) NULL,
	[State] [varchar](256) NULL,
	[Zip] [varchar](256) NULL,
	[Home_Phone] [varchar](256) NULL,
	[Race] [varchar](256) NULL,
	[SF_ID] [varchar](18) NOT NULL
) ON [PRIMARY]

GO

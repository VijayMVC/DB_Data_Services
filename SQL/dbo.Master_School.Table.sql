USE [Data_Services]
GO
/****** Object:  Table [dbo].[Master_School]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_School](
	[School_Name] [varchar](250) NULL,
	[Account_ID] [varchar](250) NULL,
	[School_Grades] [varchar](250) NULL,
	[County] [varchar](250) NULL,
	[Source_School_Name] [varchar](250) NULL,
	[Source_School_ID] [varchar](250) NULL,
	[Setup_14_15] [varchar](250) NULL,
	[School_Year] [varchar](250) NULL
) ON [PRIMARY]

GO

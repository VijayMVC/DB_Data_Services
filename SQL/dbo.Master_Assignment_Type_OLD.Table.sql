USE [Data_Services]
GO
/****** Object:  Table [dbo].[Master_Assignment_Type_OLD]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Master_Assignment_Type_OLD](
	[ID] [int] NOT NULL,
	[Assignment_Type] [varchar](250) NULL,
	[Assignment_Type_Normalized] [varchar](250) NULL,
	[District] [varchar](250) NULL
) ON [PRIMARY]

GO

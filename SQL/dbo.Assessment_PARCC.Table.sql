USE [Data_Services]
GO
/****** Object:  Table [dbo].[Assessment_PARCC]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assessment_PARCC](
	[Student_ID] [varchar](255) NULL,
	[Test_Name] [varchar](255) NULL,
	[Level 1 - Did not yet meet expectations] [varchar](255) NULL,
	[Level 2 - Partially met expectations] [varchar](255) NULL,
	[Level 3 - Approached expectations] [varchar](255) NULL,
	[Level 4 - Met expectations] [varchar](255) NULL,
	[Level 5 - Exceeded expectations] [varchar](255) NULL,
	[Scale Score] [varchar](255) NULL,
	[Reading Scale Score] [varchar](255) NULL,
	[Writing Scale Score] [varchar](255) NULL,
	[District] [varchar](255) NULL,
	[RunDate] [varchar](255) NULL
) ON [PRIMARY]

GO

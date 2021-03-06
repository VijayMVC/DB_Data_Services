USE [Data_Services]
GO
/****** Object:  Table [dbo].[Assessments_test]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assessments_test](
	[Student_ID] [varchar](256) NULL,
	[Assessment_Name] [varchar](256) NULL,
	[Assessment_Subject_Topic] [varchar](256) NULL,
	[Date] [varchar](256) NULL,
	[Raw_Score] [varchar](256) NULL,
	[Scale_Score] [varchar](256) NULL,
	[Subscore] [varchar](256) NULL,
	[T_Score] [varchar](256) NULL,
	[Percentile] [varchar](256) NULL,
	[Profiency_Rating_Level] [varchar](256) NULL,
	[Student_Growth_Percentile] [varchar](256) NULL,
	[Student_Progress_Measure] [varchar](256) NULL,
	[District] [varchar](256) NULL,
	[RunDate] [varchar](256) NULL
) ON [PRIMARY]

GO

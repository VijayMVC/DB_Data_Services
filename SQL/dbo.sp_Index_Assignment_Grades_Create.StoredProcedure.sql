USE [Data_Services]
GO
/****** Object:  StoredProcedure [dbo].[sp_Index_Assignment_Grades_Create]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Index_Assignment_Grades_Create]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/****** Object:  Index [Student_ID]    Script Date: 11/23/2015 12:37:56 PM ******/
	CREATE NONCLUSTERED INDEX [Student_ID] ON [Data_Services].[dbo].[Assignment_Grades]
	(
		[Student_ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]

	/****** Object:  Index [Class_Section_ID]    Script Date: 11/23/2015 12:38:26 PM ******/
	CREATE NONCLUSTERED INDEX [Class_Section_ID] ON [Data_Services].[dbo].[Assignment_Grades]
	(
		[Class_Section_ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]

	/****** Object:  Index [Assignment_Type]    Script Date: 11/23/2015 12:38:51 PM ******/
	CREATE NONCLUSTERED INDEX [Assignment_Type] ON [Data_Services].[dbo].[Assignment_Grades]
	(
		[Assignment_Type] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]

	/****** Object:  Index [Marking_Period]    Script Date: 11/23/2015 12:39:15 PM ******/
	CREATE NONCLUSTERED INDEX [Marking_Period] ON [Data_Services].[dbo].[Assignment_Grades]
	(
		[Marking_Period] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]

	/****** Object:  Index [Assignment_Name]    Script Date: 11/23/2015 12:39:35 PM ******/
	CREATE NONCLUSTERED INDEX [Assignment_Name] ON [Data_Services].[dbo].[Assignment_Grades]
	(
		[Assignment_Name] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]

END

GO

USE [Data_Services]
GO
/****** Object:  View [dbo].[vw_Master_Assignment_Library_17]    Script Date: 12/1/2016 8:57:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_Master_Assignment_Library_17]
AS
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Homework' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%Math%Homework%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Homework' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%Math%Homework%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Homework' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%Math%Homework%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Homework' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%Math%Homework%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Homework' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%Math%Homework%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Homework' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%Math%Homework%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Homework' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%Math%Homework%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Homework' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%ELA%Homework%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Homework' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%ELA%Homework%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Homework' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%ELA%Homework%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Homework' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%ELA%Homework%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Homework' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%ELA%Homework%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Homework' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%ELA%Homework%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Homework' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%ELA%Homework%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Quiz' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%Math%Quiz%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Quiz' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%Math%Quiz%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Quiz' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%Math%Quiz%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Quiz' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%Math%Quiz%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Quiz' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%Math%Quiz%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Quiz' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%Math%Quiz%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Quiz' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%Math%Quiz%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Quiz' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%ELA%Quiz%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Quiz' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%ELA%Quiz%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Quiz' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%ELA%Quiz%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Quiz' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%ELA%Quiz%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Quiz' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%ELA%Quiz%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Quiz' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%ELA%Quiz%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Quiz' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%ELA%Quiz%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Test' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%Math%Test%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Test' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%Math%Test%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Test' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%Math%Test%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Test' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%Math%Test%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Test' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%Math%Test%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Test' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%Math%Test%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Test' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%Math%Test%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Test' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%ELA%Test%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Test' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%ELA%Test%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Test' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%ELA%Test%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Test' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%ELA%Test%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Test' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%ELA%Test%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Test' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%ELA%Test%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Test' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%ELA%Test%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Project' Assignment_Type, 'Math' Section_Type, 'Math'
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%Math%Project%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Project' Assignment_Type, 'Math' Section_Type, 'Math'
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%Math%Project%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Project' Assignment_Type, 'Math' Section_Type, 'Math'
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%Math%Project%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Project' Assignment_Type, 'Math' Section_Type, 'Math'
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%Math%Project%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Project' Assignment_Type, 'Math' Section_Type, 'Math'
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%Math%Project%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Project' Assignment_Type, 'Math' Section_Type, 'Math'
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%Math%Project%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Project' Assignment_Type, 'Math' Section_Type, 'Math'
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%Math%Project%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Project' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%ELA%Project%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Project' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%ELA%Project%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Project' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%ELA%Project%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Project' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%ELA%Project%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Project' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%ELA%Project%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Project' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%ELA%Project%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Project' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%ELA%Project%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Uncategorized' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%Math%Uncategorized%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Uncategorized' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%Math%Uncategorized%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Uncategorized' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%Math%Uncategorized%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Uncategorized' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%Math%Uncategorized%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Uncategorized' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%Math%Uncategorized%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Uncategorized' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%Math%Uncategorized%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Uncategorized' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%Math%Uncategorized%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Uncategorized' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%ELA%Uncategorized%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Uncategorized' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%ELA%Uncategorized%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Uncategorized' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%ELA%Uncategorized%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Uncategorized' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%ELA%Uncategorized%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Uncategorized' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%ELA%Uncategorized%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Uncategorized' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%ELA%Uncategorized%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Uncategorized' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%ELA%Uncategorized%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Classwork' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%Math%Classwork%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Classwork' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%Math%Classwork%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Classwork' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%Math%Classwork%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Classwork' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%Math%Classwork%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Classwork' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%Math%Classwork%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Classwork' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%Math%Classwork%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Classwork' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%Math%Classwork%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Classwork' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%ELA%Classwork%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Classwork' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%ELA%Classwork%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Classwork' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%ELA%Classwork%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Classwork' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%ELA%Classwork%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Classwork' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%ELA%Classwork%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Classwork' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%ELA%Classwork%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Classwork' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%ELA%Classwork%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Participation' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%Math%Participation%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Participation' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%Math%Participation%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Participation' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%Math%Participation%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Participation' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%Math%Participation%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Participation' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%Math%Participation%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Participation' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%Math%Participation%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Participation' Assignment_Type, 'Math' Section_Type, 'Math' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%Math%Participation%'
UNION
SELECT     ID, '1' Marking_Period, 'Q1' Marking_Period_2, 'Participation' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%1%ELA%Participation%'
UNION
SELECT     ID, '2' Marking_Period, 'Q2' Marking_Period_2, 'Participation' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%2%ELA%Participation%'
UNION
SELECT     ID, '3' Marking_Period, 'Q3' Marking_Period_2, 'Participation' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%3%ELA%Participation%'
UNION
SELECT     ID, '4' Marking_Period, 'Q4' Marking_Period_2, 'Participation' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Qtr%4%ELA%Participation%'
UNION
SELECT     ID, '1' Marking_Period, 'T1' Marking_Period_2, 'Participation' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%1%ELA%Participation%'
UNION
SELECT     ID, '2' Marking_Period, 'T2' Marking_Period_2, 'Participation' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%2%ELA%Participation%'
UNION
SELECT     ID, '3' Marking_Period, 'T3' Marking_Period_2, 'Participation' Assignment_Type, 'ELA' Section_Type, 'ELA/Literacy' Section_Type_2
FROM         SDW_Stage_Prod_17.dbo.Assignment_Lib__c
WHERE     Name LIKE '%Tri%3%ELA%Participation%'



GO

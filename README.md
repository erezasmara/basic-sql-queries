#  SQL BASIC (commands) - Structured Query language (commands)

## 1) Work on Objects: Database, tables , columns (data types)
- Objects action: CREATE , ALTER , DROP (DDL - Data Definition language)

```sql
/*Crate new sql DB minimal syntax*/
CREATE DATABASE SimpleDbCreation

/*
Crate new sql DB complete syntax
included logs & definitions
*/
CREATE DATABASE Uni_erez    
ON (NAME = 'Uni_erez_Data', 
    FILENAME = 'C:\erez_sql\Uni_erez_Data.MDF' , 
    SIZE = 20, 
    MaxSize= UNLIMITED ,
    FILEGROWTH = 10%) 
LOG ON (NAME = 'Uni_erez_Log', 
        FILENAME = 'C:\erez_sql\Uni_erez_Log.LDF' ,
        SIZE = 1, 
        FILEGROWTH = 10%)
COLLATE Hebrew_CI_AS
GO

/*use dB*/
Use Uni_erez 
go

/*Drop database*/
Use Master /*switch to other db before remove the right dB*/
GO
Drop Database Uni_erez
GO


/*define global data structure for tables */
EXEC sp_addtype '<Type_name>','smallint','not null'

/*Create new table syntax with 4 column*/
CREATE TABLE Students (
 Student_Id int NOT NULL,
 FirstName char(10),
 LastName char(10),
 Birthday datetime NOT NULL,
)

/*Create table with spacial column */
EXEC sp_addtype 'evenNum','smallint','not null'

CREATE TABLE book (
 BookId int NOT NULL,
 Student_Id int NOT NULL,
 BookName char(10),
 TotalEvenPage evenNum NOT NULL,
)

/***Modify table object actions***/
/*add new column to exist table*/
ALTER TABLE Students
ADD newColumn char(10)

/*modify exist table , adding a column*/
ALTER TABLE Students 
ALTER COLUMN newColumn varchar(10)

/*drop exist column*/
ALTER TABLE Students
DROP COLUMN newColumn

/***Constraint Type and Keys***/

/*Create table with column as a primary key*/
CREATE TABLE  StudentTableExample(
studentId int NOT NULL CONSTRAINT keyName PRIMARY KEY,
studentName varchar(16) NOT NULL 
)

/*Change exist column to primary key*/
ALTER TABLE  Students
ADD	
CONSTRAINT  keyName  PRIMARY KEY (Student_Id)

/* FOREIGN KEY */
/*
note: before set a FOREIGN KEY between two keys, make sure they 
are both primary keys
*/
ALTER TABLE Students
ADD
CONSTRAINT FK_studentId FOREIGN KEY (Student_Id)
REFERENCES Students1 (Student_Id)


/*change or adding column with conditions*/
ALTER TABLE Student 
ADD
CONSTRAINT Address_  DEFAULT 'Hadera' FOR Address_,
CONSTRAINT Phone_area CHECK (len ( Phone_area ) > 2),
CONSTRAINT Phone UNIQUE (Phone)

```
## 2) Work on Data:MODIFY rows tables (DML - Data Manipulation Language)
- DATA action: INSERT , UPDATE , DELETE
```sql

set DateFormat ymd
/* Inserting data to the tables */
INSERT dbo.Students (Student_Id,FirstName,LastName,Birthday) VALUES (1,'EREZ','ASMARA','1900/1/12')

/*Delete data from tables*/
DELETE FROM Students WHERE Student_Id = 1

/* Update row/data from tables */
UPDATE  Students
SET FirstName='EREZ' , LastName = 'ASMARA'
WHERE Student_Id = 1
```
## 3) Work on Data: SELECT data and information(DML - Data Manipulation Language)
- DATA action: SELECT(5) , FROM(1) , WHERE(2), GROUP BY(3), HAVING(4),ORDER BY(6)
- Operators :  !=,<>,+,<,>,>=,<= ,BETWEEN,AND,OR,NOT,IN,NOT IN,LIKE,IS NULL,IS NOT NULL

```sql
/*--FULL SELECT EXAMPLE
-------------------------------------------------------------------------
SELECT   [DISTINCT]
     TOP  n  [PERCENT]  [WITH TIES] ]  select_list
     FROM  [table_sources]
     WHERE  [search_conditions]  (IS NULL,NOT NULL,LIKE,NOT LIKE,IN,NOT IN,=,<, ...)
     GROUP  BY  [[ ALL ]  group_by_expression1, group_by_expression2,…]
     HAVING   [search_conditions  ]   ]
     ORDER BY  [column_name1 [ASC | DESC ] , column_name2  [ASC | DESC ],…]
    BY  [expression1, expression2,…]
--------------------------------------------------------------------------
TOP n => show first n rows
AS => changing row title ,'SELECT FirstName As name'
DISTINCT => return result with out duplicate rows
ASC | DESC => sort in ascending or descending order
...
'example with operations BETWEEN, LIKE'
SELECT *
FROM Student
WHERE Year BETWEEN 1990 AND 2000 
ORDER BY Year
...
'example with operation like'
SELECT *
FROM  Student
WHERE firstName LIKE '%erez%' // get all the string that continue 'erez'
...

NOTES:
------
A) more sql system function
SELECT DB_NAME()
SELECT USER_NAME()
SELECT @@SERVERNAME
SELECT @@VERSION
-date function 
SELECT GETDATE()
SELECT YEAR(GETDATE())
SELECT MONTH(GETDATE())
SELECT DAY(GETDATE())
SELECT DATENAME(MONTH,GETDATE())

!their is more functions

B) understanding 'literals' concept !!

C) Create ERD diagram base tables:
right click 'Database Diagrams' folder -> 'new Database diagram'

D) Generate SELECT query:
--https://www.youtube.com/watch?v=jGEoHJWafOM
*/

```
## 4) Aggregation functions
- function(column) => SUM(),MAX(),MIN(),COUNT(),AVG()...
```sql


--Example for simple syntax of aggregation function
SELECT SUM(Mark_Sem_A) AS total_marks
FROM Marks
```
## 5) VIEWS , UNION
- VIEWS - is a virtual table whose contents are defined  by a query good for blocking access to the tables 
  - 'ORDER BY' cant used with views syntax
  -  Generate automate view query || right click on view folder -> new view -> add your definition.
  - Creating view (saved in view dir)  
- UNION - MERGE two results of select queries
```sql
--VIEW example:
CREATE VIEW Sample_view 
AS
SELECT *
FROM [dbo].[Cities]

-- executing to view that we creating.
SELECT *
FROM Sample_view

--UNION example:
--all table information
SELECT *
FROM [dbo].[Cities]

--septate the table and merge the result with union action
SELECT *
FROM [dbo].[Cities]
WHERE City_Code <= 4
UNION
SELECT *
FROM [dbo].[Cities]
WHERE City_Code > 4 

```
## 6) GROUP BY , HAVING ,CAST
- reminder aggregation is a function e.g AVG,
```sql

/*
NOTES:
--https://www.youtube.com/watch?v=8pD3xh3MlNg

*/

---Example group by having
--getting all marks
SELECT *
FROM [dbo].[Marks]

-- group average result by course code 
SELECT Course_Code ,AVG(Mark_Sem_A) as avg_marks_sem_a
FROM [dbo].[Marks]
GROUP BY Course_Code

--filter result with having
SELECT Course_Code ,AVG(Mark_Sem_A) as avg_marks_sem_a
FROM [dbo].[Marks]
GROUP BY Course_Code
HAVING  AVG(Mark_Sem_A) > 70

---CAST EXAMPLE
SELECT Course_Code ,cast( AVG(Mark_Sem_A) AS int) AS avg_marks_sem_a
FROM [dbo].[Marks]
GROUP BY Course_Code
HAVING  AVG(Mark_Sem_A) > 70

```
## 7) JOIN
```sql

/*
לסוגיהם(
 JOIN ע"י
יוצרים חיבור בין טבלאות כדי לייצר פלט אחד המכיל שורות ועמודות משתיים או יותר
מהטבלאות המחוברות. דבר זה נעשה ע"י שימוש במילים השמורות
JOIN ו- ON
בתוך תת-הפקודה
FROM
.המילה השמורה 
JOIN
מציינת ששתי טבלאות הן מחוברות ואיך לחבר אותן.
המילה השמורה 
ON
מציינת את התנאי של החיבור.

תחביר חלקי של הפקודה:
SELECT column_name1 , column_name2,...
FROM table_source1
[ INNER | { LEFT | RIGHT | FULL } [ OUTER ] ] JOIN
table_source2
ON search_condition



*/
---Examples:

SELECT *
FROM [dbo].[Marks]

SELECT *
FROM [dbo].[Students]

--INNER JOIN
SELECT  First_Name,Last_Name,Marks.Course_Code, Marks.Mark_Sem_A
     FROM  Students
      INNER JOIN  Marks
         ON  Students.Student_Id = Marks.Student_Id

---OUTER  JOIN
--LEFT  OUTER  JOIN
SELECT  First_Name,Last_Name,Marks.Course_Code, Marks.Mark_Sem_A
     FROM  Students
      LEFT  OUTER  JOIN  Marks
         ON  Students.Student_Id = Marks.Student_Id


--RIGHT  OUTER  JOIN
SELECT  First_Name,Last_Name,Marks.Course_Code, Marks.Mark_Sem_A
     FROM  Students
      RIGHT  OUTER  JOIN  Marks
         ON  Students.Student_Id = Marks.Student_Id

--FULL  OUTER  JOIN
SELECT  First_Name,Last_Name,Marks.Course_Code, Marks.Mark_Sem_A
     FROM  Students
      FULL  OUTER  JOIN  Marks
         ON  Students.Student_Id = Marks.Student_Id

--CROSS JOIN
SELECT  First_Name,Last_Name,Marks.Course_Code, Marks.Mark_Sem_A
     FROM  Students
        CROSS JOIN   Marks
queries
```

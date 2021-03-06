
/*
Use Master
GO
Drop Database College
GO
*/
   
CREATE DATABASE College  
ON (NAME = 'College_Data', 
    FILENAME = '~\Erez\College_Data.MDF' , 
    SIZE = 10, 
    FILEGROWTH = 10%) 
LOG ON (NAME = 'College_Log', 
        FILENAME = '~\Erez\College_Log.LDF' ,
        SIZE = 5, 
        FILEGROWTH = 10%)
COLLATE Hebrew_CI_AS
GO

Use College 
GO

-- הגדרת סוגי משתנים
EXEC sp_addtype 'Us_Code', 'smallint', 'not null'
EXEC sp_addtype 'Us_Desc_Names', 'varchar (30)', 'not null'
EXEC sp_addtype 'Us_Desc_Names_Heb', 'nvarchar (30)', 'not null'
EXEC sp_addtype 'Us_Id', 'char (10)', 'not null'
EXEC sp_addtype 'Us_Names', 'varchar (16)', 'not null'
EXEC sp_addtype 'Us_Names_Heb', 'nvarchar (16)', 'not null'
EXEC sp_addtype 'Us_Phone', 'char (9)', 'not null'
EXEC sp_addtype 'ser', 'smallint', 'not null'
GO

-- הגדרת טבלאות
CREATE TABLE [Departments] (
	[Department_Code] [Us_Code] ,
	[Department_Name] [Us_Desc_Names_Heb] ,
	[Manager] [Us_Names_Heb] NULL 	  
)
GO

CREATE TABLE [Courses] (
	[Course_Code] [int] NOT NULL ,
	[Course_Name] [Us_Desc_Names_Heb] ,
	[Department_Code] [Us_Code] ,
	[Credits] [decimal](5, 1) NOT NULL ,
	[Lab] [bit] NOT NULL 	
) 
GO


CREATE TABLE [Students] (
	[Student_Id] [Us_Id] ,
	[Last_Name] [Us_Names_Heb] ,
	[First_Name] [Us_Names_Heb] ,
	[Birth_Date] [date] NULL ,
	[Sex] [bit] NOT NULL ,
	[Picture] [image] NULL ,
	[Address] [Us_Desc_Names_Heb] NULL ,
	[City_Code] [int] NULL ,
	[Telephone] [Us_Phone] NULL ,
	[Matriculation] [decimal](5, 1) NULL ,
	[Psychometric] [decimal](5, 1) NULL ,
	[Student_No] [int] NOT NULL ,
	[Registration] [date] NULL
) 
GO


CREATE TABLE [Teachers] (
	[Teacher_Id] [Us_Id] ,
	[Last_Name] [Us_Names_Heb] ,
	[First_Name] [Us_Names_Heb] ,
	[Academic_Degree] [smallint]  ,
	[Pelephone] [Us_Phone] NULL ,
	[E_Mail] [varchar] (50) NULL ,
	[Start_Date] [date] NULL
) 
GO


CREATE TABLE [Teachers_In_Courses] (
	[Course_Code] [int] NOT NULL ,
	[Teacher_Id] [Us_Id] 
)
GO


CREATE TABLE [Courses_On_Air] (
	[Course_Code] [int] Not Null,
	[Open_Date] [date] NOT NULL ,
	[End_Date] [date] NOT NULL ,
	[Teacher_Id] [Us_Id] ,
	[Building_Code] [Us_Code] NULL ,
	[Class_Code] [Us_Code] NULL ,
	[Week_Day] [char] (1) NULL ,
	[Begin_Hour] [time] NULL ,
	[End_Hour] [time] NULL
)
GO

CREATE TABLE Classes
 (  Building_code Us_Code ,
    Class_code Us_code ,
    Capacity int null ) 
go

CREATE TABLE Cities
  ( City_Code int not null ,
    City_Name Us_Desc_Names_Heb null )
go

CREATE TABLE [dbo].[Buildings] (
	[Building_Code] [Us_Code] ,
	[Building_Name] [Us_Desc_Names_Heb] NULL 
)
GO

CREATE TABLE [Marks] (
	[Student_Id] [Us_Id] ,
	[Course_Code] [int] NOT NULL ,
	[Open_Date] [date] NOT NULL ,
	[Mark_Sem_A] [decimal](5, 1) NULL ,
	[Mark_Sem_B] [decimal](5, 1) NULL
)
GO

-- הגדרת מפתחות ראשיים
ALTER TABLE Students 
ADD
CONSTRAINT [PK_Students] PRIMARY KEY (Student_Id)
GO

ALTER TABLE Classes 
ADD
Constraint Con_Class_Code Primary key ( Building_Code , Class_Code ) 
GO

ALTER TABLE Marks
ADD
CONSTRAINT [PK_Marks] PRIMARY KEY   
	       (Student_Id,Course_Code,Open_Date)
GO

ALTER TABLE Teachers
ADD
CONSTRAINT [PK_Teachers] PRIMARY KEY (Teacher_Id)
GO

ALTER TABLE Courses_On_Air 
ADD 
CONSTRAINT [PK_Courses_On_Air] PRIMARY KEY (Course_Code,Open_Date)
GO

ALTER TABLE Buildings 
add
CONSTRAINT [PK_Buildings] PRIMARY KEY (Building_Code) 
GO

ALTER TABLE Cities
ADD
CONSTRAINT [PK_Cities] PRIMARY KEY (City_Code) 
GO

ALTER TABLE Departments
ADD
CONSTRAINT PK_Departments PRIMARY KEY (Department_Code)
GO

ALTER TABLE Courses
ADD
CONSTRAINT [PK_Courses] PRIMARY KEY (Course_Code)
GO

ALTER TABLE Teachers_In_Courses
ADD
CONSTRAINT [PK_Teachers_In_Courses] PRIMARY KEY  (Course_Code,Teacher_Id)
GO

-- הגדרת מפתחות זרים - קשרי גומלין לנירמול
ALTER TABLE Students
ADD
CONSTRAINT [Con_fk_City_Code] FOREIGN KEY 
          (City_Code) REFERENCES Cities (City_Code)
go

ALTER TABLE Courses_On_Air
ADD
CONSTRAINT [fk_courses_Courses] FOREIGN KEY 
    	    (Course_Code) REFERENCES Courses (Course_Code)
go

ALTER TABLE Marks
ADD
CONSTRAINT [fk_marks_students] FOREIGN KEY 
	       (Student_Id) REFERENCES 
                Students (Student_Id),
CONSTRAINT [fk_marks_on_Air] FOREIGN KEY 
	       (Course_Code,Open_Date) REFERENCES 
                Courses_On_Air (Course_Code,Open_Date)
go


ALTER TABLE Classes
ADD
CONSTRAINT con_fk_Building_code FOREIGN KEY 
	    (Building_Code) REFERENCES Buildings (Building_Code)
go

ALTER TABLE Courses
ADD
CONSTRAINT [fk_Course_Dep] FOREIGN KEY 
	   (Department_Code) REFERENCES Departments (Department_Code)
go

ALTER TABLE Teachers_IN_Courses
ADD
CONSTRAINT [fk_teachers_courses_teac] FOREIGN KEY 
	   (Teacher_Id) REFERENCES Teachers (Teacher_Id)
go

ALTER TABLE Courses_On_Air
ADD
CONSTRAINT [fk_courses_teach] FOREIGN KEY 
	    (Course_Code,Teacher_Id) REFERENCES Teachers_In_Courses (Course_Code,Teacher_Id),
CONSTRAINT [fk_on_air_Dep] FOREIGN KEY 
	    (Building_Code,Class_Code) REFERENCES Classes (Building_Code,Class_Code)
go


-- הזנת נתונים לטבלאות
Insert dbo.Cities (City_Code,City_Name) Values (1,'נתניה')
Insert dbo.Cities (City_Code,City_Name) Values (2,'חיפה')
Insert dbo.Cities (City_Code,City_Name) Values (3,'חדרה')
Insert dbo.Cities (City_Code,City_Name) Values (4,'אילת')
Insert dbo.Cities (City_Code,City_Name) Values (5,'תל אביב')
Insert dbo.Cities (City_Code,City_Name) Values (6,'באר שבע')
GO

Insert dbo.Buildings (Building_Code , Building_Name) Values (1 , 'בית הנדסה')
Insert dbo.Buildings (Building_Code , Building_Name) Values (2 , 'בית מנהך עסקים')
Insert dbo.Buildings (Building_Code , Building_Name) Values (3 , 'בניין כלכלה')
GO

Insert dbo.Departments (Department_Code,Department_Name,Manager) Values (10,'הנדסה','גדי')
Insert dbo.Departments (Department_Code,Department_Name,Manager) Values (11,'הנדסאים','תמי')
Insert dbo.Departments (Department_Code,Department_Name,Manager) Values (12,'מדעי החברה','זאב')
Insert dbo.Departments (Department_Code, Department_Name, Manager) values (21,'מחשבים', 'בלומה')
Insert dbo.Departments (Department_Code, Department_Name, Manager) values (22,'מנהל עסקים', 'לאה')
Insert dbo.Departments (Department_Code, Department_Name, Manager) values (23,'כלכלה', 'זאב')
Insert dbo.Departments (Department_Code, Department_Name, Manager) values (24,'תיירות', 'גינזבורג')
Insert dbo.Departments (Department_Code, Department_Name, Manager) values (25,'מדעי התנהגות', 'נטע')
GO

Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (1,1,50)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (1,2,45)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (1,3,120)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (1,4,50)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (2,1,50)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (2,2,24)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (3,1,60)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (3,3,50)
Insert dbo.Classes (Building_Code, Class_Code, Capacity) values (3,4,50)
GO

Set DateFormat dmy
GO

Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, Address, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) Values ('11111111','כהן','יוסי','1/1/1980',0,'הרצל 58', 1,'09864214',95,580,1234,'1/1/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, Address, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) values ('22222222','לוי','דפנה','18/6/1975',1,'נחשון',1,'02987456',100,700,1456,'2/2/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, Address, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) values ('33333333','לוי','דוד','18/6/1985',0,'בית שאן',3,'04987456',100,700,2345,'2/2/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, Address, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) Values ('44444444','כהן','רינה','1/1/1983',0,'כפר מונאש', 1,'09844214',95,580,2478,'1/1/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, Address, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) values ('55555555','לוי','אבי','18/6/1984',1,'כפר חיים',1,'02988456',100,700,1478,'5/2/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) values ('66666666','תמיר','דוד','18/6/1988',0,3,'02933456',90,500,2589,'5/2/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) values ('77777777','אבירם','משה','25/6/1975',0,2,'03966456',80,600,2365,'7/2/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) values ('88888888','לוי','עירית','18/6/1987',0,3,'03985656',100,6780,7854,'8/2/2018')
Insert dbo.Students (Student_Id, Last_Name, First_Name, Birth_Date, Sex, City_Code, Telephone, Matriculation, Psychometric, Student_No, Registration) values ('99999999','אבוטבול','דני','18/6/1986',0,3,'03987656',100,6780,7354,'8/2/2018')
GO

Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (1,'כלכלת ישראל',21,3,0)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (2,'סטטחסטחקה',21,3,0)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (3,'מתמטיקה',22,3,1)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (4,'מחשבים',22,3,1)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (5,'Sql Server',22,3,1)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (6,'אלגברה',21,3,0)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (7,'C++',22,3,1)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (8,'English',21,3,0)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (9,'Logica',21,3,0)
Insert dbo.Courses (Course_Code, Course_Name, Department_Code, Credits, Lab) values (10,'Math',21,3,0)
Go

Insert dbo.Teachers (Teacher_Id, Last_Name, First_Name, Academic_Degree, Pelephone, E_Mail, Start_Date) values ('11223344','גלעדי','חנה',1,'052987654','abcd@hotmail.co.il','1/1/1990')
Insert dbo.Teachers (Teacher_Id, Last_Name, First_Name, Academic_Degree, Pelephone, E_Mail, Start_Date) values ('22334455','צוק','תמי',2,'053487654','zuk@hotmail.co.il','1/1/1985')
Insert dbo.Teachers (Teacher_Id, Last_Name, First_Name, Academic_Degree, Pelephone, E_Mail, Start_Date) values ('33445566','ארבל','יוסי',2,'052456788','aaa@hotmail.co.il','2/1/1988')
Insert dbo.Teachers (Teacher_Id, Last_Name, First_Name, Academic_Degree, Pelephone, E_Mail, Start_Date) values ('44556677','תמיר','דני',1,'052345677','bbb@hotmail.co.il','3/1/1985')
Insert dbo.Teachers (Teacher_Id, Last_Name, First_Name, Academic_Degree, Pelephone, E_Mail, Start_Date) values ('55667788','אבירם','תמי',2,'052678965','ccc@hotmail.co.il','4/1/1986')
Insert dbo.Teachers (Teacher_Id, Last_Name, First_Name, Academic_Degree, Pelephone, E_Mail, Start_Date) values ('66778899','ברוך','רות',1,'052543233','ddd@hotmail.co.il','5/1/1978')
GO

Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (1 , '11223344')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (1 , '22334455')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (1 , '33445566')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (2 , '33445566')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (2 , '44556677')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (2 , '55667788')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (3 , '11223344')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (3 , '22334455')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (3 , '33445566')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (4 , '33445566')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (4 , '44556677')
Insert dbo.Teachers_In_Courses (Course_Code, Teacher_Id)  values (4 , '55667788')
GO

Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (1,'1/10/2018','25/2/2018','11223344',1,1,'א','8:00','10:00')
Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (2,'1/11/2018','25/2/2018','55667788',1,1,'א','9:00','11:00')
Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (1,'1/12/2018','25/2/2018','11223344',1,1,'ב','10:00','12:00')
Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (2,'1/12/2018','25/2/2018','33445566',1,1,'ב','9:00','11:00')
Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (3,'1/10/2018','25/2/2018','11223344',2,1,'א','11:00','13:00')
Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (3,'1/11/2018','25/2/2018','22334455',2,1,'א','9:00','11:00')
Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (4,'1/10/2018','25/2/2018','33445566',3,1,'ב','8:00','10:00')
Insert dbo.Courses_On_Air (Course_Code, Open_Date, End_Date, Teacher_Id, Building_Code, Class_Code, Week_Day, Begin_Hour, End_Hour) values (4,'1/11/2018','25/2/2018','44556677',1,1,'ב','16:00','18:00')
GO

Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('11111111',1,'1/10/2018',80,90)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('11111111',2,'1/11/2018',85,95)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('11111111',3,'1/10/2018',68,45)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('11111111',2,'1/12/2018',75,0)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('22222222',1,'1/10/2018',88,98)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('22222222',2,'1/11/2018',89,99)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('33333333',1,'1/10/2018',82,95)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('33333333',2,'1/11/2018',88,95)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('44444444',1,'1/10/2018',78,50)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('44444444',2,'1/11/2018',45,50)
Insert dbo.Marks (Student_Id, Course_Code, Open_Date, Mark_Sem_A, Mark_Sem_B)  values ('33333333',3,'1/10/2018',52,48)
GO


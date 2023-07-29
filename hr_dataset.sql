-- create database
CREATE DATABASE hr_dataset;

-- use the created dataset
USE hr_dataset;

-- upload employee_details.csv
-- set EmpID as Primary Key
ALTER TABLE employee_details
MODIFY EmpID INT PRIMARY KEY;

-- upload employee_status.csv
-- set Termd as Primary Key
ALTER TABLE employee_status
MODIFY Termd INT PRIMARY KEY;

-- TASK 1
-- The HR wants to know how many employees on the data set 
-- is ACTIVE
SELECT COUNT(EmpID) as "TOTAL ACTIVE"
FROM employee_details LEFT JOIN employee_status on employee_details.Termd = employee_status.Termd
WHERE Employee_status = "Active"; -- result is 207 Employees

-- TASK 2
-- The HR wants to know the average salary of  all the active employees
SELECT AVG(Salary) as "AVG SALARY"
FROM employee_details LEFT JOIN employee_status on employee_details.Termd = employee_status.Termd
WHERE Employee_status = "Active"; -- result is 70694.03

-- TASK 3
-- The HR wants to know how many Active Employees have above Average Salaries
SELECT COUNT(EmpID) as "ABOVE AVG SALARY COUNT"
FROM employee_details LEFT JOIN employee_status on employee_details.Termd = employee_status.Termd
WHERE (Employee_status = "Active" AND Salary >  
(SELECT AVG(Salary)
FROM employee_details LEFT JOIN employee_status on employee_details.Termd = employee_status.Termd
WHERE Employee_status = "Active")
); -- the result is 58

-- TASK 4
-- The HR wants to know which active employees has above average salaries
-- The HR wants to know their salaries
-- The HR wants to know thier positions
-- The HR wants thier name on alphebetical ascending order

-- Import Position.csv
-- Set PositionID as Primary Key
ALTER TABLE position
MODIFY PositionID INT PRIMARY KEY;
-- Create the Query
SELECT EmpID, Employee_Name, Salary, Position, b.Employee_status as "Status"
FROM employee_details AS a LEFT JOIN employee_status AS b ON a.Termd = b.Termd
LEFT JOIN position AS c ON a.PositionID = c.PositionID
WHERE (Employee_status = "Active" AND Salary > 
(SELECT AVG(Salary)
FROM employee_details AS a LEFT JOIN employee_status AS b ON a.Termd = b.Termd
WHERE Employee_status = "Active"))
ORDER BY Employee_Name ASC; -- results on results/Task4.csv

-- TASK 5
-- According to HR the following codes represent
-- 0 = Single
-- 1 = Married
-- 2 = Divorced
-- 3 = Separated
-- 4 = Widowed
-- The HR asked us to create table from this data
-- Create Table
CREATE TABLE marital_codes(
m_code INT PRIMARY KEY,
m_represent VARCHAR(10) UNIQUE NOT NULL
);
-- Insert Data
INSERT INTO marital_codes(m_code, m_represent)
VALUES (0,"Single"),(1,"Married"),(2,"Divorced"),(3,"Separated"),(4,"Widowed");

SELECT * FROM marital_codes ORDER BY m_code ASC; -- results in results/Task5.csv

-- Task 6
-- The company wants to give gifts to active married employees for the valentines day
-- The company will give chocolates for the female
-- The company will give wines for the male
-- The HR has the following codes
-- 1 = Male
-- 0 = Female
-- The HR wants to list of Married Active employees and their Gender
-- HR wants you to provide the Employee ID, Name, Gender, Civil Status, State, Department
SELECT EmpID AS "ID", Employee_Name AS "Name",
CASE 
	WHEN GenderID IN (1) THEN "MALE"
    WHEN GenderID IN (0) THEN "FEMALE"
    ELSE "UNKNOWN" END AS "Gender",
    m_represent AS "Civil Status", State, Department
FROM employee_details AS ed LEFT JOIN marital_codes AS mc ON ed.MaritalStatusID = mc.m_code
WHERE m_represent = "Married"
ORDER BY EmpID ASC; -- results in results/Task6.csv

-- TASK 7
-- Refering to task 6
-- The HR said the procurement team wants to know how many chocolates and wines to buy
-- The HR wants to know how many males and females
SELECT CASE 
	WHEN GenderID IN (1) THEN "MALE"
    WHEN GenderID IN (0) THEN "FEMALE"
    ELSE "UNKNOWN" END AS "Gender", COUNT(GenderID) AS COUNT
FROM employee_details AS ed LEFT JOIN marital_codes AS mc ON ed.MaritalStatusID = mc.m_code
WHERE m_represent = "Married"
GROUP BY GenderID; -- results give 72 Females and 52 Males



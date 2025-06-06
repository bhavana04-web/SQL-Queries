--Retrieve details of employees whose VacationHours is greater than 20 and less than 60. Table: HumanResources.Employee--
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.Employee WHERE VacationHours>20 AND VacationHours<60;

--List products with StandardCost between 500 and 1000 or exactly equal to 1200. Table: Production.Product--
SELECT * FROM Production.Product 
SELECT * FROM Production.Product WHERE StandardCost BETWEEN 500 AND 1000 OR StandardCost=1200

--Display the top 10 most expensive products sorted by ListPrice.
--Table: Production.Product--
SELECT * FROM Production.Product
SELECT Name,ListPrice FROM Production.Product ORDER BY ListPrice DESC;
--List employees sorted by JobTitle and then by HireDate.
--Table: HumanResources.Employee
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.Employee ORDER BY JobTitle

--Count how many employees work in each department.
--Table: HumanResources.EmployeeDepartmentHistory

SELECT * FROM HumanResources.EmployeeDepartmentHistory

SELECT NumberOfCustomers=COUNT(BusinessEntityID),DepartmentID FROM HumanResources.EmployeeDepartmentHistory GROUP BY DepartmentID ORDER BY DepartmentID;

--Get the average ListPrice for each product subcategory.
--Table: Production.Product
SELECT * FROM Production.Product
SELECT ProductSubcategoryID,AVG(ListPrice) FROM Production.Product GROUP BY ProductSubcategoryID ORDER by ProductSubcategoryID;

--Show uppercased customer names and reversed version of their LastName.
--Table: Person.Person

SELECT * FROM Person.Person
SELECT UpperCasedFirstName=UPPER(FirstName),ReversedLastName=REVERSE(LastName) FROM Person.Person 

--Extract the first 3 characters of each product name.
--Table: Production.Product
SELECT * FROM Production.Product
SELECT threeLettersofProductName=LEFT(Name,3) FROM Production.Product

--Round the StandardCost of each product to the nearest hundred.
--Table: Production.Product

SELECT * FROM Production.Product

SELECT RoundedStandardCost=ROUND(StandardCost,2) FROM Production.Product

--Get the highest, lowest, and average hourly rate for employees.
--Table: HumanResources.EmployeePayHistory

SELECT * FROM HumanResources.EmployeePayHistory
SELECT HighestRate=MAX(Rate),LowestRate=MIN(Rate),AverageRate=AVG(Rate) FROM HumanResources.EmployeePayHistory

--List employee names along with their department names.
--Tables: Person.Person, HumanResources.Employee, HumanResources.EmployeeDepartmentHistory, HumanResources.Department
SELECT * FROM Person.Person;
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;
SELECT * FROM HumanResources.Department;
SELECT p.FirstName,DepartmentName=d.Name FROM Person.Person as p JOIN HumanResources.EmployeeDepartmentHistory as dh 
ON p.BusinessEntityID=dh.BusinessEntityID JOIN HumanResources.Department as d ON 
dh.DepartmentID=d.DepartmentID;

--Show customer names with their order numbers.
--Tables: Sales.SalesOrderHeader, Sales.Customer, Person.Person

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.Customer
SELECT * FROM Person.Person
SELECT FirstName,SalesOrderID FROM Sales.SalesOrderHeader as s JOIN Person.Person as c
ON s.ModifiedDate=c.ModifiedDate


--Find people whose first names start with 'A' and end with 'e'.
--Table: Person.Person

SELECT DISTINCT(FirstName) FROM Person.Person WHERE FirstName LIKE 'A%e';

--List products in categories 'Bikes', 'Components', or 'Clothing'.
--Tables: Production.Product, Production.ProductSubcategory, Production.ProductCategory


SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Production.Product

SELECT c.Name,p.Name FROM Production.ProductCategory as c JOIN Production.ProductSubcategory as s 
ON c.ProductCategoryID=s.ProductCategoryID JOIN Production.Product as p ON 
s.ProductSubcategoryID=p.ProductSubcategoryID
WHERE c.Name IN ('Bikes','Components','Clothing');

--Retrieve products not in the subcategories 1, 2, and 3.
--Table: Production.Product

SELECT * FROM Production.Product
SELECT ProductSubCategoryID,Name FROM Production.Product WHERE ProductSubcategoryID NOT IN (1,2,3);


--Show orders placed between Jan 1 and March 31, 2014.
--Table: Sales.SalesOrderHeader

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderHeader WHERE OrderDate BETWEEN '01-01-2014'AND '03-31-2014';

--Find employees hired in the last 6 months.
--Table: HumanResources.Employee

SELECT * FROM HumanResources.Employee
SELECT BusinessEntityID,DATEDIFF(MONTH,HireDate,GETDATE()) FROM HumanResources.Employee WHERE MONTH(HireDate)-MONTH(GETDATE())<6;


--find second highest salary--
SELECT MAX(Rate) FROM HumanResources.EmployeePayHistory WHERE Rate <
(SELECT MAX(Rate) FROM HumanResources.EmployeePayHistory)

--First and last record of each employee based on the hireDate Column--
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.JobCandidate
SELECT * FROM HumanResources.Shift

SELECT BusinessEntityID, MIN(HireDate),MAX(HireDate) FROM HumanResources.Employee
GROUP BY BusinessEntityID
--Write a query to find the most recent transaction of each customer--
SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesOrderHeader

SELECT MAX(OrderDate),CustomerID FROM Sales.SalesOrderHeader 
GROUP BY CustomerID

--write a query to find total salary of each department--
SELECT * FROM HumanResources.EmployeeDepartmentHistory

CREATE VIEW DEMO1 AS
SELECT DepartmentID FROM HumanResources.EmployeeDepartmentHistory as d JOIN HumanResources.EmployeePayHistory as p 
ON d.BusinessEntityID=p.BusinessEntityID 
GROUP BY DepartmentID
HAVING SUM(Rate)>200

--running total for each customer sorted by orderDate--

SELECT * FROM Sales.SalesOrderHeader

SELECT SUM(TotalDue),CustomerID,OrderDate FROM Sales.SalesOrderHeader
GROUP BY CustomerID,OrderDate
ORDER BY OrderDate ASC;

--select total no of employees hired per month per year
SELECT * FROM HumanResources.Employee

SELECT MONTH(HireDate),COUNT(BusinessEntityID),YEAR(HireDate) FROM HumanResources.Employee
GROUP BY MONTH(HireDate),YEAR(HireDate)


---write a query to display all employees who earn more than the avg salary of their department--
CREATE VIEW DEMO2 AS
SELECT dh.BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory as dh JOIN HumanResources.EmployeePayHistory as ph
ON dh.BusinessEntityID=ph.BusinessEntityID WHERE  Rate>ANY
(SELECT AVG(Rate) FROM HumanResources.EmployeePayHistory as p JOIN HumanResources.EmployeeDepartmentHistory as d 
ON p.BusinessEntityID=d.BusinessEntityID
WHERE d.DepartmentID=dh.DepartmentID
GROUP BY DepartmentID)

--write a query to get the second lowest salary from the employee table--
SELECT MIN(Rate) FROM HumanResources.EmployeePayHistory WHERE Rate>
(SELECT MIN(Rate) FROM HumanResources.EmployeePayHistory)

--write a query to list all products that have never been ordered (assuming an orders table and products table)

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Purchasing.PurchaseOrderDetail

CREATE VIEW DEMO AS
SELECT p.ProductID,SalesOrderID FROM Production.Product as p LEFT OUTER JOIN Sales.SalesOrderDetail as o 
ON p.ProductID=o.ProductID WHERE SalesOrderID IS NULL;

--write a query to find employees who have joined in the same month and year(january and 2009)--
CREATE VIEW DEMO3 AS
SELECT BusinessEntityID,HireDate FROM HumanResources.Employee WHERE MONTH(HireDate)=01 AND YEAR(HireDate)=2009
SELECT * FROM HumanResources.Employee

--get a list of employees who are older than the average age of the employees in their department
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmployeeDepartmentHistory
CREATE VIEW DEMO4 AS
SELECT E.BusinessEntityID,dh.DepartmentID FROM HumanResources.Employee as e JOIN HumanResources.EmployeeDepartmentHistory AS DH 
ON E.BusinessEntityID=DH.BusinessEntityID WHERE DATEDIFF(year,BirthDate,GETDATE())=
(SELECT AVG(DATEDIFF(YEAR,BirthDate,GETDATE())) FROM HUmanResources.Employee as e JOIN HumanResources.EmployeeDepartmentHistory AS D
ON E.BusinessEntityID=D.BusinessEntityID WHERE D.DepartmentID=DH.DepartmentID);



SELECT * FROM DEMO
SELECT * FROM DEMO1
SELECT * FROM DEMO2
SELECT * FROM DEMO3
SELECT * FROM DEMO4

--write a query to find the first purchase date of each customer 
SELECT * FROM Sales.SalesOrderDetail

SELECT * FROM Sales.Customer

SELECT * FROM Sales.SalesOrderHeader

SELECT CustomerID, Min_Order_Date=MIN(OrderDate) FROM Sales.SalesOrderHeader
GROUP BY CustomerID

--find the average order value for each month by customer--
SELECT * FROM Sales.SalesOrderHeader
SELECT AVG(TotalDue),CustomerID,Month=MONTH(OrderDate) FROM Sales.SalesOrderHeader
GROUP BY CustomerID, MONTH(OrderDate)

--List all products that have never been ordered.
--(Use Production.Product and Sales.SalesOrderDetail)
SELECT * FROM PRoduction.Product
SELECT * FROM Sales.SalesOrderDetail
SELECT p.ProductID FROM Production.Product as p LEFT OUTER JOIN Sales.SalesOrderDetail as s 
ON p.ProductID=s.ProductID

--List all products that have never been ordered.
--(Use Production.Product and Sales.SalesOrderDetail)
SELECT * FROM PRoduction.Product
SELECT * FROM Sales.SalesOrderDetail
SELECT p.ProductID,s.productID FROM Production.Product as p LEFT OUTER JOIN Sales.SalesOrderDetail as s 
ON p.ProductID=s.ProductID
WHERE s.ProductID IS NULL

--Find customers who live in the same city as their assigned salesperson.
--(Use Sales.Customer, Sales.SalesPerson, and Person.Address)

SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesPerson
SELECT * FROM Person.Address
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM HumanResources.Employee

SELECT CustomerID,pe.BusinessEntityID FROM Sales.Customer as c JOIN Person.Address as p 
ON c.ModifiedDate=p.ModifiedDate JOIN Sales.SalesPerson as pe ON c.TerritoryID=pe.TerritoryID WHERE City =
(SELECT City FROM Person.Address as a JOIN Sales.SalesPerson as p
ON a.ModifiedDate=p.ModifiedDate
WHERE pe.BusinessEntityID=p.BusinessEntityID)


--List all employees and their job titles, including those who don't currently have a department.

SELECT * FROM HUmanResources.Employee
SELECT * FROM HumanResources.EmployeeDepartmentHistory

SELECT e.BusinessENtityID,JobTitle,DepartmentID FROM HumanResources.Employee as e LEFT  JOIN HumanResources.EmployeeDepartmentHistory as d 
ON e.BusinessEntityID=d.BusinessEntityID
WHERE DepartmentID IS NULL

--Find the total number of products in each subcategory. Show subcategory name and product count.--
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Production.Product

SELECT count=COUNT(ProductID),s.ProductSubcategoryID FROM Production.ProductSubcategory as s JOIN Production.Product as p 
ON s.ProductSubcategoryID=p.ProductSubcategoryID
GROUP BY s.ProductSubcategoryID


--Show the top 5 customers who have spent the most.
--(Use Sales.SalesOrderHeader and Sales.Customer)

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.Customer

SELECT TOP 5 CustomerID FROM Sales.SalesOrderHeader 
ORDER BY TotalDue DESC

--List the total number of orders placed each month in 2013.

SELECT * FROM Sales.SalesOrderHeader

SELECT MONTHs=MONTH(OrderDate),noOfOrders=COUNT(SalesOrderID) FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY MONTH(OrderDate)


--Find the names of products that cost more than the average product price.

SELECT * FROM Production.Product

SELECT Name FROM Production.Product WHERE ListPrice>
(SELECT AVG(ListPrice) FROM Production.Product)

--List employees who earn more than the highest-paid employee in department ID 3.


SELECT * FROM HumanResources.EmployeePayHistory
SELECT * FROM HumanResources.EmployeeDepartmentHistory

SELECT BusinessEntityID,Rate FROM HumanResources.EmployeePayHistory WHERE Rate>
(SELECT MAX(Rate) FROM HumanResources.EmployeePayHistory as p JOIN HumanResources.EmployeeDepartmentHistory as d 
ON p.BusinessEntityID=d.BusinessEntityID WHERE DepartmentID=3)

--Find salespeople who haven’t made any sales.

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesPerson

SELECT BusinessEntityID FROM Sales.SalesPerson WHERE BusinessEntityID NOT IN
(SELECT SalesPersonID FROM Sales.SalesOrderHeader)

--For each salesperson, list their orders along with a running total of the order amount.--
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesPerson

SELECT COUNT(SalesOrderID),SUM(TotalDue),SalesPersonID  FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
ORDER BY SalesPersonID

--List the top 3 most expensive products in each product subcategory

SELECT * FROM Production.Product
SELECT TOP 3 ProductID, PRoductSubCategoryID FROM Production.Product

ORDER BY ListPrice




CREATE TABLE Emp
(
Student_id INT IDENTITY PRIMARY KEY,
Student_name VARCHAR(50),
Student_email VARCHAR(50)
)

INSERT INTO Emp VALUES
('vivek','vivek@gmail.com'),
('sachi','sachi@gmaiil.com')

--alter table by adding col--
ALTER TABLE emp ADD  Student_Grade VARCHAR(20)
SELECT * FROM Emp
--Alter table by removing col--
ALTER TABLE Emp DROP COLUMN Student_Grade
--update exisitng values of table--
UPDATE Emp SET Student_name='sachi dugam' WHERE Student_id=2
--DELETE row--
DELETE EMP WHERE Student_id=1
SELECT * FROM Emp
INSERT INTO Emp VALUES
('vivek','vivek@gmail.com')
--rename-- 
SP_RENAME 'Emp.Student_name','name'
SELECT * FROM Emp
--changing data type
ALTER TABLE Emp ALTER COLUMN name VARCHAR(100)
--truncate--
TRUNCATE TABLE Emp
SELECT * FROM Emp
--DRop Table--
DROP TABLE Emp


CREATE TABLE Emp
(
Student_id INT IDENTITY PRIMARY KEY,
Student_name VARCHAR(50),
Student_email VARCHAR(50)
)

INSERT INTO Emp VALUES
('vivek','vivek@gmail.com'),
('sachi','sachi@gmaiil.com')

SELECT * FROM Emp
BEGIN TRANSACTION;
INSERT INTO Emp VALUES
('hemanth','hema@gmail.com'),
('mehvish','mev@gmaiil.com')
COMMIT TRANSACTION;
SELECT * FROM Emp
ROLLBACK TRANSACTION;
BEGIN TRANSACTION;
INSERT INTO Emp VALUES
('sahil','sahil@gmail.com'),
('adi','adi@gmaiil.com')
ROLLBACK TRANSACTION;
SELECT * FROM Emp

ALTER TABLE EMP  DROP COLUMN Student_name
SELECT * FROM Emp
DROP TABLE Emp

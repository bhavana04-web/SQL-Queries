--Most asked SQL Questions--

--window functions--

--question 1--
SELECT * FROM HumanResources.EmployeePayHistory
SELECT TOP 3 p.BusinessEntityID,Rate,DepartmentID,ROW_NUMBER() over(PARTITION BY DepartmentID ORDER BY DepartmentID DESC) as rowno FROM HumanResources.EmployeePayHistory as p JOIN HumanResources.EmployeeDepartmentHistory as h
ON p.BusinessEntityID=h.BusinessEntityID

--Question-2 latest order per customer--
SELECT * FROM Sales.SalesOrderHeader
SELECT SalesOrderID,CustomerID,OrderDate,TotalDue,ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) 
as rowno FROM Sales.SalesOrderHeader;

--Question-4 Rank Customers by their Spend--
SELECT CustomerID,TotalDue,RANK() OVER(ORDER BY TotalDue DESC) FROM Sales.SalesOrderHeader;

--Question-5 Rank Employees BY salaries within departments--

SELECT * FROM HumanResources.EmployeePayHistory;

SELECT p.BusinessEntityID,DepartmentID,Rate,RANK() OVER(PARTITION BY DepartmentID ORDER BY Rate DESC) as RankPerDepartment FROM HumanResources.EmployeePayHistory as p JOIN HumanResources.EmployeeDepartmentHistory as h 
on p.BusinessEntityID=h.BusinessEntityID

-- Question-6 Calculate average order value of customer over time--

SELECT * FROM Sales.SalesOrderHeader;
SELECT SalesOrderID,CustomerID,OrderDate,AVG(TotalDue) OVER(PARTITION BY CustomerID ORDER BY OrderDate)
FROM Sales.SalesOrderHeader;

--Summary--
--Rank() OVER(PARTITION BY ORDER BY ASC/DESC)
--ROW_NUMBER OVER(PARTITION BY ORDER BY ASC/DESC)


--JOINS--
--Question 7 Customers without orders--
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.Customer

SELECT SalesOrderID,c.CustomerID FROM Sales.SalesOrderHeader as sh LEFT OUTER JOIN Sales.Customer as c 
ON sh.CustomerID=c.CustomerID 
WHERE c.CustomerID IS NULL;

-- Question 8 Products not sold--
SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail;

SELECT pr.ProductID,s.ProductID FROM Production.Product as pr LEFT OUTER JOIN Sales.SalesOrderDetail as s 
ON pr.ProductID=s.ProductID 
WHERE s.ProductID IS NULL;

--Question 9 highest sale per region--

SELECT * FROM Sales.SalesTerritory

SELECT MAX(SalesYTD),TerritoryID FROM Sales.SalesTerritory 
GROUP BY TerritoryID


-- Question 10 highest sales per category--
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail


--Question 11 highest paid in their dept--
SELECT * FROM HumanResources.EmployeePayHistory

-- Question 12 total revenue per category--


SELECT revenue=SUM(OrderQty*UnitPrice),ProductCategoryID FROM Sales.SalesOrderDetail sd JOIN Production.Product as p 
on sd.ProductID=p.ProductID JOIN Production.ProductSubcategory as ps 
ON p.ProductSubcategoryID=ps.ProductSubcategoryID 
GROUP BY ProductCategoryID;

--Question 13 highest paid employee per department--
SELECT Rate,DepartmentID FROM HumanResources.EmployeePayHistory  as p JOIN HumanResources.EmployeeDepartmentHistory as dh
ON p.BusinessEntityID=dh.BusinessEntityID
WHERE Rate=
(SELECT MAX(Rate) FROM HumanResources.EmployeePayHistory as p JOIN HumanResources.EmployeeDepartmentHistory as d ON p.BusinessEntityID=d.BusinessEntityID
WHERE dh.DepartmentID=d.DepartmentID)

--Question 14 Orders with customer and product info--

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
SELECT sd.SalesOrderID,CustomerID,OrderDate,p.ProductID,ListPrice,Rank=ROW_NUMBER() OVER(PARTITION BY sd.SalesOrderID ORDER BY sd.SalesOrderID) FROM Sales.SalesOrderDetail as sd JOIN Production.product as p 
ON sd.ProductID=p.ProductID JOIN Sales.SalesOrderHeader as sh 
ON sd.SalesOrderID=sh.SalesOrderID

--SubQueries--

--Question 15 Customers with above average spend--

SELECT * FROM Sales.SalesOrderHeader

SELECT CustomerID,TotalDue FROM Sales.SalesOrderHeader WHERE TotalDue>
(SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader)

--Employee with second highest salary--
SELECT TOP 1 Rate,BusinessEntityID FROM HumanResources.EmployeePayHistory WHERE RATE<
(SELECT MAX(Rate) FROM HumanResources.EmployeePayHistory )

--Question 16 Products with no orders--

SELECT * FROM  Production.Product
SELECT * FROM Sales.SalesOrderDetail


SELECT ProductID FROM Production.Product WHERE ProductID IN
(SELECT pr.ProductID FROM Production.Product as pr JOIN Sales.SalesOrderDetail as s
ON pr.ProductID=s.ProductID
WHERE s.ProductID IS NULL)


--Question 17 Customers with more than one order--
SELECT CustomerID,NumberOfOrders=COUNT(SalesOrderID) FROM Sales.SalesOrderHeader GROUP BY CustomerID HAVING CustomerID IN
(SELECT CustomerID FROM Sales.SalesOrderHeader 
GROUP BY CustomerID 
HAVING COUNT(SalesOrderID)>1);

--Question 18 Products more than the average price of all orders--

SELECT * FROM Production.Product

SELECT ProductID FROM Production.Product WHERE ListPrice>
(SELECT AVG(ListPrice) FROM Production.Product )

--Question 19 Employees With Salaries in Top 10%--

SELECT * FROM HumanResources.EmployeePayHistory

SELECT BusinessEntityID,Rate FROM HumanResources.EmployeePayHistory WHERE Rate <=
(SELECT SUM(Rate)*10/100 FROM HumanResources.EmployeePayHistory )

--Question 20 Departments with only one employee--

SELECT DepartmentID,COUNT(*) FROM HumanResources.EmployeeDepartmentHistory 
GROUP BY DepartmentID
HAVING COUNT(*)=1;

--aggregations and grouping--

--Question 21: Total Revenue Per Product--

SELECT * FROM pRODUCTION.Product
SELECT * FROM Sales.SalesOrderDetail

SELECT TotalRevenue= SUM(UnitPrice),ProductID FROM Sales.SalesOrderDetail 
GROUP BY ProductID

--Question 22: Average Order Value per Customer--

SELECT * FROM Sales.SalesOrderHeader
SELECT AVG(TotalDue),CustomerID FROM Sales.SalesOrderHeader
GROUP BY CustomerID

--Question 23: Number of Orders per Month--

SELECT * FROM Sales.SalesOrderHeader

SELECT NumberOfOrders=COUNT(*),Month=MONTH(OrderDate) FROM Sales.SalesOrderHeader
GROUP BY MONTH(OrderDate)

--Question 24: Highest-Spending Customer--

SELECT TOP 1 CustomerID,MAX(TotalDue) FROM Sales.SalesOrderHeader 
GROUP BY CustomerID

--Question 25: Product Count per Category--

SELECT * FROM Production.ProductSubcategory
SELECT * FROM Production.Product

SELECT ProductSubCategoryID,COUNT(ProductID) FROM Production.Product
GROUP BY ProductSubcategoryID

--Question 26: Orders Per Customer Per Year--
SELECT * FROM Sales.SalesOrderHeader

SELECT YEAR(OrderDate),COUNT(SalesOrderID),CustomerID FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate),CustomerID

--Question 27: Most Popular Product Each Month--

SELECT * FROM Sales.SalesOrderDetail

SELECT Month=MONTH(OrderDate),CountOfProduct=COUNT(ProductID )FROM Sales.SalesOrderHeader as sh JOIN Sales.SalesOrderDetail as sd 
ON sh.SalesOrderID=sd.SalesOrderID
GROUP BY Month(OrderDate) 
ORDER BY COUNT(ProductID) DESC;

--Question 28: Customers with Highest Order Frequency--

SELECT * FROM Sales.SalesOrderHeader

SELECT TOP 5 CustomerID,COUNT(SalesOrderID) FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY COUNT(SalesOrderID) DESC

--Question 29: Categories with No Sales--

SELECT * FROM  Sales.SalesOrderDetail
SELECT * FROM Production.Product
SELECT * FROM Production.ProductSubcategory

SELECT SUM(TotalDue),ProductCategoryID FROM Sales.SalesOrderHeader as sh JOIN Sales.SalesOrderDetail as sd
ON sh.SalesOrderID=sd.SalesOrderID JOIN Production.Product as pp
ON sd.ProductID=pp.ProductID JOIN Production.ProductSubcategory as ps 
ON pp.ProductSubcategoryID=ps.ProductSubcategoryID 
GROUP BY ProductCategoryID
HAVING SUM(TotalDue) IS NULL;
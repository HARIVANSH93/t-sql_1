/*  Q-1   Write a SQL query to locate those salespeople who do not live in the same city where their customers live and have 
 received a commission of more than 12% from the company. Return Customer Name, customer city, Salesman, salesman city, commission.*/

SELECT 
    p1.FirstName + ' ' + p1.LastName AS CustomerName,
    cust_address.City AS CustomerCity,
    p.FirstName + ' ' + p.LastName AS SalesmanName,
    sp_address.City AS SalesmanCity,
    sp.CommissionPct * 100 AS Commission
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Person.Person p1 ON c.PersonID = p1.BusinessEntityID
-- Customer Address
JOIN Person.BusinessEntityAddress cust_bea ON c.StoreID = cust_bea.BusinessEntityID
JOIN Person.Address cust_address ON cust_bea.AddressID = cust_address.AddressID
-- Salesperson Address
JOIN Person.BusinessEntityAddress sp_bea ON sp.BusinessEntityID = sp_bea.BusinessEntityID
JOIN Person.Address sp_address ON sp_bea.AddressID = sp_address.AddressID
WHERE cust_address.City <> sp_address.City
  AND sp.CommissionPct > 0.0012;

  --_____________________________________ 2ND QUERY _______________________________________________
/*2. To list every salesperson, along with the customer's name, city, grade, order number, date, and amount, create a SQL query.Requirement for choosing the salesmen's list:
Salespeople who work for one or more clients, or  Salespeople who haven't joined any clients yet.
Requirements for choosing a customer list:
placed one or more orders with their salesman, or  didn't place any orders.*/


  SELECT 
    p_sales.FirstName + ' ' + p_sales.LastName AS SalesmanName,
    ISNULL(p_cust.FirstName + ' ' + p_cust.LastName, st.Name) AS CustomerName,
    addr.City AS CustomerCity, 
    soh.SalesOrderID AS OrderNumber,
    soh.OrderDate,
    soh.TotalDue AS OrderAmount
FROM Sales.SalesPerson sp
-- Join with SalesOrderHeader to get orders (can be NULL = no orders)
LEFT JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
-- Join with customers (who placed the orders)
LEFT JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
-- Join to get customer name (either person or store)
LEFT JOIN Person.Person p_cust ON c.PersonID = p_cust.BusinessEntityID
LEFT JOIN Sales.Store st ON c.StoreID = st.BusinessEntityID
-- Customer address (optional)
LEFT JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
LEFT JOIN Person.Address addr ON bea.AddressID = addr.AddressID
-- Salesperson name
LEFT JOIN Person.Person p_sales ON sp.BusinessEntityID = p_sales.BusinessEntityID
ORDER BY SalesmanName;

--_________________________________________________ 3RD QUERY ______________________________________________________
/* 3. Write a SQL query to calculate the difference between the maximum salary and the salary of all the employees
who work in the department of ID 80. Return job title, employee name and salary difference. */
SELECT 
    e.JobTitle,
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    ph.Rate AS Salary,
    (maxSal.MaxSalary - ph.Rate) AS SalaryDifference
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN 
    HumanResources.EmployeePayHistory ph ON e.BusinessEntityID = ph.BusinessEntityID
JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN 
    (SELECT 
         MAX(ph2.Rate) AS MaxSalary
     FROM 
         HumanResources.EmployeeDepartmentHistory edh2
     JOIN 
         HumanResources.EmployeePayHistory ph2 ON edh2.BusinessEntityID = ph2.BusinessEntityID
     WHERE 
         edh2.DepartmentID = 80 AND edh2.EndDate IS NULL
    ) AS maxSal ON 1 = 1
WHERE 
    edh.DepartmentID = 80
    AND edh.EndDate IS NULL;

--______________________________________________ 4TH QUERY __________________________________________________
/* 4. Create a SQL query to compare employees' year-to-date sales. Return TerritoryName, SalesYTD, BusinessEntityID, and 
Sales from the prior year (PrevRepSales). The results are sorted by territorial name in ascending order. */


SELECT 
    SalesTerritory.Name,
    SalesPerson.SalesYTD,
    SalesPerson.BusinessEntityID,
    SalesPerson.SalesLastYear
FROM Sales.SalesPerson
LEFT JOIN Sales.SalesTerritory 
    ON SalesPerson.TerritoryID = SalesTerritory.TerritoryID
ORDER BY SalesTerritory.Name ASC;




--__________________________________________  5TH QUERY____________________________________________________
/* 5. Write a SQL query to find those orders where the order amount exists
between 500 and 2000. Return ord_no, purch_amt, cust_name, city. */


SELECT 
    SalesOrderID,
    OrderDate,
    Status,
    CustomerID,
    TerritoryID,
    TotalDue,
    AccountNumber  
FROM Sales.SalesOrderHeader
ORDER BY OrderDate DESC;


--______________________________________________6TH QUERY______________________________________
/* 6. To find out if any of the current customers have placed an order or not, create a report using the following SQL statement: 
customer name, city, order number, order datE, and order amount in ascending order based on the order date. */

SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    a.City,
    soh.SalesOrderNumber,
    soh.OrderDate,
    soh.TotalDue AS OrderAmount
FROM 
    Sales.Customer c
JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN 
    Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN 
    Person.Address a ON bea.AddressID = a.AddressID
LEFT JOIN 
    Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE 
    soh.SalesOrderID IS NOT NULL -- 
ORDER BY 
    soh.OrderDate ASC;







--___________________________________________________7TH QUERY______________________________________
/* 7. Create a SQL query that will return all employees with "Sales" at the start of their job titles.
Return the columns for job title, last name, middle name, and first name. */
SELECT 
    JobTitle,
    LastName,
    MiddleName,
    FirstName
FROM HumanResources.Employee e
JOIN Person.Person p 
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE JobTitle LIKE 'Sales%';

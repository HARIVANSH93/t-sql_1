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

SELECT 
    JobTitle,
    LastName,
    MiddleName,
    FirstName
FROM HumanResources.Employee e
JOIN Person.Person p 
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE JobTitle LIKE 'Sales%';

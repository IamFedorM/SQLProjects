USE mintclassics ;
-- SCHEMA EXPLORATION
-- I List all tables in the database
SHOW TABLES;

-- I describe each table to understand their structure
DESCRIBE customers;
DESCRIBE employees;
DESCRIBE offices;
DESCRIBE orderdetails;
DESCRIBE orders;
DESCRIBE payments;
DESCRIBE productlines;
DESCRIBE products;
DESCRIBE warehouses;

-- DATA RETRIEVAL
-- I retrieve data from each table
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM productlines;
SELECT * FROM products;
SELECT * FROM warehouses;

-- ADVANCED ANALYSIS 
-- Let's identify products with low sales but available in high quantities
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) as totalSales, p.quantityInStock
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode
HAVING totalSales < 950 AND p.quantityInStock > 7000;

-- Let's analyze warehouse space utilization
SELECT w.warehouseCode, w.warehouseName, COUNT(*) as numberOfProducts
FROM warehouses w
JOIN products p ON w.warehouseCode = p.warehouseCode
GROUP BY w.warehouseCode;

-- Let's evaluate sales by product category
SELECT pl.productLine, SUM(od.quantityOrdered) as totalSales
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY pl.productLine;

-- Let's analyze sales trend for the past 
SELECT YEAR(o.orderDate) as year, MONTH(o.orderDate) as month, SUM(od.quantityOrdered) as totalSales
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY year, month
ORDER BY year, month;

-- Let's identify customers who have not made any orders in the past year
SELECT c.customerName, c.phone, c.addressLine1, c.city, c.state, c.postalCode, c.country
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.customerNumber IS NULL;

-- Let's identify products that have not been ordered in the past year
SELECT p.productCode, p.productName, p.productLine, p.quantityInStock
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL;

-- Let's dentify top selling products
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) as totalSales
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode
ORDER BY totalSales DESC
LIMIT 10

-- Let's analyze sales performance by employee
SELECT e.employeeNumber, e.firstName, e.lastName, SUM(p.amount) as totalSales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY e.employeeNumber
ORDER BY totalSales DESC;

-- Let's calcualte customer distribution by country
SELECT c.country, COUNT(c.customerNumber) as totalCustomers
FROM customers c
GROUP BY c.country
ORDER BY totalCustomers DESC;

-- Let's calculate average order value
SELECT AVG(orderTotal) as averageOrderValue
FROM (SELECT o.orderNumber, SUM(od.quantityOrdered * od.priceEach) as orderTotal
      FROM orders o
      JOIN orderdetails od ON o.orderNumber = od.orderNumber
      GROUP BY o.orderNumber) as orderValues;

-- Let's calculate total inventory value per warehouse
SELECT w.warehouseCode, w.warehouseName, SUM(p.quantityInStock * p.buyPrice) as totalInventoryValue
FROM warehouses w
JOIN products p ON w.warehouseCode = p.warehouseCode
GROUP BY w.warehouseCode;

-- Profitability by product line
SELECT pl.productLine, SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) as totalProfit
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY pl.productLine
ORDER BY totalProfit DESC;









SELECT * FROM Walmart.sales;
Use Walmart;
-- **1.Time management**
-- Adding a column to store the time of the day
SELECT
time,
(CASE
WHEN time BETWEEN '00:00:01' AND '12:00:00' THEN 'Morning'
WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END
) AS time_of_date
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_date VARCHAR(10);
UPDATE sales
SET time_of_date = CASE
    WHEN time BETWEEN '00:00:01' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

-- Adding columns 
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);
UPDATE sales
SET day_name = DAYNAME(date), 
    month_name = MONTHNAME(date);
-- **2. Detect and Handle NULL or Missing Values**
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN invoice_id IS NULL THEN 1 ELSE 0 END) AS invoice_id_nulls,
    SUM(CASE WHEN branch IS NULL THEN 1 ELSE 0 END) AS branch_nulls,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN customer_type IS NULL THEN 1 ELSE 0 END) AS customer_type_nulls,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN product_line IS NULL THEN 1 ELSE 0 END) AS product_line_nulls,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS unit_price_nulls,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN tax_pct IS NULL THEN 1 ELSE 0 END) AS tax_pct_nulls,
    SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS total_nulls,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_nulls,
    SUM(CASE WHEN time IS NULL THEN 1 ELSE 0 END) AS time_nulls,
    SUM(CASE WHEN payment IS NULL THEN 1 ELSE 0 END) AS payment_nulls,
    SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS cogs_nulls,
    SUM(CASE WHEN gross_margin_pct IS NULL THEN 1 ELSE 0 END) AS gross_margin_pct_nulls,
    SUM(CASE WHEN gross_income IS NULL THEN 1 ELSE 0 END) AS gross_income_nulls,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_nulls
FROM sales;

-- We don't have any NULLs, so we don't make any changes

-- **3.Product Analysis**

-- Unique Product Lines
SELECT DISTINCT product_line FROM sales;

-- The average gross income
SELECT AVG(gross_income) AS average_income FROM sales;

-- We got an average of 15.357

ALTER TABLE sales ADD COLUMN Sales_Performance VARCHAR(15);
UPDATE sales 
SET Sales_Performance = CASE 
    WHEN gross_income > 15.357 THEN 'Above Average'
    WHEN gross_income < 15.357 THEN 'Below Average'
    ELSE 'Average'
END;

-- The gross income per product line
SELECT product_line, SUM(gross_income) AS gross_income 
FROM sales
GROUP BY product_line;

-- Total sales per product line 
SELECT product_line, SUM(total) AS total_sales 
FROM sales
GROUP BY product_line;

-- Most Popular Product Line by Gender
SELECT gender, product_line, COUNT(*) AS count
FROM sales
GROUP BY gender, product_line
ORDER BY gender, count DESC;

-- Average Unit Price by Product Line
SELECT product_line, AVG(unit_price) AS average_price
FROM sales
GROUP BY product_line;

-- Highest and Lowest Rated Product Lines
SELECT product_line, AVG(rating) AS average_rating
FROM sales
GROUP BY product_line
ORDER BY average_rating DESC;


-- **4. Sales analysis**
-- Sales by Month
SELECT MONTHNAME(date) AS month, SUM(total) AS monthly_sales 
FROM sales
GROUP BY month;
-- COGS by Month
SELECT MONTHNAME(date) AS month, SUM(cogs) AS monthly_cogs 
FROM sales
GROUP BY month;
-- Total Revenue by Month
SELECT MONTHNAME(date) AS month, SUM(total) AS monthly_revenue 
FROM sales
GROUP BY month;

-- Count of Transactions by Payment Method
SELECT payment, COUNT(*) AS transaction_count
FROM sales
GROUP BY payment;

-- Total Revenue and Quantity Sold by Branch
SELECT branch, SUM(total) AS total_revenue, SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY branch;

-- Sales Trends Across Different Times of the Day
SELECT time_of_date, SUM(total) AS total_sales
FROM sales
GROUP BY time_of_date;

-- Month with Highest Gross Income
SELECT MONTHNAME(date) AS month, SUM(gross_income) AS gross_income
FROM sales
GROUP BY month
ORDER BY gross_income DESC
LIMIT 1;


-- **5.Customer Analysis **

-- Most Common Time of Day for Each Customer Type
SELECT customer_type, time_of_date, COUNT(*) AS count
FROM sales
GROUP BY customer_type, time_of_date
ORDER BY customer_type, count DESC;

-- Purchase Trends by Customer Type
SELECT customer_type, SUM(total) AS total_spent 
FROM sales
GROUP BY customer_type;

-- Gender Distribution per Branch
SELECT branch, gender, COUNT(*) AS count 
FROM sales
GROUP BY branch, gender;

-- Ratings by Time of Day
SELECT time_of_date, AVG(rating) AS average_rating 
FROM sales
GROUP BY time_of_date;

-- Ratings by Day of the Week
SELECT day_name, AVG(rating) AS average_rating 
FROM sales
GROUP BY day_name;

-- Payment Method Preferences by Customer Type
SELECT customer_type, payment, COUNT(*) AS count
FROM sales
GROUP BY customer_type, payment
ORDER BY customer_type, count DESC;


-- **6.VS**
-- Customer Rating vs. Gross Income
SELECT rating, AVG(gross_income) AS average_gross_income
FROM sales
GROUP BY rating;

-- Average Quantity Sold vs. Payment Method
SELECT payment, AVG(quantity) AS average_quantity_sold
FROM sales
GROUP BY payment;

-- Total Sales vs. Day of the Week
SELECT day_name, SUM(total) AS total_sales
FROM sales
GROUP BY day_name;

-- End of the analysis
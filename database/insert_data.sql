SET NOCOUNT ON;

------------------------------------------------------------
-- Select database
------------------------------------------------------------
IF DB_ID('SalesInsightsDB') IS NULL
BEGIN
    PRINT 'Database SalesInsightsDB does not exist. Please create it first.';
    RETURN;
END;
GO

USE SalesInsightsDB;
GO

------------------------------------------------------------
-- Clean existing data (in correct FK order)
------------------------------------------------------------
IF OBJECT_ID('fact_order_item') IS NOT NULL
    DELETE FROM fact_order_item;

IF OBJECT_ID('fact_order') IS NOT NULL
    DELETE FROM fact_order;

IF OBJECT_ID('dim_product') IS NOT NULL
    DELETE FROM dim_product;

IF OBJECT_ID('dim_customer') IS NOT NULL
    DELETE FROM dim_customer;
GO

------------------------------------------------------------
-- 1) Seed dimension tables with synthetic data
------------------------------------------------------------

-----------------------
-- 1.1 Products (~50)
-----------------------
;WITH ProductNumbers AS (
    SELECT TOP (50)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dim_product (product_name, category, subcategory)
SELECT 
    'Product ' + CAST(n AS VARCHAR(10)) AS product_name,
    CASE 
        WHEN n % 3 = 1 THEN 'Furniture'
        WHEN n % 3 = 2 THEN 'Technology'
        ELSE 'Office Supplies'
    END AS category,
    CASE 
        WHEN n % 3 = 1 THEN 
            CASE WHEN n % 2 = 1 THEN 'Chairs' ELSE 'Desks' END
        WHEN n % 3 = 2 THEN 
            CASE WHEN n % 2 = 1 THEN 'Accessories' ELSE 'Monitors' END
        ELSE 
            CASE WHEN n % 2 = 1 THEN 'Paper' ELSE 'Writing' END
    END AS subcategory
FROM ProductNumbers;
GO

-----------------------
-- 1.2 Customers (~10,000)
-----------------------
;WITH CustomerNumbers AS (
    SELECT TOP (10000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO dim_customer (customer_name, customer_segment, city, region)
SELECT
    'Customer ' + CAST(n AS VARCHAR(10)) AS customer_name,
    CASE 
        WHEN n % 3 = 1 THEN 'Consumer'
        WHEN n % 3 = 2 THEN 'Corporate'
        ELSE 'Home Office'
    END AS customer_segment,
    CASE 
        WHEN n % 8 = 1 THEN 'Mumbai'
        WHEN n % 8 = 2 THEN 'Delhi'
        WHEN n % 8 = 3 THEN 'Bengaluru'
        WHEN n % 8 = 4 THEN 'Hyderabad'
        WHEN n % 8 = 5 THEN 'Chennai'
        WHEN n % 8 = 6 THEN 'Pune'
        WHEN n % 8 = 7 THEN 'Ahmedabad'
        ELSE 'Kolkata'
    END AS city,
    CASE 
        WHEN n % 4 = 1 THEN 'North'
        WHEN n % 4 = 2 THEN 'South'
        WHEN n % 4 = 3 THEN 'East'
        ELSE 'West'
    END AS region
FROM CustomerNumbers;
GO

------------------------------------------------------------
-- 2) Generate Orders (~100,000 rows)
------------------------------------------------------------

DECLARE @StartDate DATE = '2023-01-01';
DECLARE @OrderDaysRange INT = 730; -- approx 2 years span

;WITH OrderNumbers AS (
    SELECT TOP (100000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO fact_order (order_date, customer_id, order_status)
SELECT
    DATEADD(DAY, (n % @OrderDaysRange), @StartDate) AS order_date,
    ((n - 1) % 10000) + 1                                 AS customer_id,
    'Completed'                                           AS order_status
FROM OrderNumbers;
GO

------------------------------------------------------------
-- 3) Generate Order Items (~200,000+ rows)
--    For each order, create exactly 2 line items
------------------------------------------------------------

DECLARE @MaxOrderId INT = (SELECT MAX(order_id) FROM fact_order);
DECLARE @MaxProductId INT = (SELECT MAX(product_id) FROM dim_product);

;WITH OrderBase AS (
    SELECT order_id
    FROM fact_order
),
TwoLines AS (
    SELECT order_id, line_no
    FROM OrderBase
    CROSS JOIN (VALUES (1),(2)) AS L(line_no)   -- 2 items per order
)
INSERT INTO fact_order_item (order_id, product_id, quantity, unit_price, discount)
SELECT
    order_id,
    ((ABS(CHECKSUM(NEWID())) % @MaxProductId) + 1) AS product_id,
    1 + (ABS(CHECKSUM(NEWID())) % 5)               AS quantity,          -- 1 to 5
    CAST(500 + (ABS(CHECKSUM(NEWID())) % 19500) AS DECIMAL(10,2)) AS unit_price,  -- 500 to 20000
    CASE (ABS(CHECKSUM(NEWID())) % 5)
        WHEN 0 THEN 0.00
        WHEN 1 THEN 0.05
        WHEN 2 THEN 0.10
        WHEN 3 THEN 0.15
        ELSE 0.20
    END AS discount;
GO

------------------------------------------------------------
-- 4) Quick sanity checks (you can comment these out later)
------------------------------------------------------------
PRINT 'Row counts:';
SELECT 'dim_customer' AS TableName, COUNT(*) AS RowCount FROM dim_customer;
SELECT 'dim_product'  AS TableName, COUNT(*) AS RowCount FROM dim_product;
SELECT 'fact_order'   AS TableName, COUNT(*) AS RowCount FROM fact_order;
SELECT 'fact_order_item' AS TableName, COUNT(*) AS RowCount FROM fact_order_item;

SET NOCOUNT OFF;

--Total revenue
SELECT SUM(oi.line_amount) AS TotalRevenue
FROM dbo.fact_order_item oi

--Revenue by month
SELECT 
	YEAR(o.order_date) AS Year,
	MONTH(o.order_date) AS Month,
	 CONCAT(
        YEAR(o.order_date), 
        '-', 
        RIGHT('0' + CAST(MONTH(o.order_date) AS VARCHAR(2)), 2)
    ) AS YearMonth,
	SUM(oi.line_amount) AS Revenue
FROM 
	dbo.fact_order o INNER JOIN dbo.fact_order_item oi
	ON oi.order_id = o.order_id
GROUP BY 
	YEAR(o.order_date),
	MONTH(o.order_date)
ORDER BY Year,Month

--Top products
SELECT TOP 10
	p.product_name AS Product,
	SUM(oi.line_amount) TotalRevenue
FROM 
	dbo.dim_product p INNER JOIN dbo.fact_order_item oi
	ON oi.product_id = p.product_id
GROUP BY 
	p.product_name
ORDER BY TotalRevenue DESC

--Region performance
SELECT 
	c.region AS Region,
	SUM(oi.line_amount) AS Revenue
FROM 
	dbo.dim_customer c INNER JOIN dbo.fact_order o
	ON c.customer_id=o.customer_id
	INNER JOIN dbo.fact_order_item oi
	ON oi.order_id = o.order_id
GROUP BY c.region
ORDER BY Revenue DESC

--Customer segment
SELECT 
	c.customer_segment AS Segment,
	SUM(oi.line_amount) AS Revenue
FROM 
	dbo.dim_customer c INNER JOIN dbo.fact_order o
	ON o.customer_id = c.customer_id
	INNER JOIN dbo.fact_order_item oi
	ON oi.order_id = o.order_id
GROUP BY 
	c.customer_segment
ORDER BY Revenue DESC

--AOV
SELECT 
    SUM(oi.line_amount) / COUNT(DISTINCT o.order_id) AS AvgOrderValue
FROM dbo.fact_order_item oi
INNER JOIN dbo.fact_order o
    ON oi.order_id = o.order_id;

--Revenue heatmap
SELECT 
    CONCAT(
        YEAR(o.order_date), 
        '-', 
        RIGHT('0' + CAST(MONTH(o.order_date) AS VARCHAR(2)), 2)
    ) AS YearMonth,
    c.region AS Region,
    SUM(oi.line_amount) AS Revenue
FROM dbo.fact_order o INNER JOIN dbo.dim_customer c
    ON c.customer_id = o.customer_id
INNER JOIN dbo.fact_order_item oi
    ON oi.order_id = o.order_id
GROUP BY 
    CONCAT(
        YEAR(o.order_date), 
        '-', 
        RIGHT('0' + CAST(MONTH(o.order_date) AS VARCHAR(2)), 2)
    ),
    c.region
ORDER BY YearMonth, Region;
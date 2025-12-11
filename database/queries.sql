--Total revenue
SELECT SUM(oi.line_amount) AS TotalRevenue
FROM dbo.fact_order_item oi

--Revenue by month
SELECT 
	YEAR(o.order_date) AS Year,
	MONTH(o.order_date) AS Month,
	SUM(oi.line_amount) AS Renenue
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
	AVG(line_amount) 
FROM 
	dbo.fact_order_item

--Revenue heatmap
SELECT 
	CONCAT(YEAR(order_date),'-',MONTH(order_date)) AS  Month,
	c.region AS Region,
	SUM(oi.line_amount) AS Revenue
FROM 
	dbo.fact_order o INNER JOIN dbo.dim_customer c
	ON c.customer_id = o.customer_id
	INNER JOIN dbo.fact_order_item oi
	ON oi.order_id = o.order_id
GROUP BY 
	CONCAT(YEAR(order_date),'-',MONTH(order_date)),
	c.region
ORDER BY Month
/*retail_sales table*/
SELECT * FROM retail_sales

/*retail_state table*/
SELECT * FROM retail_state

/*retail_category table*/
SELECT * FROM retail_category

/*retail_manager table*/
SELECT * FROM retail_manager

/*The Number of Orders Processed in 2016*/

SELECT COUNT(chain) AS total_orders FROM retail_sales
WHERE date BETWEEN '2016-01-01' AND '2016-12-31'

/*The Total Sales for 2016*/
SELECT SUM(sale_price*total_units) AS total_sales
FROM retail_sales
WHERE date BETWEEN '2016-01-01' AND '2016-12-31';

/*The Total Cost of Goods Sold in 2016*/
SELECT SUM(cost_price*total_units) AS total_cost
FROM retail_sales
WHERE date BETWEEN '2016-01-01' AND '2016-12-31';

/*Gross Profit and Profit Margin in 2016*/
SELECT 
    SUM(sale_price * total_units) AS total_sales,
    SUM(cost_price * total_units) AS total_cost,
    SUM((sale_price - cost_price) * total_units) AS gross_profit,
    CASE WHEN SUM(cost_price * total_units) > 0 THEN 
        ((SUM(sale_price * total_units) - SUM(cost_price * total_units)) / SUM(sale_price * total_units)) * 100 
    ELSE 
        0 
    END AS profit_margin
FROM retail_sales
WHERE 
    date BETWEEN '2016-01-01' AND '2016-12-31';
	
	
/*Total Sales Per Manager*/
SELECT
	manager,
	SUM(total_units*sale_price) AS total_sales
FROM retail_sales AS rs
INNER JOIN retail_manager AS rm
ON rs.postcode = rm.postcode
WHERE date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY manager
ORDER BY total_sales DESC
LIMIT 5;

/*Total Sales by Month*/
SELECT 
	TO_CHAR(date,'month') AS month,
	SUM(total_units*sale_price) AS total_sales
FROM retail_sales
Where date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP by month
ORDER by TO_DATE(TO_CHAR(date,'month'),'month');

/*Sales Per Product Category*/
SELECT
	category,
	SUM(total_units*sale_price) AS sales
FROM retail_sales
WHERE date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP by category
ORDER by sales DESC;

/*Profit Per Product Category*/
SELECT 
	category,
	SUM(total_units*sale_price)-SUM(total_units*cost_price) AS profits
FROM retail_sales
WHERE date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP by category
ORDER by profits DESC;

/*Sales growth for first half of 2017*/
WITH sales_2016 AS (
    SELECT 
        TO_CHAR(date, 'month') AS month,
        SUM(total_units * sale_price) AS sale_16
    FROM retail_sales
    WHERE date BETWEEN '2016-01-01' AND '2016-06-30'
    GROUP BY month
    ORDER BY TO_DATE(TO_CHAR(date,'month'),'month')),

	sales_2017 AS (
    SELECT 
        TO_CHAR(date, 'month') AS month,
        SUM(total_units * sale_price) AS sale_17
    FROM retail_sales
    WHERE date BETWEEN '2017-01-01' AND '2017-06-30'
    GROUP BY month
    ORDER BY TO_DATE(TO_CHAR(date,'month'),'month'))
SELECT 
    s16.month,
    ((sale_17 - sale_16) / sale_16 * 100) AS sales_growth
FROM sales_2016 AS s16
INNER JOIN sales_2017 AS s17 ON s16.month = s17.month;

















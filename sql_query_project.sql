-- Create table
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender TEXT,
				age	INT,
				category VARCHAR(15),	
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs FLOAT,	
				total_sale FLOAT
			);



SELECT * FROM retail_sales;

--

SELECT * FROM retail_sales
WHERE 
      transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;
--

DELETE FROM retail_sales
WHERE 
      transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;


-- Data Exploration

-- How many Sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

--how many unique category we have?
SELECT DISTINCT category FROM retail_sales

-- Data Analyst & Business Key problems & Answers

-- My Analysis & Findings
-- Q1 Write a SQl query to retrieve all columns for sales made on '2022-11-05'
-- Q2 Write a SQl query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in month of Nov-2022
-- Q3 Write a SQl query to calculate the total sales(total_sale) for each category
-- Q4 Write a SQl query to find the average age of customers who purchased itmes from the 'Beauty' category.
-- Q5 Write a SQl query to find all transcations where the total_sale is greater than 1000.
-- Q6 Write a SQl query to find the total number of transactions (transactions_id) made by each gender in each category.
-- Q7 Write a SQl query to calculate the average sale for each month. find out best selling month in each year
-- Q8 Write a SQl query to find the top 5 customers based on the highest total sales
-- Q9 Write a SQl query to find the number of unique customers who purchased items from each category
-- Q10 Write a SQl query to create each shift and number of orders (Example Morning <= 12,afternoon Between 12 & 17,Evening > 17 )


-- Q1 Write a SQl query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2 Write a SQl query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in month of Nov-2022
SELECT 
*
from retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND 
	quantiy >= 4
;

-- Q3 Write a SQl query to calculate the total sales(total_sale) for each category
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- Q4 Write a SQl query to find the average age of customers who purchased itmes from the 'Beauty' category.
SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q5 Write a SQl query to find all transcations where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Q6 Write a SQl query to find the total number of transactions (transactions_id) made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 1

-- Q7 Write a SQl query to calculate the average sale for each month. find out best selling month in each year
SELECT * FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY 1,2
) AS T1
WHERE rank = 1
--ORDER BY 1,3 DESC;

-- Q8 Write a SQl query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q9 Write a SQl query to find the number of unique customers who purchased items from each category
SELECT 
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- Q10 Write a SQl query to create each shift and number of orders (Example Morning <= 12,afternoon Between 12 & 17,Evening > 17 )
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
	FROM hourly_sale
GROUP BY shift

--END Of Project--
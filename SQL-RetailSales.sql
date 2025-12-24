-- SQL retail sales analysis

--Table creation 
CREATE TABLE retail_sales (
transactions_id int PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR (15),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);



-- DATA CLEANING 
SELECT * FROM retail_sales
WHERE sale_date IS NULL
OR transactions_id IS NULL
OR sale_date IS NULL
OR gender IS NULL
OR category IS NULL
OR quantiy IS NULL
OR cogs IS NULL 
OR total_sale IS NULL

--DELETING NULL ROWS 

DELETE FROM retail_sales
WHERE 
sale_date IS NULL
OR transactions_id IS NULL
OR sale_date IS NULL
OR gender IS NULL
OR category IS NULL
OR quantiy IS NULL
OR cogs IS NULL 
OR total_sale IS NULL

--changing the column name quantiy to quantity 
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity 

-- DATA EXPLORATION
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT (*) FROM retail_sales

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

-- number of sales we have 
SELECT COUNT(*) as total_sales FROM retail_sales

--number of unique customers 
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales

--number of unique categories 
SELECT COUNT (DISTINCT category) as total_categories FROM retail_sales

--the names of the different categories 
SELECT DISTINCT category  as categ_names FROM retail_sales

--DATA ANALYSIS & BUSINESS KEY PROBLEMS
--QUERIES AS ANSWERS
-- retrieving all sales for columns made on '2022-11-05'
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05'

--retrieving all transactions where category is 'Clothing' and the quantity sold is equal or more than 4 in Nov 2022
SELECT *
FROM retail_sales 
WHERE category = 'Clothing'
    AND 
	 TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	 AND
	 quantity >= 4

--calculate the total sales for each category 
SELECT category, 
      SUM(total_sale) as net_sale,
	  COUNT(*) as total_orders
FROM retail_sales 
GROUP BY 1

--the average age of customers who purchased items from the'Beauty' category 
SELECT  ROUND(AVG (age),2) as average_age
FROM retail_sales
WHERE category = 'Beauty'

--find all transactions where the total_sale is greater than 1000
SELECT * 
FROM retail_sales 
WHERE total_sale > 1000

--find the total number of transactions made by each gender in each category 
SELECT gender,
       category,
       COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 1, 2
ORDER BY 2

--calculate the average sale of each month. Find out the best selling month in each year 
SELECT year, month, average_sales FROM
(
SELECT 
      EXTRACT(YEAR FROM sale_date) as year,
	  EXTRACT(MONTH FROM sale_date) as month,
	  ROUND(AVG(total_sale)) as average_sales,
	  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2) as TAB1

WHERE rank = 1

--Find the top 5 customers based on the highest total sales
SELECT customer_id,
       SUM(total_sale) as total_sales
FROM retail_sales 
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 5

--Find the number of unique customers who purchased items from each category.
SELECT category,
       COUNT(DISTINCT customer_id) as unique_customers_total 
FROM retail_sales
GROUP BY category 

--create each shift and number of orders

WITH hourly_sales
AS
(
SELECT *,
    CASE 
	  WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN  'Morning'
	  WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	  ELSE 'Evening'
  END as shift	  
FROM retail_sales	
)
SELECT
    shift,
    COUNT(transactions_id) as total_orders
FROM hourly_sales	
GROUP BY shift
ORDER BY 2
	   
--current time 
SELECT EXTRACT (HOUR FROM CURRENT_TIME)

--END OF PROJECT



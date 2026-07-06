--- Database and Table creation

create database mall_data;
use mall_data;
drop table if exists retail_sales; 
create table retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date	date,
	sale_time	time,
	customer_id int,
	gender	VARCHAR(8),
	age INT,
	category VARCHAR(15),
	quantiy	INT,
	price_per_unit FLOAT,	
	cogs FLOAT,	
	total_sale float
);

--- Preliminary Data Cleaning (checking for null values)

select * FROM retail_sales;
select count(*)FROM retail_sales
where 
    transactions_id	is null
    or
	sale_date	is null
    or
	sale_time	is null or
	customer_id is null or	
	gender	is null or
	age	is null or
	category	is null or
	quantiy	is null or
	price_per_unit	is null or
	cogs	is null or
	total_sale is null ;
    
--- Some basic Exploritary Data analysis---

--- SQL query to retrieve all columns for sales made on '2022-11-05'

select * FROM retail_sales
where sale_date="2022-11-05";

--- SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select transactions_id,category,total_sale
 FROM retail_sales
 where  category="Clothing"
	 and
	 quantiy >= 4
	 and
	 year(sale_date)=2022
	 and
	 month(sale_date)=11
	;
    
--- calculate the total sales (total_sale) for each category

select category,sum(total_sale)
 FROM retail_sales
 group by 1;
 
 --- average age of customers who purchased items from the 'Beauty' category
 
 select category,avg(age)
 FROM retail_sales
 where category="Beauty";
 
--- find all transactions where the total_sale is greater than 1000

 select transactions_id,category,count(total_sale)
 FROM retail_sales
 where total_sale>1000
 group by category
 order by 3 desc;
 
--- find the total number of transactions (transaction_id) made by each gender in each category  

select 
	category,
	gender,
	count(transactions_id) as total_trans
FROM 
	retail_sales
group by 1,2
order by 1,2 desc;

--- calculate the average sale for each month. Find out best selling month in each year

select
  yr,mnt,avg_sale
from(
  select 
         year(sale_date) as yr,
         month(sale_date) as mnt,
         avg(total_sale) as avg_sale, 
         rank() over(partition by year(sale_date)  order by avg(total_sale) desc ) as rnk
from retail_sales
group by 1,2) as t1
where rnk=1
;


--- find the top 5 customers based on the highest total sales

select customer_id,sum(total_sale) as total_sale,
rank() over(order by sum(total_sale) desc) as best_performance
FROM retail_sales
group by 1
limit 5;


--- find the number of unique customers who purchased items from each category. 

select count(distinct customer_id),category FROM retail_sales
group by 2
;

--- SQL query to create each shift and number of orders

with hourly_sale as
(select *, 
  case 
       when hour(sale_time)<12 then "morning"
       when  hour(sale_time) between 12 and 17 then "afternoon"
       else "evening"
 end as shift
FROM retail_sales)
select count(*),shift from hourly_sale
group by shift;

 


 
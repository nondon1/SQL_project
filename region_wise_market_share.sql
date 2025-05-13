with cte1 as
(select c.customer , c.region,
 round(sum(net_sales)/1000000,2) as Net_sales_million
 from gdb0041.net_sales s
 join gdb0041.dim_customer c
 on s.customer_code = c.customer_code
 where s.fiscal_year = 2021
 group by c.customer, c.region)
 
 select * ,
 Net_sales_million*100/sum(Net_sales_million) over (partition by region) as 
 per_share_region
 from cte1 order by region, Net_sales_million desc
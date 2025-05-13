Select
 *,
amount*100/sum(amount) over (partition by category) as pct 
from random_tables.expenses 
order by category;

Select
 *,
sum(amount) over (partition by category order by date) as total_expense_till_adte
from random_tables.expenses 
order by category;

with cte1 as( 
select customer , 
 round(sum(net_sales)/1000000,2) as Net_sales_million
 from gdb0041.net_sales s
 join gdb0041.dim_customer c
 on s.customer_code = c.customer_code
 where s.fiscal_year = 2021
 group by customer) 
 
 select *,
 Net_sales_million*100/sum(Net_sales_million) over () as pct from cte1
 order by Net_sales_million desc

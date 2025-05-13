 select market , 
 round(sum(net_sales)/1000000,2) as Net_sales_million
 from gdb0041.net_sales 
 where fiscal_year = 2021
 group by market 
 order by Net_sales_million desc 
 limit 5;
 
  select product , 
 round(sum(net_sales)/1000000,2) as Net_sales_million
 from gdb0041.net_sales 
 where fiscal_year = 2021
 group by market 
 order by Net_sales_million desc 
 limit 5;
 
 select c.customer , 
 round(sum(net_sales)/1000000,2) as Net_sales_million
 from gdb0041.net_sales n
 join dim_customer c
 on n.customer_code = c.customer_code
 where fiscal_year = 2021
 group by c.customer 
 order by Net_sales_million desc 
 limit 5;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 select *,  
 (1- pre_invoice_discount_pct) *gross_price_total as 
net_invoice_sales , (po.discounts_pct+po.other_deductions_pct) as
post_invoice_discount_pct
 from sales_preinv_discount s
 join fact_post_invoice_deductions po 
 on 
 s.date=po.date and
 s.product_code =po.product_code and
 s.customer_code = po.customer_code;
 
 
 
 
 
 
 
 
 
 
 
 select s.date, s.product_code, p.product,p.variant, s.sold_quantity,
g.gross_price, round(g.gross_price * s.sold_quantity,2) as gross_price_total,
pre.pre_invoice_discount_pct
from fact_sales_monthly s 

join dim_product p
 on s.product_code = p.product_code 
 JOIN dim_date  dt
 on dt.calender_date=s.date
 join fact_gross_price g 
 on g.product_code = s.product_code and
 g.fiscal_year = dt.fiscal_year
 
 join fact_pre_invoice_deductions pre
 on pre.customer_code=s.customer_code and
 pre.fiscal_year=dt.fiscal_year
 
 where 
 dt.fiscal_year=2021  limit 1000000;
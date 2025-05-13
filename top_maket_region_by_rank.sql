with cte1 as (select 
p.division,
p.product,
sum(sold_quantity) as total_qty
from fact_sales_monthly s 
join dim_product p
on p.product_code =s.product_code 
where fiscal_year = 2021
group by p.division ,p.product),

cte2 as
(select *,
dense_rank() over(partition by division order by total_qty desc) as drnk
from cte1 )
select * from cte2 where drnk<=3;




with cte1 as (
		select
			c.market,
			c.region,
			round(sum(gross_price_total)/1000000,2) as gross_sales_mln
			from gross_sales s
			join dim_customer c
			on c.customer_code=s.customer_code
			where fiscal_year=2021
			group by market,region
			order by gross_sales_mln desc
		),
		cte2 as (
			select *,
			dense_rank() over(partition by region order by gross_sales_mln desc) as drnk
			from cte1
		)
	select * from cte2 where drnk<=2
		


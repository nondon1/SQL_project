with cte1 as (
select *,
row_number () over(partition by category order by amount desc) as rownumber,
rank() over(partition by category order by amount desc) as rnk,
dense_rank() over(partition by category order by amount desc) as drnk
 from expenses order by category)
 select * from cte1 where rownumber <=2
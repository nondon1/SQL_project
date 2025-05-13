/*Chapter - 2 */
select * from movies where industry ="Bollywood";
select count(*)  from movies where industry ="Hollywood";
select distinct industry from movies;
select * from movies where title LIKE  "%THOR%";
select * from movies where title LIKE  "America%";
select * from movies where studio ="";
/*Excercise*/
Select title, release_year from movies where studio ="Marvel studios";
select * from movies where title LIKE  "%Avenger%";
select release_year from movies where title="The Godfather";
select distinct studio from movies where  industry ="Bollywood" ;
/*Excercise*/

select * from movies where imdb_rating>=9;
select * from movies where imdb_rating<=5;
select * from movies where imdb_rating>=6 and imdb_rating<=9;
select * from movies where imdb_rating between 6 and 9;
select * from movies where release_year=2022 or release_year=2019;
select * from movies where release_year IN (2018,2019,2022);
select * from movies where studio IN ("Marvel Studios","Zee Studios");
select * from movies where imdb_rating is NULL;
select * from movies where imdb_rating is NOT NULL;
select * from movies where industry ="Bollywood" order by imdb_rating;
select * from movies where industry ="Bollywood" order by imdb_rating desc;
select * from movies where industry ="Bollywood" order by imdb_rating desc limit 5 ;
select * from movies where industry ="Hollywood" order by imdb_rating desc 
limit 5  offset 4;

/*Excercise*/
select * from movies order by release_year desc;
select * from movies where release_year in (2022);
select * from movies where release_year > 2020;
select * from movies where release_year > 2020 and imdb_rating>8;
select * from movies where studio in( "Marvel studios", "Hombale Films");
select * from movies where title  like"%THOR%" order by release_year asc;
select * from movies where studio != "Marvel Studios";
/*Excercise*/

select max(imdb_rating) from movies where industry="bollywood";
select min(imdb_rating) from movies where industry="bollywood";
select avg(imdb_rating) from movies where studio="Marvel Studios";
select round(avg(imdb_rating)) from movies where studio="Marvel Studios";
select round(avg(imdb_rating),2) as avg_rating from movies where studio="Marvel Studios";
select min(imdb_rating) as min_rating,
max(imdb_rating) as max_rating,
round(avg(imdb_rating),2) as avg_rating
from movies where studio="Marvel Studios";
select industry, count(*) from movies group by industry;
select studio, count(*) as Count from movies group by studio order by count desc;
select industry, count(industry) as count,
round(avg(imdb_rating),2) as avg_rating 
 from movies group by industry;
 select studio, count(studio) as count,
round(avg(imdb_rating),2) as avg_rating 
 from movies where studio !="" group by studio;

/*Excercise*/
select industry, count(*) from movies where  release_year between 2015 and 2022 group by industry;
select industry, min(release_year) as min_release,
max(release_year) as max_release from movies  group by industry;
select release_year, count(*) as movies from movies 
group by release_year order by release_year desc;
/*Excercise*/

select release_year, count(*) as movies_count from movies
 group by release_year having 
movies_count>2 order by movies_count desc;

select year(curdate());
select *, year(curdate())- birth_year as age from actors;
select *, (revenue-budget) as profit from financials;
select *, If (Currency='USD', revenue*77,revenue) as revenue_inr from
financials;
select *,
CASE 
when unit ='Thousands' then revenue/1000
when unit ='Billions' then revenue*1000
Else revenue
END as revenue_millions
from financials;
/*Excercise*/
select 
        *, 
    (revenue-budget) as profit, 
    (revenue-budget)*100/budget as profit_pct 
   from financials;
   /*Excercise*/
   
select m.movie_id,title,budget,revenue,currency,unit from movies m
   join financials f on m.movie_id=f.movie_id;
   select m.movie_id,title,budget,revenue,currency,unit from movies m
   left join financials f on m.movie_id=f.movie_id;
    select m.movie_id,title,budget,revenue,currency,unit from movies m
   Right join financials f on m.movie_id=f.movie_id;
   select f.movie_id,title,budget,revenue,currency,unit from movies m
   Right join financials f on m.movie_id=f.movie_id;
   
   select m.movie_id,title,budget,revenue,currency,unit from movies m
   Right join financials f on m.movie_id=f.movie_id
   union
   select f.movie_id,title,budget,revenue,currency,unit from movies m
   Right join financials f on m.movie_id=f.movie_id;
   
    /*Excercise*/
    select movie_id,title,l.language_id,l.name from movies m
    join languages l on m.language_id=l.language_id;
    select movie_id,title,l.language_id,l.name from movies m
    join languages l on m.language_id=l.language_id where l.name ="Telugu";
    select l.name, count(m.movie_id) as  no_movies from movies m
    left join languages l on m.language_id=l.language_id group by l.language_id ORDER BY no_movies DESC;
     /*Excercise*/
     
     /*Cross Jion*/
     select * from food_db.items 
     cross join food_db.variants;
     select *,concat(name,"-",variant_name) as full_name,
     (price+variant_price) as full_price 
     from food_db.items 
     cross join food_db.variants;
     
     select 
     m.movie_id,title,budget,revenue,currency,unit,
     case
     when unit="thousands" then round((revenue-budget)/1000,1)
     when unit="Billions" then round((revenue-budget)*1000,1)
     else (revenue-budget)
     end as profit_million
     from movies m join financials f on m.movie_id=f.movie_id
     where industry ="bollywood" order by profit_million desc;
     
     select m.title, group_concat(a.name SEPARATOR " ; ") AS ACTORS
      from movies m
      join movie_actor ma on ma.movie_id = m.movie_id
      join actors a on a.actor_id = ma.actor_id
      group by m.movie_id;
      
      select a.name , group_concat(m.title SEPARATOR " ; ") AS movies,
      count(m.title) as movie_count
      from actors a
      join movie_actor ma on ma.actor_id = a.actor_id
      join movies m  on m.movie_id = ma.movie_id
      group by a.actor_id
      order by movie_count desc;
     
     /*Excercise*/
     select m.title,revenue, unit ,
     case
     when unit="thousands" then round((revenue)/1000,2)
     when unit="Billions" then round((revenue)*1000,2)
     else (revenue)
     end as revenue_milln
     from movies m 
     join financials f on f.movie_id = m.movie_id
     JOIN languages l
			ON m.language_id=l.language_id
	WHERE l.name="Hindi"
      order by revenue_milln desc ;
     /*Excercise*/
#returns a single value      
select * from movies where imdb_rating=
(select max(imdb_rating) from movies);
select * from movies where imdb_rating=
(select min(imdb_rating) from movies);
#returns a list of values
select * from movies where imdb_rating in
((select max(imdb_rating) from movies),(select min(imdb_rating) from movies));
#returns a table
select * from 
(select name,year(curdate())-birth_year as age from actors) as actors_age
where age>70 and age<85;
#Any operator
select * from actors where actor_id = any (
select actor_id from movie_actor where movie_id in (101,110,121));
select * from movies where imdb_rating > any (
select imdb_rating from movies where studio="Marvel Studios");

/*Excercise*/
select * from movies where release_year in (
(select min(release_year) from movies), 
(select max(release_year) from movies));

select * from movies where imdb_rating >
(select avg(imdb_rating) from movies);
/*Excercise*/

#CTE
with actors_age as (
select name as actor_name, year (curdate()) - birth_year as age from actors)
select actor_name, age from actors_age where age > 70 and age <85; 

/*Excercise*/
with x as (select title, release_year, (revenue-budget) as profit
			from movies m
			join financials f
			on m.movie_id=f.movie_id
			where release_year>2000 and industry="hollywood"
	)
	select * from x where profit>500;
/*Excercise*/ 

select * from financials;

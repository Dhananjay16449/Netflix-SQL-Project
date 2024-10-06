CREATE TABLE NETFLIX(
	show_id	varchar(6), 
	type  varchar(10), 
	title  varchar(150),
	director varchar(250),	
	casts  varchar(800),	
	country	varchar(150), 
	date_added	date,
	release_year numeric(5),
	rating	varchar(10),
	duration	varchar(15),
	listed_in	varchar(100),
	description  varchar(300)

);

SELECT * from netflix;


SELECT count(*) as total_content from netflix;

SELECT DISTINCT type from netflix;

SELECT * from netflix;



-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows

SELECT type,
	count(*) as total_count FROM netflix
GROUP BY 1;



2. Find the most common rating for movies and TV shows

WITH RatingCount AS(
   SELECT 
      type, 
      rating, 
      count(*) as rating_count 
   from netflix
   GROUP BY 1,2
   ),
RankedRating AS(
   Select 
      type,
      rating,
      rating_count,
      rank() OVER(Partition BY type order by rating_count DESC) as Ranks
   FROM RatingCount
   ) 
   SELECT 
       type,
	   rating as most_frequent_rating
    FROM RankedRating
	where ranks = 1;




3. List all movies released in a specific year (e.g., 2020)


SELECT 
   title 
from netflix
where release_year = 2020;


4. Find the top 5 countries with the most content on Netflix


SELECT * 
From (
    Select 
	   Unnest(string_to_array(country,', ')) as country,
	   count(*) as total_content
	 FROM netflix
	 Group By 1
) as T1
WHERE country is not null
order by total_content desc
LIMIT 5;




5. Identify the longest movie




SELECT 
    title,
	duration
from netflix
where type = 'Movie' and duration is not null
order by split_part(duration,' ',1)::INT desc;



6. Find content added in the last 5 years

SELECT * 
from netflix
WHERE date_added>= Current_date - interval '5 years' ;




7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * 
from netflix
WHERE director like ('%Rajiv Chilaka%');


select * 
from 
	(Select *,
		Unnest(string_to_array(director,',')) as director_name
	from netflix)
where director_name = 'Rajiv Chilaka';



8. List all TV shows with more than 5 seasons


SELECT * 
from netflix
Where type = 'TV Show' 
and
Split_part(duration,' ',1)::INT>5;




9. Count the number of content items in each genre


SELECT unnest(string_to_array(listed_in,', ')) as genre,
       Count(*) as Total_content
From netflix
GROUP BY 1;



10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select Country,
       release_year,
	   count(show_id) as total_release,
	   round(count(show_id)::numeric/
	                        (select count(show_id) from netflix where country ='India')::numeric*100,2) as avg_release
from netflix
where country = 'India'
group by 1,2
order by avg_release desc
limit 5;





11. List all movies that are documentaries

Select * 
from netflix
where listed_in like ('%Documentaries%');




12. Find all content without a director


Select * 
from netflix
where director is null;



13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

Select title,
	casts,
	release_year 
from netflix
where casts ilike ('%Salman Khan%') 
and
release_year > Extract(year from current_date) -10;


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT Unnest(String_to_array(casts,', ')) as Actors,
       Count(*) as Total_Projects
from netflix
where country ='India'
group by 1
order by 2 desc
limit 10;



15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


SELECT Category,
	type,
	count(*) as content_count
FROM
(Select *,
	case
	when description ilike ('%kill%') or description ilike ('%violence%') then 'Bad'
	else 'Good'
	end as category
from netflix) as Category_content
GROUP by 1,2
order by 2;











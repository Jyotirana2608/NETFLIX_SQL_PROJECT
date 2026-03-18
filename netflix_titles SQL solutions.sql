# Netflix project #

CREATE DATABASE netflix_db1;
USE netflix_db1;



CREATE TABLE netflix
(
  show_id VARCHAR(10),
  type VARCHAR(10),
  title VARCHAR(150),
  director VARCHAR(208),
  cast VARCHAR(1000),
  country VARCHAR(150),
  date_added VARCHAR(50),
  release_year INT,
  rating VARCHAR(10),
  duration VARCHAR(15),
  listed_in VARCHAR(150),
  description VARCHAR(500)
);

SELECT * FROM netflix;

SELECT COUNT(*) as totalt_content
 FROM netflix;

select DISTINCT TYPE
	from netflix;
    
# --15 business problems -- #

#----1.  Count the number of movies vs TV Shows----#

SELECT TYPE, COUNT(*) as totalt_content from netflix
GROUP BY type;

#--2. Find the most common rating for movies and Tv shows #

Select type, rating 
	from
	(
	select type, rating, COUNT(*),
	 RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	 from netflix
     GROUP BY 1,2
	 ) as t1
     where ranking = 1 ;
     
     #--3. list all moviesreleased in a specific year ( eg 2020) #

SELECT *
FROM netflix
WHERE
	type = 'Movie'
    AND
    release_year = 2020;
    
#--4. find the top 5 countries with the most content on netflix #

SELECT country, COUNT(*) AS total_content
FROM netflix
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

# 5. Identify the longest movie? #

SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY duration DESC;

#  if need top 5 then add LIMIT 5  #

# 6.  Find content added in last 5 years? #
  
 SELECT *
FROM netflix
WHERE YEAR(STR_TO_DATE(date_added,'%M %d, %Y')) >= YEAR(CURDATE()) - 5;

# 7.  Find all the movies/tv shows by director "Toshiya Shinohara" #

SELECT *
FROM netflix
WHERE director LIKE '%Toshiya Shinohara%';
    
	
# 8. List all TV shows with more than 5 seasons?

SELECT *
FROM netflix
WHERE type = 'TV Show'
AND duration LIKE '%Seasons%'
AND duration > '5 Seasons';

# 9.  count the number of content items in each genre #

SELECT listed_in, COUNT(*) AS total_content
FROM netflix
GROUP BY listed_in;

# 10. Find each year and the average numbers of content release by India on netflix return top 5 year with highest avg content release!


SELECT 
    release_year,
    COUNT(*) AS total_content
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY total_content DESC
LIMIT 5;

# 11. List all movies that are documenteries.

SELECT * FROM netflix
 WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';

# 12. Find all content without a director.

SELECT *
FROM netflix
WHERE director IS NULL;

 #OR#
 
SELECT *
FROM netflix;
WHERE director = 'Not Given';

# 13. Find how many movies actor '  Chie Nakamura, appeared in last 10 years.

SELECT COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
AND cast LIKE '%Chie Nakamura%'
AND release_year >= YEAR(CURDATE()) - 10;

# 14.  Find the top 10 actors who have appeared in the highest number of movies produced in india.

SELECT cast, COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie'
AND country LIKE '%India%'
GROUP BY cast
ORDER BY total_movies DESC
LIMIT 10;

# 15. Categorize the content based on the presence of the keywords "kill" and "violence" in the description field. Label content containing these keywords as "Bad" and all other content as " Good". count how many items fall into each category.

SELECT 
CASE 
    WHEN description LIKE '%kill%' OR description LIKE '%violence%' 
    THEN 'Bad'
    ELSE 'Good'
END AS category,
COUNT(*) AS total
FROM netflix
GROUP BY category;




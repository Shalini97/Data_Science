USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:

-- Displaying the tables to view the content for further analysis.
SELECT * FROM genre;
SELECT * FROM movie;
SELECT * FROM names;
SELECT * FROM ratings;
SELECT * FROM role_mapping;

-- Q1. Find the total number of rows in each table of the schema?

SELECT COUNT(*) AS No_of_row_director_mapping FROM director_mapping;
-- Total numner of rows = 3876

SELECT COUNT(*) AS No_of_row_genre FROM genre;
-- Total Nos of rows = 14662

SELECT COUNT(*) AS No_of_row_movie FROM movie;
-- Total nos of rows = 7997

SELECT COUNT(*) AS No_of_row_names FROM names;
-- Total nos of rows = 25735

SELECT COUNT(*) AS No_of_row_ratings FROM ratings;
-- Total nos of rows = 7997

SELECT COUNT(*) AS No_of_row_role_mapping FROM role_mapping;
-- Total nos of rows = 15615


-- Q2. Which columns in the movie table have null values?
SELECT SUM(
       CASE
              WHEN id IS NULL THEN 1
              ELSE 0
       END) AS id_nulls,
       SUM(
       CASE
              WHEN title IS NULL THEN 1
              ELSE 0
       END) AS title_nulls,
       SUM(
       CASE
              WHEN year IS NULL THEN 1
              ELSE 0
       END) AS year_nulls,
       SUM(
       CASE
              WHEN date_published IS NULL THEN 1
              ELSE 0
       END) AS date_published_nulls,
       SUM(
       CASE
              WHEN duration IS NULL THEN 1
              ELSE 0
       END) AS duration_nulls,
       SUM(
       CASE
              WHEN country IS NULL THEN 1
              ELSE 0
       END) AS country_nulls,
       SUM(
       CASE
              WHEN worlwide_gross_income IS NULL THEN 1
              ELSE 0
       END) AS worlwide_gross_income_nulls,
       SUM(
       CASE
              WHEN languages IS NULL THEN 1
              ELSE 0
       END) AS languages_nulls,
       SUM(
       CASE
              WHEN production_company IS NULL THEN 1
              ELSE 0
       END) AS production_company_nulls
FROM   movie
;


-- Q3. Find the total number of movies released each year? How does the trend look month wise?

-- Number of movies released each year
SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year
ORDER BY year;

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- Highest number of movies were released in 2017


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/


-- Q4. How many movies were produced in the USA or India in the year 2019??

-- Pattern matching using LIKE operator for country column
SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 

-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/


-- Q5. Find the unique list of the genres present in the data set?


-- Finding unique genres using DISTINCT keyword
SELECT DISTINCT genre
FROM   genre; 

-- Output -- Drama -- Fantasy -- Thriller -- Comedy -- Horror 
-- Family -- Romance -- Adventure -- Action -- Sci-Fi -- Crime -- Mystery -- Others

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?


-- Using LIMIT clause to display only the genre with highest number of movies produced
SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
on     g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;

-- 4285 Drama movies were produced in total and are the highest among all genres. 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?


-- Using genre table to find movies which belong to only one genre
-- Grouping rows based on movie id and finding the distinct number of genre each movie belongs to
-- Using the result of CTE, we find the count of movies which belong to only one genre

WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre; 

-- 3289 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/


-- Q8.What is the average duration of movies in each genre? 


-- Finding the average duration of movies by grouping the genres that movies belong to 

SELECT     genre,
           Round(Avg(duration),2) AS avg_duration
FROM       movie                  AS m
INNER JOIN genre                  AS g
ON      g.movie_id = m.id
GROUP BY   genre
ORDER BY avg_duration DESC;

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/


-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 

-- CTE : Finds the rank of each genre based on the number of movies in each genre
-- Select query displays the genre rank and the number of movies belonging to Thriller genre

WITH genre_summary AS
(
           SELECT     genre,
                      Count(movie_id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
           FROM       genre                                 
           GROUP BY   genre )
SELECT *
FROM   genre_summary
WHERE  upper(genre) = "Thriller" ;

-- Thriller has rank=3 and movie count of 1484

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/






-- Segment 2:





-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?


-- Using MIN and MAX functions for the query 

SELECT Min(avg_rating)    AS MIN_AVG_RATING,
       Max(avg_rating)    AS MAX_AVG_RATING,
       Min(total_votes)   AS MIN_TOTAL_VOTES,
       Max(total_votes)   AS MAX_TOTAL_VOTES,
       Min(median_rating) AS MIN_MEDIAN_RATING,
       Max(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings; 


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/


-- Q11. Which are the top 10 movies based on average rating?

-- It's ok if RANK() or DENSE_RANK() is used too

-- Finding the rank of each movie based on it's average rating
-- Displaying the top 10 movies using LIMIT clause

SELECT     title,
           avg_rating,
           Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings                               AS r
INNER JOIN movie                                 AS m
ON         m.id = r.movie_id limit 10;

-- top 10 movies can also be displayed using WHERE caluse with CTE
WITH MOVIE_RANK AS
(
SELECT     title,
           avg_rating,
           ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings                               AS r
INNER JOIN movie                                 AS m
ON         m.id = r.movie_id
)
SELECT * FROM MOVIE_RANK
WHERE movie_rank<=10;

-- Top 3 movies have average rating >= 9.8


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/


-- Q12. Summarise the ratings table based on the movie counts by median ratings.

-- Finding the number of movies vased on median rating and sorting based on movie count.

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/


-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??

-- CTE: Finding the rank of production company based on movie count with average rating > 8 using RANK function.
-- Querying the CTE to find the production company with rank=1

WITH production_company_hit_movie_summary
     AS (SELECT production_company,
                Count(movie_id)                     AS MOVIE_COUNT,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1; 

-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?

-- Query to find 
-- 1. Number of movies released in each genre 
-- 2. During March 2017 
-- 3. In the USA  (LIKE operator is used for pattern matching)
-- 4. Movies had more than 1,000 votes

SELECT genre,
       Count(M.id) AS MOVIE_COUNT
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes


-- Lets try to analyse with a unique problem statement.


-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?

-- Query to find:
-- 1. Number of movies of each genre that start with the word ‘The’ (LIKE operator is used for pattern matching)
-- 2. Which have an average rating > 8?

SELECT  title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  avg_rating > 8
       AND title LIKE 'The%'
ORDER BY avg_rating DESC;
 
-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

-- BETWEEN operator is used to find the movies released between 1 April 2018 and 1 April 2019

SELECT median_rating, Count(*) AS movie_count
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.


-- Q17. Do German movies get more votes than Italian movies? 


-- Hint: Here you have to find the total number of votes for both German and Italian movies.
  SELECT
             CASE
                        WHEN languages LIKE '%German%' THEN 'German'
                        WHEN languages LIKE '%Italian%' THEN 'Italian'
             END              AS language,
             sum(total_votes)/count(movie_id) AS weighted_avg
  FROM       movie            AS m
  INNER JOIN ratings          AS r
  ON         m.id = r.movie_id
  WHERE      languages LIKE '%German%'
  OR         languages LIKE '%Italian%'
  GROUP BY   language
  ORDER BY   weighted_avg DESC;
  
-- By observation, German movies received the highest number of votes.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:




-- Q18. Which columns in the names table have null values??


-- NULL counts for columns of names table using CASE statements
SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;

-- Height, date_of_birth, known_for_movies columns contain NULLS

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/


-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?

-- CTE: Computes the top 3 genres using average rating > 8 condition and highest movie counts
-- Using the top genres derived from the CTE, the directors are found whose movies have an average rating > 8 and are sorted based on number of movies made.  

WITH top_genre
AS
  (
             SELECT     g.genre,
                        COUNT(g.movie_id) AS movie_count
             FROM       genre             AS g
             INNER JOIN ratings           AS r
             ON         g.movie_id = r.movie_id
             WHERE      avg_rating > 8
             GROUP BY   genre
             ORDER BY   COUNT(g.movie_id) DESC
             LIMIT      3 ),
  top_director
AS
  (
             SELECT     n.name                                             AS director_name,
                        COUNT(g.movie_id)                                  AS movie_count,
                        ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) AS director_row_RANK
             FROM       names                                              AS n
             INNER JOIN director_mapping                                   AS dm
             ON         n.id = dm.name_id
             INNER JOIN genre AS g
             ON         dm.movie_id = g.movie_id
             INNER JOIN top_genre tg
             ON         g.genre = tg.genre
             INNER JOIN ratings AS r
             ON         r.movie_id = g.movie_id,
                        top_genre
             WHERE      avg_rating>8
             GROUP BY   director_name
             ORDER BY   movie_count DESC )
  SELECT director_name,movie_count
  FROM   top_director
  WHERE  director_row_RANK <= 3 ;

-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/


-- Q20. Who are the top two actors whose movies have a median rating >= 8?

SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 
        
-- Top 2 actors are Mammootty and Mohanlal.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/


-- Q21. Which are the top three production houses based on the number of votes received by their movies?


WITH temp
AS
  (
             SELECT     production_company,
                        SUM(total_votes)                                  AS vote_count,
                        ROW_NUMBER() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_RANK
             FROM       movie                                             AS m
             INNER JOIN ratings                                           AS r
             ON         m.id = r.movie_id
             GROUP BY   production_company )
  SELECT *
  FROM   temp
  WHERE  prod_comp_RANK<=3 ;
  
-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/


-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

WITH actor_summary
     AS (SELECT N.NAME                                                     AS
                actor_name
                ,
                sum(total_votes)                                           AS
                   total_votes,
                Count(R.movie_id)                                          AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actor_avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names AS N
                        ON RM.name_id = N.id
         WHERE  category = 'ACTOR'
                AND country like "%india%"
         GROUP  BY NAME
         HAVING movie_count >= 5)
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_summary; 

-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      sum(total_votes)                                      AS total_votes, 
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           WHERE      category = 'ACTRESS'
           AND        country like "%INDIA%"
           AND        languages LIKE '%HINDI%'
           GROUP BY   NAME
           HAVING     movie_count>=3 )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary LIMIT 5;

-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
---------------------------------------------------------------------------------------------------------- */

-- Using CASE statements to classify thriller movies as per avg rating 

  SELECT     title,
             CASE
                        WHEN avg_rating > 8 THEN 'Superhit movies'
                        WHEN avg_rating BETWEEN 7 AND        8 THEN 'Hit movies'
                        WHEN avg_rating BETWEEN 5 AND        7 THEN 'One-time-watch movies'
                        WHEN avg_rating < 5 THEN 'Flop movies'
             END     AS movie_category
  FROM       movie   AS m
  INNER JOIN ratings AS r
  ON         m.id = r.movie_id
  INNER JOIN genre AS g
  ON         m.id=g.movie_id
  WHERE      genre='Thriller' ;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/




-- Segment 4:




-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.)


SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.


-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres?

-- (Note: The top 3 genres would have the most number of movies.)

-- Top 3 Genres based on most number of movies

 
WITH temp
AS
  (
           SELECT   genre,
                    COUNT(movie_id) movie_cnt
           FROM     genre
           GROUP BY genre
           ORDER BY COUNT(movie_id) DESC
           LIMIT    3 ),
  temp2
AS
  ( 
             SELECT     g.genre,
                        year,
                        title AS movie_name,
                        worlwide_gross_income,
                        cast(case when worlwide_gross_income like '$%' then SUBSTRING(worlwide_gross_income, 3)
                        when worlwide_gross_income like 'INR%' then SUBSTRING(worlwide_gross_income, 5)
                        when worlwide_gross_income is null then 0 end as float) as wg
                        
             FROM       movie                                                                    AS m
             INNER JOIN genre                                                                    AS g
             ON         m.id= g.movie_id
             INNER JOIN temp t
             ON         g.genre = t.genre 

  ),
    temp3
AS
  ( 
  SELECT genre,
		 year,
		 movie_name,wg as worlwide_gross_income,
         ROW_NUMBER() OVER(PARTITION BY g.genre,year ORDER BY wg DESC) AS movie_RANK
  FROM   temp2
  ) 
  select * from temp3
  where movie_RANK <=5
  ;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.


-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?


 SELECT     production_company,
             COUNT(m.id)                                AS movie_count,
             ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_RANK
  FROM       movie                                      AS m
  INNER JOIN ratings                                    AS r
  ON         m.id=r.movie_id
  WHERE      median_rating>=8
  AND        production_company IS NOT NULL
  AND        position(',' IN languages)>0
  GROUP BY   production_company
  LIMIT      2;

-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?


-- Top 3 actresses based on number of Super Hit movies
 
    SELECT     name                                             AS actress_name,
             SUM(total_votes)                                 AS total_votes,
             COUNT(rm.movie_id)                               AS movie_count,
             AVG(avg_rating)                                  AS actress_avg_rating,
             Dense_RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_RANK
  FROM       names                                            AS n
  INNER JOIN role_mapping                                     AS rm
  ON         n.id = rm.name_id
  INNER JOIN ratings AS r
  ON         r.movie_id = rm.movie_id
  INNER JOIN genre AS g
  ON         r.movie_id = g.movie_id
  WHERE      category = 'actress'
  AND        avg_rating > 8
  AND        genre = 'Drama'
  GROUP BY   name
  LIMIT      3;

-- Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu,Susan Brown,Amanda Lawrence


 /* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
MIN rating
MAX rating
total movie durations
Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id | director_name | number_of_movies  | avg_inter_movie_days | avg_rating | total_votes  | MIN_rating | MAX_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967  | A.L. Vijay  |   5    |        177    |    5.65     | 1754    | 3.7  | 6.9   |  613    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
| .   |  .   |   .    |        .    |    .     | .     | .  | .   |  .    |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
--------------------------------------------------------------------------------------------*/
  -- Type you code below:
WITH movie_date_info
AS
  (
           SELECT   d.name_id,
                    name,
                    d.movie_id,
                    m.date_published,
                    lead(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
           FROM     director_mapping d
           JOIN     names AS n
           ON       d.name_id=n.id
           JOIN     movie AS m
           ON       d.movie_id=m.id ),
  date_difference
AS
  (
         SELECT *,
                datediff(next_movie_date, date_published) AS diff
         FROM   movie_date_info ),
  avg_inter_days
AS
  (
           SELECT   name_id,
                    AVG(diff) AS avg_inter_movie_days
           FROM     date_difference
           GROUP BY name_id ),
  final_result
AS
  (
           SELECT   d.name_id                                          AS director_id,
                    name                                               AS director_name,
                    COUNT(d.movie_id)                                  AS number_of_movies,
                    ROUND(avg_inter_movie_days)                        AS inter_movie_days,
                    ROUND(AVG(avg_rating),2)                           AS avg_rating,
                    SUM(total_votes)                                   AS total_votes,
                    MIN(avg_rating)                                    AS MIN_rating,
                    MAX(avg_rating)                                    AS MAX_rating,
                    SUM(duration)                                      AS total_duration,
                    ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_RANK
           FROM     names                                              AS n
           JOIN     director_mapping                                   AS d
           ON       n.id=d.name_id
           JOIN     ratings AS r
           ON       d.movie_id=r.movie_id
           JOIN     movie AS m
           ON       m.id=r.movie_id
           JOIN     avg_inter_days AS a
           ON       a.name_id=d.name_id
           GROUP BY director_id )
  SELECT *
  FROM   final_result
  LIMIT  9;



















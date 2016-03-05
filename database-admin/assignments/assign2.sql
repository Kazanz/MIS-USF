/* 
Interesting Query 1 (Zach Kazanski):

Get names of all movies playing between 6-9 pm in Tampa
*/
SELECT movies.title FROM movies
INNER JOIN genre ON movies.film_id = genre.film_id
WHERE
  genre.genre = 'Action' AND
  movies.film_id IN
  (SELECT 
      film_id FROM movie_time 
  INNER JOIN
    theatres ON movie_time.theatre_id = theatres.id
  WHERE
    theatres.city = 'Tampa' AND
    movie_time.start_time >= 18 AND
    movie_time.start_time <= 21);

/* 
Interesting Query 2 (Zach Kazanski):

Get the Movie title, the title it played in, and the rating in that city.
*/   

SELECT now_playing_map.title, now_playing_map.city, rating_map.rating
FROM (
  SELECT movies.title, now_playing.city
  FROM movies
  INNER JOIN (
    SELECT 
      theatres.city, fan_rating.film_id
    FROM fan_rating
    INNER JOIN theatres ON theatres.id = fan_rating.theatre_id
  ) now_playing 
  ON now_playing.film_id = movies.film_id
) now_playing_map
INNER JOIN (
  SELECT 
    movies.title,
    AVG(fan_rating.film_rating) as rating
  FROM fan_rating
  INNER JOIN movies ON movies.film_id = fan_rating.film_id
  GROUP BY movies.title
) rating_map 
ON rating_map.title = now_playing_map.title;

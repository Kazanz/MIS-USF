CREATE TABLE movies (
  film_id INT NOT NULL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  worldwide_gross INT NOT NULL
);

CREATE TABLE theatres (
  id INT NOT NULL PRIMARY KEY,
  city VARCHAR(255) NOT NULL
);

CREATE TABLE movie_time (
  film_id INT NOT NULL,
  theatre_id INT NOT NULL,
  start_time INT NOT NULL CHECK(start_time >= 0 and start_time <= 24),
  FOREIGN KEY (film_id) 
    REFERENCES movies(film_id)
    ON DELETE CASCADE,
  FOREIGN KEY (theatre_id)
    REFERENCES theatres(id)
    ON DELETE CASCADE
);

CREATE TABLE genre (
  film_id INT NOT NULL,
  genre VARCHAR(255) NOT NULL,
  FOREIGN KEY (film_id)
    REFERENCES movies(film_id)
    ON DELETE CASCADE
);

CREATE TABLE fan_rating (
  film_id INT NOT NULL,
  theatre_id INT NOT NULL,
  film_rating INT NOT NULL CHECK(film_rating >= 0 AND film_rating <= 10),
  theatre_rating INT NOT NULL CHECK(theatre_rating >= 0 AND theatre_rating <= 10),
  FOREIGN KEY (film_id)
    REFERENCES movies(film_id)
    ON DELETE CASCADE,
  FOREIGN KEY (theatre_id)
    REFERENCES theatres(id)
    ON DELETE CASCADE
);

INSERT INTO movies
  SELECT film_id, film_title, WORLDWIDE_GROSS
  FROM RELMDB.movies
  WHERE WORLDWIDE_GROSS IS NOT NULL;

INSERT INTO genre
  SELECT film_id, genre FROM RELMDB.genres
  WHERE film_ID IN (SELECT film_id FROM movies);
  
INSERT INTO theatres VALUES (1, 'Tampa');
INSERT INTO theatres VALUES (2, 'Tampa');
INSERT INTO theatres VALUES (3, 'Chicago');

INSERT INTO fan_rating
SELECT film_id, round(dbms_random.value(1,3)), round(dbms_random.value(1,10)), round(dbms_random.value(1,10)) 
FROM movies;

INSERT INTO movie_time
SELECT film_id, round(dbms_random.value(1,(SELECT COUNT(*)-1 FROM theatres))), round(dbms_random.value(17,23)) 
FROM movies;

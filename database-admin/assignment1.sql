/* Question #1 */

SELECT
  beers.beer_name, styles.style_name
FROM
  beers
LEFT OUTER JOIN styles
  ON beers.style_id = styles.style_id;


/* Question #2 */

SELECT
  beers.beer_name,
  categories.category_name,
  colors.examples,
  styles.style_name
FROM
  beers
INNER JOIN categories
  ON beers.cat_id = categories.category_id
INNER JOIN beerdb.colors colors
  ON beers.srm = colors.lovibond_srm
INNER JOIN styles
  ON beers.style_id = styles.style_id
WHERE
  categories.category_name IS NOT NULL AND
  colors.examples IS NOT NULL AND
  styles.style_name IS NOT NULL;
  
  
/* Question #3 */

SELECT
  breweries.name,
  AVG(beers.abv) AS "average abv",
  MAX(beers.abv) AS "max abv",
  MIN(beers.abv) AS "min abv"
FROM
  beers
INNER JOIN breweries
  ON breweries.brewery_id = beers.brewery_id
WHERE
  beers.abv > 0
GROUP BY breweries.name
ORDER BY "max abv" DESC;


/* Question #4 */

SELECT
  beers.beer_name
FROM
  beers
INNER JOIN categories
  ON beers.cat_id = categories.category_id
WHERE
  beers.abv >= 8 AND
  categories.category_name LIKE '%Lager%'
ORDER BY
  beers.beer_name;

  
/* Question #5 

Note: The query `SELECT DISTINCT(country) FROM breweries ORDER BY country;`
      was run initially to confirm that  "United States" is the only value
      Identifying the brewery country as the USA.
*/

SELECT
  breweries.name,
  COUNT(*) as "count"
FROM
  beers
INNER JOIN breweries
  ON beers.brewery_id = breweries.brewery_id
WHERE
  breweries.country = 'United States'
GROUP BY
  breweries.name
HAVING
  COUNT(*) > 9
ORDER BY
  "count" DESC,
  breweries.name;


/* 
Interesting query # 1: 

Display the state name and the average ABV, rounded to the nearest tenths,
of every beer brewed in that state, starting with the highest ABV and then the
name of the state if a tie, using only US states and ignore state abbrevs. 
Ignore a state if it has no beers. Only average together beers that were 
brewed by a brewery with a website.
*/

SELECT
  breweries.state,
  ROUND(AVG(beers.abv), 1) as "average"
FROM
  beers
INNER JOIN breweries
  ON beers.brewery_id = breweries.brewery_id
WHERE
  breweries.country = 'United States' AND
  breweries.state IS NOT NULL AND
  LENGTH(breweries.state) > 2 AND
  breweries.website IS NOT NULL
GROUP BY
  breweries.state
HAVING
  AVG(beers.abv) > 0
ORDER BY
  "average" DESC,
  breweries.state;

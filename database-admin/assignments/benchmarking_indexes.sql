/*************/
/* BENCHMARK */
/*************/

SELECT * FROM EMPLOYEE_TEST_DATA;
 
SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'SELECT * FROM EMPLOYEE_TEST_DATA';
 
/* The average of ten queries with no index comes to 7351ms. */


/********************************/
/* SELECT WITH DIFF CARDINALITY */
/********************************/

select * FROM EMPLOYEE_TEST_DATA;
 
SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'select * FROM EMPLOYEE_TEST_DATA';

 CREATE INDEX salary_idx ON EMPLOYEE_TEST_DATA(SALARY);
 
 SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'select * FROM EMPLOYEE_TEST_DATA';

/* The average of ten queries with an B+-Tree index on high cardinality SALARY
   comes to 3890ms. */

DROP INDEX salary_idx;
CREATE INDEX gender_idx ON EMPLOYEE_TEST_DATA(GENDER);

select * From EMPLOYEE_TEST_DATA;

SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'select * From EMPLOYEE_TEST_DATA';

/* The average of ten queries with B+-Tree index on low cardinality GENDER
  comes to 3800ms. */

 CREATE BITMAP INDEX salary_idx ON EMPLOYEE_TEST_DATA(SALARY);
 
 Select * From EMPLOYEE_TEST_DATA;
 
 SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'Select * From EMPLOYEE_TEST_DATA';

/* The average of ten queries with an Bitmap index on high cardinality SALARY
   comes to 3863ms. */

DROP INDEX salary_idx;
CREATE BITMAP INDEX gender_idx ON EMPLOYEE_TEST_DATA(GENDER);

Select * FROM EMPLOYEE_TEST_DATA;

SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'Select * FROM EMPLOYEE_TEST_DATA';

/* The average of ten queries with Bitmap index on low cardinality GENDER
  comes to 3661ms. */



/*******************************/
/* WHERE WITH HIGH CARDINALITY */
/*******************************/

DROP INDEX gender_idx;

SELECT * FROM EMPLOYEE_TEST_DATA where SALARY = 95049.27;
 
SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'SELECT * FROM EMPLOYEE_TEST_DATA where SALARY = 95049.27';
 
/* With no index the average of 10 queries is 6820ms. */
 
CREATE INDEX salary_idx on EMPLOYEE_TEST_DATA(SALARY);

select * FROM EMPLOYEE_TEST_DATA where SALARY = 95049.27;
 
SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'select * FROM EMPLOYEE_TEST_DATA where SALARY = 95049.27';

/* With a B-Tree index the average of 10 queries is 3356ms; */

DROP INDEX salary_idx;
CREATE BITMAP INDEX salary_idx ON EMPLOYEE_TEST_DATA(SALARY);

select * from EMPLOYEE_TEST_DATA where SALARY = 95049.27;
 
SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'select * from EMPLOYEE_TEST_DATA where SALARY = 95049.27';

/* With a Bitmap index the average of 10 queries is 48494ms. */


/******************************/
/* WHERE with low cardinality */
/******************************/
DROP INDEX salary_idx;

CREATE INDEX gender_idx on EMPLOYEE_TEST_DATA(GENDER);

SELECT * FROM EMPLOYEE_TEST_DATA where GENDER like 'Male';
 
SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'SELECT * FROM EMPLOYEE_TEST_DATA where GENDER like ''Male''';

/* With a B-Tree index the average of 10 queries is 4315ms. */

DROP INDEX gender_idx;
CREATE BITMAP INDEX gender_idx ON EMPLOYEE_TEST_DATA(GENDER);

select * from EMPLOYEE_TEST_DATA where GENDER like 'Male';
 
SELECT AVG(ELAPSED_TIME) from v$sql
 WHERE SQL_TEXT like 'select * from EMPLOYEE_TEST_DATA where GENDER like ''Male''';

/* With a Bitmap index the average of 10 queries is 3347ms; */

/* Get the most upvoted questions on the site */

SELECT * FROM Questions
WHERE id IN (
  SELECT * FROM (
    SELECT question_id FROM answers
    INNER JOIN responses ON answers.response_id = responses.id
    GROUP BY question_id
    ORDER BY SUM(upvotes) DESC
  )
  WHERE ROWNUM <= 20
);


/* Get the user who has the most upvotes. */

SELECT * from Users
WHERE users.id IN (
  SELECT * FROM (
    SELECT user_id FROM answers
    GROUP BY user_id
    ORDER BY SUM(upvotes) DESC
  )
  WHERE ROWNUM <= 20;
);

/* Top questions from each category that the user has know about. */

SELECT * FROM Questions
WHERE Questions.id IN (
  SELECT * FROM (
    SELECT Answers.question_id FROM Answers
    INNER JOIN Responses ON Answers.response_id = Responses.id
    GROUP BY Answers.question_id
    ORDER BY SUM(upvotes) DESC
  )
) AND
Questions.id IN (
  SELECT QuestionCategoryRelation.question_id FROM QuestionCategoryRelation
  WHERE QuestionCategoryRelation.category_id IN (
    SELECT category_id FROM UserCategoryRelation
    WHERE UserCategoryRelation.user_id = USER_ID_HERE
  )
);


/* Get the question with the most answers in the last day. This is the 
most "trending" question. */

SELECT * FROM Questions
WHERE question.id IN (
  SELECT agreggated.question_id FROM (
    SELECT Answers.question_id FROM Answers
    WHERE Answers.created >= sysdate-1/24
    GROUP BY Answers.question_id
    ORDER BY COUNT(*) DESC    
  ) agreggated
  WHERE ROWNUM <= 1
);


/* Get all the questions from users who are not blocked or muted by the user */

SELECT * FROM Questions
WHERE question.user_id NOT IN (
  SELECT UserRelations.target_user_id
  FROM UserRelations
  WHERE UserRelations.src_user_id = USER_ID_HERE AND
  UserRelations.status IN ('blocked', 'muted')
);

/* Get the number of followers for a question. */

SELECT COUNT(*) FROM QuestionFollows
WHERE question_id = QUESTION_ID_HERE;

/* Get the number of followers for a user. */

SELECT COUNT(*) FROM UserRelations
WHERE target_user_id = QUESTION_ID_HERE
AND status = 'following';

/* Get the most viewed questions */

SELECT * FROM Questions
ORDER BY views DESC;

/* Get all the answers of a question asked by a particular user. */

SELECT * FROM answers 
INNER JOIN questions.id = answers.question_id
WHERE answers.user_id = USER_ID_HERE;


/* Select all the questions asked by a user. */

SELECT COUNT(*) FROM Questions
WHERE user_id = USER_ID_HERE;

/* Select all the answers written by a user. */

SELECT COUNT(*) FROM Answers
WHERE user_id = USER_ID_HERE;


/* Get all messages between 2 users. */

SELECT * FROM Messages
WHERE user_id = USER_ID_HERE;
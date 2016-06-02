/* 
Users are the actual clients who use the site.  The email and username must
be unique to ensure login is possible.  The user's particular social logins
are stored in the twitter, facebook, etc. fields.  Profile photo is a VARCHAR
holding a base64 format image of the client's profile.  Password is most likely
going to be stored as a salted hash.  
*/

DROP TABLE "Users" CASCADE CONSTRAINTS;

CREATE TABLE "Users"(
	id INTEGER NOT NULL, 
	username VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL, 
	password VARCHAR(255) NOT NULL, 
	created DATE, 
	updated DATE,
	profile_photo VARCHAR(999), 
	twitter VARCHAR(255), 
	facebook VARCHAR(255), 
	linkedin VARCHAR(255), 
	tumblr VARCHAR(255), 
	wordpress VARCHAR(255), 
	google VARCHAR(255), 
	PRIMARY KEY (id), 
	UNIQUE (username), 
	UNIQUE (email)
);


/* 
Categories are the particular categories of "knowledge" users can know about or
follow, as well as the category of a question.
*/

DROP TABLE "Categories" CASCADE CONSTRAINTS;

CREATE TABLE "Categories" (
	id INTEGER NOT NULL, 
	title VARCHAR(255) NOT NULL, 
	about VARCHAR(255), 
	created DATE, 
	updated DATE, 
	PRIMARY KEY (id), 
	UNIQUE (title)
);


/* 
Responses is a "parent" table that contains shared information between answers
and comments.  Two following tables, "Questions" and "Comments" are related to 
this table with additional fields.  This makes mapping the tables to an Object
Oriented application easier.  It also makes querying all client created content
eaiser as the text of all comments and responses can be queried from this table.
*/

DROP TABLE "Responses" CASCADE CONSTRAINTS;

CREATE TABLE "Responses" (
	id INTEGER NOT NULL, 
	text VARCHAR(1000) NOT NULL, 
	upvotes INTEGER, 
	downvotes INTEGER, 
	user_id INTEGER NOT NULL, 
	created DATE, 
	updated DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE
);


/*
Questions are questions the user has asked on the site.  Every question was
asked by a user, hence the Foreign Key.  Questions can be "Drafts" and 
unpublished so the published field is for checking if a particular question is
published or not (0 is Unpublished and 1 is Published: simulating a Boolean).
The times_asked field is a count of how many times different users have asked
the question.  When asking an identical question the question is "merged" on 
Quora and not displayed as one of the latter asking clients questions.
*/

DROP TABLE "Questions" CASCADE CONSTRAINTS;

CREATE TABLE "Questions" (
	id INTEGER NOT NULL, 
	title VARCHAR(255) NOT NULL, 
	description VARCHAR(500) NOT NULL, 
	views INTEGER, 
	created DATE, 
	updated DATE, 
	user_id INTEGER NOT NULL, 
	published NUMBER(1), 
	times_asked VARCHAR(255), 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	CHECK (published IN (0, 1))
);

SELECT * FROM questions

/*
Settings are one to one with the users.  Most of these fields are "Boolean"
like fields that identify whether or not that user wants that setting on.  For 
thos fields T == 1 and F == 0.  There is also a "choice" like field for settings
that have a certain amount of limited choices.
*/

DROP TABLE "Settings" CASCADE CONSTRAINTS;


CREATE TABLE "Settings" (
	user_id INTEGER NOT NULL, 
	allow_search_indexing NUMBER(1), /* T/F: Allow the user to be found by search engines */
	allow_to_be_seen NUMBER(1),  /* T/F: Allow other users to see when the user is online */
	allow_adult_content NUMBER(1), /* T/F */
	recieve_msgs_from VARCHAR(255), /* Choice field (see check below) Who the user can recieve direct msgs from. */
	allow_anon_answer_reqs NUMBER(1), /* T/F Allow anonymous users to request user for answers */
	allow_comments NUMBER(1), /* T/F  Allow comments on this users questions. */
	PRIMARY KEY (user_id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	CHECK (allow_search_indexing IN (0, 1)), 
	CHECK (allow_to_be_seen IN (0, 1)), 
	CHECK (allow_adult_content IN (0, 1)), 
	CHECK (allow_anon_answer_reqs IN (0, 1)), 
	CHECK (allow_comments IN (0, 1)),
  CHECK (recieve_msgs_from IN ('followed', 'anyone', 'none'))
);

/*
Allows many-to-many relationship between users and the categories that they 
follow.
*/

DROP TABLE "CategoryFollows" CASCADE CONSTRAINTS;

CREATE TABLE "CategoryFollows" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	category_id INTEGER NOT NULL, 
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(category_id) REFERENCES "Categories" (id)
  ON DELETE CASCADE
);

/*
Messages are private direct messages between two users. 
*/

DROP TABLE "Messages" CASCADE CONSTRAINTS;

CREATE TABLE "Messages" (
	id INTEGER NOT NULL, 
	text VARCHAR(1000) NOT NULL, 
	src_user_id INTEGER NOT NULL, /* Primary key of the sending user. */
	target_user_id INTEGER NOT NULL,  /* Primary key of the receiving users. */
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(src_user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(target_user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE
);

/* 
Allows many-to-many relationship between users and the categories they are 
"knowlegable" about.
*/

DROP TABLE "UserCategoryRelation" CASCADE CONSTRAINTS;

CREATE TABLE "UserCategoryRelation" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	category_id INTEGER NOT NULL, 
	created DATE, 
	updated DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(category_id) REFERENCES "Categories" (id)
  ON DELETE CASCADE
);

/*
Users can follow, mute, or block other users on Quora.  This table allows that
many-to-many relationship.  The status of the relationship it held by the
status field that can contain one of the three values.  A user that is 
followed will obvisouly not be muted or blocked.  A user that is muted will
obviously not be followed or blocked.  A blocked user is obvisouly not followed
and muted.  Therefore, it makes sense to have one status field to minimize
the number of tuples.
*/

DROP TABLE "UserRelations" CASCADE CONSTRAINTS;

CREATE TABLE "UserRelations" (
	id INTEGER NOT NULL, 
	src_user_id INTEGER NOT NULL, 
	target_user_id INTEGER NOT NULL, 
	status VARCHAR(255) NOT NULL, 
	updated DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(src_user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(target_user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
  CHECK (status IN ('following', 'muted', 'blocked'))
);

/*
Allow many-to-many between questions and users to allow users to mark questions
to "come back to later."
*/

DROP TABLE "ReadingListItem" CASCADE CONSTRAINTS;

CREATE TABLE "ReadingListItem" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	question_id INTEGER NOT NULL, 
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(question_id) REFERENCES "Questions" (id)
  ON DELETE CASCADE
);


/*
Differenciate between responses that are answers and responses that are
comments are in response to other comments or answers while answers are 
in response to questions.
*/

DROP TABLE "Answers" CASCADE CONSTRAINTS;

CREATE TABLE "Answers" (
	id INTEGER NOT NULL, 
	response_id INTEGER, 
	question_id INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(response_id) REFERENCES "Responses" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(question_id) REFERENCES "Questions" (id)
  ON DELETE CASCADE
);


/*
Allow many-to-many relationship between users and quetions so that users
can have a list of "followed" questions and will receive "updates" when they
are updated or commented on.
*/

DROP TABLE "QuestionFollows" CASCADE CONSTRAINTS;

CREATE TABLE "QuestionFollows" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	question_id INTEGER NOT NULL, 
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(question_id) REFERENCES "Questions" (id)
  ON DELETE CASCADE
);

/*
Parent id is the primary key of a response.  By following the relationship
of the response to a comment or a question, whether the particular
comments is a comment on a comment or a question can be inferered.
*/

DROP TABLE "Comments" CASCADE CONSTRAINTS;

CREATE TABLE "Comments" (
	id INTEGER NOT NULL, 
	response_id INTEGER NOT NULL, 
	parent_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(response_id) REFERENCES "Responses" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(parent_id) REFERENCES "Responses" (id)
  ON DELETE CASCADE
);

/*
Allows many-to-many relationship between categories and questions to identify
the catgeories of a question.
*/

DROP TABLE "QuestionCategoryRelation" CASCADE CONSTRAINTS;

CREATE TABLE "QuestionCategoryRelation" (
	id INTEGER NOT NULL, 
	question_id INTEGER NOT NULL, 
	category_id INTEGER NOT NULL, 
	created DATE, 
	updated DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(question_id) REFERENCES "Questions" (id)
  ON DELETE CASCADE,
	FOREIGN KEY(category_id) REFERENCES "Categories" (id)
  ON DELETE CASCADE
);
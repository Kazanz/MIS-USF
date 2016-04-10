CREATE TABLE "Users" (
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


CREATE TABLE "Categories" (
	id INTEGER NOT NULL, 
	title VARCHAR(255) NOT NULL, 
	about VARCHAR(255), 
	created DATE, 
	updated DATE, 
	PRIMARY KEY (id), 
	UNIQUE (title)
);



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
);


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
	FOREIGN KEY(user_id) REFERENCES "Users" (id), 
	CHECK (published IN (0, 1))
);









CREATE TABLE "Settings" (
	user_id INTEGER NOT NULL, 
	allow_search_engines_to_index_name NUMBER(1), 
	allow_to_be_seen_when_online NUMBER(1), 
	allow_adult_content NUMBER(1), 
	recieve_msgs_from VARCHAR(255), 
	allow_anonymouse_answer_requests NUMBER(1), 
	allow_comments NUMBER(1), 
	PRIMARY KEY (user_id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id), 
	CHECK (allow_search_engines_to_index_name IN (0, 1)), 
	CHECK (allow_to_be_seen_when_online IN (0, 1)), 
	CHECK (allow_adult_content IN (0, 1)), 
	CHECK (allow_anonymouse_answer_requests IN (0, 1)), 
	CHECK (allow_comments IN (0, 1))
);


CREATE TABLE "CategoryFollows" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	category_id INTEGER NOT NULL, 
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id), 
	FOREIGN KEY(category_id) REFERENCES "Categories" (id)
);



CREATE TABLE "Messages" (
	id INTEGER NOT NULL, 
	text VARCHAR(1000) NOT NULL, 
	src_user_id INTEGER NOT NULL, 
	target_user_id INTEGER NOT NULL, 
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(src_user_id) REFERENCES "Users" (id), 
	FOREIGN KEY(target_user_id) REFERENCES "Users" (id)
);


CREATE TABLE "UserCategoryRelation" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	category_id INTEGER NOT NULL, 
	created DATE, 
	updated DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id), 
	FOREIGN KEY(category_id) REFERENCES "Categories" (id)
);





CREATE TABLE "UserRelations" (
	id INTEGER NOT NULL, 
	src_user_id INTEGER NOT NULL, 
	target_user_id INTEGER NOT NULL, 
	status VARCHAR(255) NOT NULL, 
	updated DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(src_user_id) REFERENCES "Users" (id), 
	FOREIGN KEY(target_user_id) REFERENCES "Users" (id)
);






CREATE TABLE "ReadingListItem" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	question_id INTEGER NOT NULL, 
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id), 
	FOREIGN KEY(question_id) REFERENCES "Questions" (id)
);





CREATE TABLE "Answers" (
	id INTEGER NOT NULL, 
	response_id INTEGER, 
	question_id INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(response_id) REFERENCES "Responses" (id), 
	FOREIGN KEY(question_id) REFERENCES "Questions" (id)
);





CREATE TABLE "QuestionFollows" (
	id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 
	question_id INTEGER NOT NULL, 
	created DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES "Users" (id), 
	FOREIGN KEY(question_id) REFERENCES "Questions" (id)
);


CREATE TABLE "Comments" (
	id INTEGER NOT NULL, 
	response_id INTEGER, 
	parent_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(response_id) REFERENCES "Responses" (id), 
	FOREIGN KEY(parent_id) REFERENCES "Responses" (id)
);



CREATE TABLE "QuestionCategoryRelation" (
	id INTEGER NOT NULL, 
	question_id INTEGER NOT NULL, 
	category_id INTEGER NOT NULL, 
	created DATE, 
	updated DATE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(question_id) REFERENCES "Questions" (id), 
	FOREIGN KEY(category_id) REFERENCES "Categories" (id)
);

from datetime import datetime

from sqlalchemy import *
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from sqlalchemy_utils.types.choice import ChoiceType
# from sqlalchemy.orm.session import sessionmaker

Base = declarative_base()

# engine = create_engine('oracle://db554:db5pass@131.247.223.52:1521/cdb9')

class User(Base):
    __tablename__ = "Users"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    username = Column(String(255), nullable=False, unique=True)
    email = Column(String(255), nullable=False, unique=True)
    password = Column(String, nullable=False)
    created = Column(DateTime, default=datetime.now())
    updated = Column(DateTime, default=datetime.now())
    profile_photo = Column(String(999))
    twitter = Column(Text(255))
    facebook = Column(Text(255))
    linkedin = Column(Text(255))
    tumblr = Column(Text(255))
    wordpress = Column(Text(255))
    google = Column(Text(255))


class Setting(Base):
    __tablename__ = "Settings"

    RECEIVE = [
        (u'followed', u'followed'),
        (u'anyone', u'anyone'),
        (u'none', u'none')
    ]

    user_id = Column(Integer(), ForeignKey(User.id), nullable=False, primary_key=True)
    allow_search_engines_to_index_name = Column(Boolean(), default=True)
    allow_to_be_seen_when_online = Column(Boolean(), default=True)
    allow_adult_content = Column(Boolean(), default=False)
    recieve_msgs_from = Column(ChoiceType(RECEIVE), default="followed")
    allow_anonymouse_answer_requests = Column(Boolean(), default=False)
    allow_comments = Column(Boolean(), default=True)


class Question(Base):
    __tablename__ = "Questions"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    title = Column(String(255), nullable=False)
    description = Column(String(500), nullable=False)
    views = Column(Integer(), default=0)
    created = Column(DateTime, default=datetime.now())
    updated = Column(DateTime, default=datetime.now())
    user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    published = Column(Boolean(), default=False)
    times_asked = Column(String(), default=1)


class Category(Base):
    __tablename__ = "Categories"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    title = Column(String(255), nullable=False, unique=True)
    about = Column(String())
    created = Column(DateTime, default=datetime.now())
    updated = Column(DateTime, default=datetime.now())


class Response(Base):
    __tablename__ = "Responses"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    text = Column(Text(), nullable=False)
    upvotes = Column(Integer(), default=0)
    downvotes = Column(Integer(), default=0)
    user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    created = Column(DateTime, default=datetime.now())
    updated = Column(DateTime, default=datetime.now())


class Answers(Base):
    __tablename__ = "Answers"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    response_id = Column(Integer(), ForeignKey(Response.id))
    question_id = Column(Integer(), ForeignKey(Question.id), nullable=False)

class Comment(Base):
    __tablename__ = "Comments"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    response_id = Column(Integer(), ForeignKey(Response.id))
    parent_id = Column(Integer(), ForeignKey(Response.id))


class UserRelation(Base):
    __tablename__ = "UserRelations"

    STATUS = [
        (u'following', u'following'),
        (u'mutes', u'muted'),
        (u'blocked', u'blocked')
    ]

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    src_user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    target_user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    status = Column(ChoiceType(STATUS), nullable=False)  # Explain this a little more in final report.
    updated = Column(DateTime, default=datetime.now())


class Message(Base):
    __tablename__ = "Messages"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    text = Column(Text(), nullable=False)
    src_user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    target_user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    created = Column(DateTime, default=datetime.now())


class QuestionFollows(Base):
    __tablename__ = "QuestionFollows"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    question_id = Column(Integer(), ForeignKey(Question.id), nullable=False)
    created = Column(DateTime, default=datetime.now())


class CategoryFollows(Base):
    __tablename__ = "CategoryFollows"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    category_id = Column(Integer(), ForeignKey(Category.id), nullable=False)
    created = Column(DateTime, default=datetime.now())


class ReadingListItem(Base):
    __tablename__ = "ReadingListItem"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    question_id = Column(Integer(), ForeignKey(Question.id), nullable=False)
    created = Column(DateTime, default=datetime.now())


class QuestionCategoryRelation(Base):
    __tablename__ = "QuestionCategoryRelation"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    question_id = Column(Integer(), ForeignKey(Question.id), nullable=False)
    category_id = Column(Integer(), ForeignKey(Category.id), nullable=False)
    created = Column(DateTime, default=datetime.now())
    updated = Column(DateTime, default=datetime.now())


class UserCategoryRelation(Base):
    __tablename__ = "UserCategoryRelation"

    id = Column(Integer(), Sequence('id_seq'), nullable=False, primary_key=True)
    user_id = Column(Integer(), ForeignKey(User.id), nullable=False)
    category_id = Column(Integer(), ForeignKey(Category.id), nullable=False)
    created = Column(DateTime, default=datetime.now())
    updated = Column(DateTime, default=datetime.now())


engine = create_engine('sqlite:///vitesse.db')
engine.echo = True  # To view the executed queries in the console.
try:
    Base.metadata.create_all(engine)
except:
    pass

# Use to do an autopopulate script if needed.
# DBSession = sessionmaker(bind=engine)
# session = DBSession()




"""
Importatnt queries:

Total views on answers all time, and this month.

Query to dissplay asnwers based on upvotes, downvotes, and comments.

Question for you.  Questions in a particular category that pertain to user based on average upvotes on answes and comments.

Most Trending - query all the upvotes on all the things in a question + all the comments and make that trending.

Most views writers in a category.
"""

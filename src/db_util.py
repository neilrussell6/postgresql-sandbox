#!/usr/bin/python
import time
import psycopg2
from psycopg2.extras import execute_values
from faker import Factory

import time_util

fake = Factory.create()

def connect():
  connection_str = "host='postgres' dbname='sandbox' user='sandbox' password='sandbox'"
  print("connecting to database")
  connection = psycopg2.connect(connection_str)
  print("connected\n")
  return connection.cursor()


def createTables(cursor):
  cursor.execute("""
    CREATE TABLE posts(
      id SERIAL PRIMARY KEY, 
      language text NOT NULL DEFAULT('english'), 
      title TEXT NOT NULL, 
      content TEXT NOT NULL
    )
  """)


def seedData(cursor, rows):
  start_time = time.time()

  # ... bad loop
  # posts_data = []
  # for i in range(rows):
  #   posts_data.append((fake.sentence(), fake.text()))

  # ... good loop
  posts_data = [ (fake.sentence(), fake.text()) for i in range(rows) ]

  # ... map
  # posts_data = map(lambda i: (fake.sentence(), fake.text()), range(rows))

  # seed posts data
  execute_values(cursor, "INSERT INTO posts (title, content) VALUES %s", posts_data)
  print("seeding %s rows of faker data\n... took %s seconds\n" % (rows, time_util.getTime(start_time, time.time())))


def updateData(cursor, data):

  print("updating with predictable data:")
  for item in data:
    print(item)
    cursor.execute("UPDATE posts SET title=%s, content=%s WHERE id=%s", item)
  print("\n")


def indexData(cursor, rows):
  start_time = time.time()

  cursor.execute("""
    CREATE MATERIALIZED VIEW search_index AS 
    SELECT posts.id, 
           posts.title,
           to_tsvector(posts.language::regconfig, posts.title) || 
           to_tsvector(posts.language::regconfig, posts.content) as document
    FROM posts;
    CREATE INDEX idx_fts_search ON search_index USING gin(document);
  """)

  print("indexing %s rows\n... took %s seconds\n" % (rows, time_util.getTime(start_time, time.time())))

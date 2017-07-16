#!/usr/bin/python
import time
import time_util

def query(cursor, query_str):
  start_time = time.time()

  cursor.execute("""
    SELECT id as post_id, title
    FROM search_index
    WHERE document @@ to_tsquery('english', %s);
  """, (query_str,))

  print("search took %s" % (time_util.getTime(start_time, time.time())))
  return cursor.fetchall()

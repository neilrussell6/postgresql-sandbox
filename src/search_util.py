#!/usr/bin/python
import time
import time_util
import pprint

def query(cursor, query_str):
  start_time = time.time()

  print("search query: '%s'" % query_str)
  cursor.execute("""
    SELECT id as post_id, title
    FROM search_index
    WHERE document @@ to_tsquery('english', %s);
  """, (query_str,))

  result = cursor.fetchall()
  output = "found %s match" if (len(result) == 1) else "found %s matches"
  print(output % len(result))
  pprint.pprint(result)
  print("... took %s seconds" % (time_util.getTime(start_time, time.time())))
  return result

#!/usr/bin/python
import time
import psycopg2
from psycopg2.extras import execute_values
import argparse
from functools import reduce
import pprint
from random import randint
from faker import Factory

import db_util
import search_util

fake = Factory.create()


# --------------------
# args
# --------------------

def parse_args():
  parser = argparse.ArgumentParser(description="Generates n rows of dummy data. And performs a full text search.")
  parser.add_argument("rows", nargs="+", help="number of rows to create")
  parser.add_argument("query", nargs="+", help="search query")
  return parser.parse_args()


# --------------------
# main
# --------------------

def main(args):
  cursor = db_util.connect()

  # create tables
  db_util.createTables(cursor)

  # seed data
  rows = reduce(lambda r, n: int(n), args.rows, 5)
  db_util.seedData(cursor, rows)

  # update with predictable data for searching
  update_data = [
    ("The Fox and the Dog", "The quick brown fox jumps over the lazy dog", randint(1, rows)),
    ("Foxy the Cat", "The small yellow cat was called foxy", randint(1, rows)),
    ("Dogs are always up to no good", "The slow grey dog jumped over the lazier cat", randint(1, rows)),
    ("Ducks don""t live in catteries", "Rumour has it ducks prefer a nice lake", randint(1, rows)),
    ("Ninja Turtles", "Turtles are not actually very well suited to learning ninjitsu, espeically when taught by a rat.", randint(1, rows))
  ]
  db_util.updateData(cursor, update_data)

  # index data
  db_util.indexData(cursor, rows)

  # cursor.execute("SELECT * FROM posts WHERE id>=760")
  # records = cursor.fetchall()
  # pprint.pprint(records)

  # search
  query_str = reduce(lambda r, n: n, args.query, "")
  result = search_util.query(cursor, query_str)
  print("found %s match" % len(result))
  pprint.pprint(result)


# --------------------
# init
# --------------------

if __name__ == "__main__":
  args = parse_args()
  main(args)

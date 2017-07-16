Postgres Sandbox
===

Postgres full text search
---

> Demos that a full text search of 1,000,000 records of indexed Postgres data, only takes around 0.0006 seconds.

#### Usasge

Running this command:

``docker-compose run web python src/seed-and-search.py 1000000 "dog"``

Results in output something like this:

```
connecting to database
connected

seeding 1000000 rows of faker data took 297.4872796535492

updating with predictable data:
("The Fox and the Dog", "The quick brown fox jumps over the lazy dog", 550779)
("Foxy the Cat", "The small yellow cat was called foxy", 899697)
("Dogs are always up to no good", "The slow grey dog jumped over the lazier cat", 759940)
("Ducks dont live in catteries", "Rumour has it ducks prefer a nice lake", 457329)
("Ninja Turtles", "Turtles are not actually very well suited to learning ninjitsu, espeically when taught by a rat.", 741252)


indexing 1000000 rows took 59.95078206062317

search took 0.0006098747253417969
found 2 match
[(550779, "The Fox and the Dog"), (759940, "Dogs are always up to no good")]
```

#### resources

 * [postgres-full-text-search-is-good-enough](http://rachbelaid.com/postgres-full-text-search-is-good-enough/)

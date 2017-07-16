-- create tables

CREATE TABLE author(
   id SERIAL PRIMARY KEY,
   name TEXT NOT NULL
);

CREATE TABLE posts(
   id SERIAL PRIMARY KEY,
   language text NOT NULL DEFAULT('english'),
   title TEXT NOT NULL,
   content TEXT NOT NULL,
   author_id INT NOT NULL references author(id)
);

CREATE TABLE tag(
   id SERIAL PRIMARY KEY,
   name TEXT NOT NULL
);

CREATE TABLE postss_tags(
   posts_id INT NOT NULL references posts(id),
   tag_id INT NOT NULL references tag(id)
 );

-- seed tables

INSERT INTO author (id, name)
VALUES (1, 'Pete Graham'),
       (2, 'Rachid Belaid'),
       (3, 'Robert Berry');

INSERT INTO tag (id, name)
VALUES (1, 'scifi'),
       (2, 'politics'),
       (3, 'science');

INSERT INTO posts (id, language, title, content, author_id)
VALUES (1, 'english', 'Endangered species',
        'Pandas are an endangered species', 1 ),
       (2, 'english', 'Freedom of Speech',
        'Freedom of speech is a necessary right', 2),
       (3, 'english', 'Star Wars vs Star Trek',
        'Few words from a big fan', 3);

INSERT INTO postss_tags (posts_id, tag_id)
VALUES (1, 3),
       (2, 2),
       (3, 1);

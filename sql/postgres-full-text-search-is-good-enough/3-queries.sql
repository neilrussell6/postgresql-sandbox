-- queries

-- ... incorrect (but works)
SELECT to_tsvector('If you can dream it, you can do it') @@ 'dream';

-- ... incorrect (fails)
SELECT to_tsvector('It''s kind of fun to do the impossible') @@ 'impossible';

-- ... correct
SELECT to_tsvector('It''s kind of fun to do the impossible') @@ to_tsquery('impossible');

-- ... difference demonstrated
SELECT 'dream'::tsquery, to_tsquery('dream');
SELECT 'impossible'::tsquery, to_tsquery('impossible');

-- more queries

SELECT to_tsvector('If the facts don''t fit the theory, change the facts') @@ to_tsquery('! fact');

SELECT to_tsvector('If the facts don''t fit the theory, change the facts') @@ to_tsquery('theory & !fact');

SELECT to_tsvector('If the facts don''t fit the theory, change the facts.') @@ to_tsquery('fiction | theory');

SELECT to_tsvector('If the facts don''t fit the theory, change the facts.') @@ to_tsquery('theo:*');

-- select data and query

SELECT pid, p_title
FROM (
  SELECT posts.id as pid,
         posts.title as p_title,
         to_tsvector(posts.title) ||
         to_tsvector(posts.content) ||
         to_tsvector(author.name) ||
         to_tsvector(coalesce(string_agg(tag.name, ' '))) as document
  FROM posts
  JOIN author ON author.id = posts.author_id
  JOIN postss_tags ON postss_tags.posts_id = postss_tags.tag_id
  JOIN tag ON tag.id = postss_tags.tag_id
  GROUP BY posts.id, author.id
) p_search
WHERE p_search.document @@ to_tsquery('Endangered & Species');

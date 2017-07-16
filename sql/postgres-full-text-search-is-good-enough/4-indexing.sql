CREATE INDEX idx_fts_posts ON posts
USING gin((setweight(to_tsvector(language::regconfig, title),'A') ||
       setweight(to_tsvector(language::regconfig, content), 'B')));

-- If this throws an IMMUTABLE error then you can use this workaround

CREATE OR REPLACE FUNCTION gin_fts_fct(title text, content text, language text)
  RETURNS tsvector
AS
$BODY$
    SELECT setweight(to_tsvector($3::regconfig, $1), 'A') || setweight(to_tsvector($3::regconfig, $1), 'B');
$BODY$
LANGUAGE sql
IMMUTABLE;

CREATE INDEX idx_fts_posts ON posts  USING gin(gin_fts_fct(title, content, language));

--
CREATE MATERIALIZED VIEW search_index AS
SELECT posts.id,
       posts.title,
       to_tsvector(posts.language::regconfig, posts.title) ||
       to_tsvector(posts.language::regconfig, posts.content) as document
FROM posts;
CREATE INDEX idx_fts_search ON search_index USING gin(document);

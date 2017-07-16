-- select data

SELECT posts.title,
       posts.content,
       author.name,
       coalesce((string_agg(tag.name, ' ')), '') as tag_name
FROM posts
JOIN author ON author.id = posts.author_id
JOIN postss_tags ON postss_tags.posts_id = postss_tags.tag_id
JOIN tag ON tag.id = postss_tags.tag_id
GROUP BY posts.id, author.id;

-- select data (as long string 'document')

SELECT posts.title || ' ' ||
       posts.content || ' ' ||
       author.name || ' ' ||
       coalesce((string_agg(tag.name, ' ')), '') as document
FROM posts
JOIN author ON author.id = posts.author_id
JOIN postss_tags ON postss_tags.posts_id = postss_tags.tag_id
JOIN tag ON tag.id = postss_tags.tag_id
GROUP BY posts.id, author.id;

-- select data (as an 'analyzed' 'document')

SELECT to_tsvector(posts.title) ||
       to_tsvector(posts.content) ||
       to_tsvector(author.name) ||
       to_tsvector(coalesce((string_agg(tag.name, ' ')), '')) as document
FROM posts
JOIN author ON author.id = posts.author_id
JOIN postss_tags ON postss_tags.posts_id = postss_tags.tag_id
JOIN tag ON tag.id = postss_tags.tag_id
GROUP BY posts.id, author.id;

-- to_tsvector examples

SELECT to_tsvector('Try not to become a man of success, but rather try to become a man of value');

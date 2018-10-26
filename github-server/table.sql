CREATE TABLE IF NOT EXISTS filechanges (
       sha1 varchar[50] primary key,
       filename varchar[256],
       additions int,
       deletions int
       
)

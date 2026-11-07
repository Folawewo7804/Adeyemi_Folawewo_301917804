-- A separate performance table using the case's result.score type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."result" AS
SELECT "score", 0::bigint AS "lab_row_id" FROM portfolio."result" WITH NO DATA;
INSERT INTO query_lab."result" ("score", "lab_row_id")
SELECT ((g % 1000)::numeric / 10), g FROM generate_series(1, 20000) AS g;
ANALYZE query_lab."result";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."result" USING btree ("score");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "score"
FROM query_lab."result"
WHERE "score" = ((42 % 1000)::numeric / 10)
ORDER BY "lab_row_id";

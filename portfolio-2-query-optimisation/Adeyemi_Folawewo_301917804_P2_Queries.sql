-- Show related registration, learner, offering, course, term records (up to 20).
SELECT t0."registration_id" AS "registration_registration_id",
       t0."registered_on" AS "registration_registered_on",
       t1."learner_id" AS "learner_learner_id",
       t1."cohort_code" AS "learner_cohort_code",
       t2."offering_id" AS "offering_offering_id",
       t2."section_code" AS "offering_section_code",
       t3."course_id" AS "course_course_id",
       t3."course_code" AS "course_course_code",
       t4."term_id" AS "term_term_id",
       t4."term_code" AS "term_term_code"
FROM portfolio."registration" t0
JOIN portfolio."learner" t1 ON t0."learner_id" = t1."learner_id"
JOIN portfolio."offering" t2 ON t0."offering_id" = t2."offering_id"
JOIN portfolio."course" t3 ON t2."course_id" = t3."course_id"
JOIN portfolio."term" t4 ON t2."term_id" = t4."term_id"
ORDER BY t0."registration_id", t1."learner_id", t2."offering_id", t3."course_id", t4."term_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."registration_id" AS "registration_registration_id",
       t0."registered_on" AS "registration_registered_on",
       t1."learner_id" AS "learner_learner_id",
       t1."cohort_code" AS "learner_cohort_code",
       t2."offering_id" AS "offering_offering_id",
       t2."section_code" AS "offering_section_code",
       t3."course_id" AS "course_course_id",
       t3."course_code" AS "course_course_code",
       t4."term_id" AS "term_term_id",
       t4."term_code" AS "term_term_code"
FROM portfolio."registration" t0
JOIN portfolio."learner" t1 ON t0."learner_id" = t1."learner_id"
JOIN portfolio."offering" t2 ON t0."offering_id" = t2."offering_id"
JOIN portfolio."course" t3 ON t2."course_id" = t3."course_id"
JOIN portfolio."term" t4 ON t2."term_id" = t4."term_id"
ORDER BY t0."registration_id", t1."learner_id", t2."offering_id", t3."course_id", t4."term_id"
LIMIT 20;

-- Find result records where score matches 91.5 (up to 20).
SELECT * FROM portfolio."result"
WHERE "score" IS NOT DISTINCT FROM 91.5
ORDER BY "result_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."result"
WHERE "score" IS NOT DISTINCT FROM 91.5
ORDER BY "result_id"
LIMIT 20;

-- Count result records for each registration_id (up to 20 groups).
SELECT "registration_id", count(*) AS record_count
FROM portfolio."result"
GROUP BY "registration_id"
ORDER BY record_count DESC, "registration_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "registration_id", count(*) AS record_count
FROM portfolio."result"
GROUP BY "registration_id"
ORDER BY record_count DESC, "registration_id" NULLS LAST
LIMIT 20;

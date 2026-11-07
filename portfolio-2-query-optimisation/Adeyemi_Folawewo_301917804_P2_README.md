# University / Student Result Portal — SQL queries

## 1. Show related registration, learner, offering, course, term records (up to 20).

```sql
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
```

| registration_registration_id | registration_registered_on | learner_learner_id | learner_cohort_code | offering_offering_id | offering_section_code | course_course_id | course_course_code | term_term_id | term_term_code |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 5001 | 2026-01-10 | 4001 | SYN-C1 | 3001 | A1 | 1001 | SYN101 | 2001 | SYN-2026-A |
| 5002 | 2026-01-11 | 4001 | SYN-C1 | 3001 | A1 | 1001 | SYN101 | 2001 | SYN-2026-A |

## 2. Find result records where score matches 91.5 (up to 20).

```sql
SELECT * FROM portfolio."result"
WHERE "score" IS NOT DISTINCT FROM 91.5
ORDER BY "result_id"
LIMIT 20;
```

| result_id | registration_id | score | result_state | recorded_at |
| --- | --- | --- | --- | --- |
| 6001 | 5001 | 91.5 | published | 2026-05-10T14:30:00+00:00 |

## 3. Count result records for each registration_id (up to 20 groups).

```sql
SELECT "registration_id", count(*) AS record_count
FROM portfolio."result"
GROUP BY "registration_id"
ORDER BY record_count DESC, "registration_id" NULLS LAST
LIMIT 20;
```

| registration_id | record_count |
| --- | --- |
| 5001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.594 | 1.594, 1.6, 1.588 | Sort → Seq Scan | 112 |
| After index | 0.171 | 0.18, 0.171, 0.169 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.594 ms to 0.171 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.57..1.571 rows=20 loops=1)
  Seq Scan on result (actual time=0.016..1.534 rows=20 loops=1)
Planning Time: 0.321 ms
Execution Time: 1.594 ms
```

### Before index, run 2

```text
Sort (actual time=1.575..1.576 rows=20 loops=1)
  Seq Scan on result (actual time=0.016..1.539 rows=20 loops=1)
Planning Time: 0.319 ms
Execution Time: 1.6 ms
```

### Before index, run 3

```text
Sort (actual time=1.563..1.564 rows=20 loops=1)
  Seq Scan on result (actual time=0.017..1.526 rows=20 loops=1)
Planning Time: 0.327 ms
Execution Time: 1.588 ms
```

### After index, run 1

```text
Sort (actual time=0.133..0.134 rows=20 loops=1)
  Bitmap Heap Scan on result (actual time=0.028..0.095 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.57 ms
Execution Time: 0.18 ms
```

### After index, run 2

```text
Sort (actual time=0.123..0.125 rows=20 loops=1)
  Bitmap Heap Scan on result (actual time=0.025..0.087 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.565 ms
Execution Time: 0.171 ms
```

### After index, run 3

```text
Sort (actual time=0.123..0.124 rows=20 loops=1)
  Bitmap Heap Scan on result (actual time=0.027..0.088 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.537 ms
Execution Time: 0.169 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Adeyemi_Folawewo_301917804_P2_Queries.sql, then Adeyemi_Folawewo_301917804_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Adeyemi_Folawewo_301917804_P2_QueryResults.png) · [Index comparison](screenshots/Adeyemi_Folawewo_301917804_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)


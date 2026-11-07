-- Fictional sample records for University / Student Result Portal.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits") VALUES (1001, 'SYN101', 'Synthetic Foundations', 3);
INSERT INTO portfolio."term" ("term_id", "term_code", "start_date", "end_date") VALUES (2001, 'SYN-2026-A', '2026-01-12', '2026-05-08');
INSERT INTO portfolio."learner" ("learner_id", "cohort_code", "entry_year") VALUES (4001, 'SYN-C1', 2026);
INSERT INTO portfolio."offering" ("offering_id", "course_id", "term_id", "section_code", "capacity") VALUES (3001, 1001, 2001, 'A1', 30);
INSERT INTO portfolio."registration" ("registration_id", "learner_id", "offering_id", "registered_on", "status") VALUES (5001, 4001, 3001, '2026-01-10', 'active');
INSERT INTO portfolio."registration" ("registration_id", "learner_id", "offering_id", "registered_on", "status") VALUES (5002, 4001, 3001, '2026-01-11', 'withdrawn');
INSERT INTO portfolio."result" ("result_id", "registration_id", "score", "result_state", "recorded_at") VALUES (6001, 5001, 91.5, 'published', '2026-05-10T14:30:00Z');
COMMIT;

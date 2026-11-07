-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject pk course. Expected: pk_course, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (1001, 'SYN102', 'Synthetic Inquiry', 4);

-- 2. reject uq course. Expected: uq_course_0, SQLSTATE 23505.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (1101, 'SYN101', 'Synthetic Alternate', 2);

-- 3. reject nn course title. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."course" ("course_id", "course_code", "title", "credits")
VALUES (1102, 'SYN103', NULL, 3);

-- 4. reject pk term. Expected: pk_term, SQLSTATE 23505.
INSERT INTO portfolio."term" ("term_id", "term_code", "start_date", "end_date")
VALUES (2001, 'SYN-2027-A', '2027-01-11', '2027-05-07');

-- 5. reject uq term. Expected: uq_term_0, SQLSTATE 23505.
INSERT INTO portfolio."term" ("term_id", "term_code", "start_date", "end_date")
VALUES (2101, 'SYN-2026-A', '2026-01-12', '2026-05-08');

-- 6. reject term dates. Expected: term_dates_ordered, SQLSTATE 23514.
INSERT INTO portfolio."term" ("term_id", "term_code", "start_date", "end_date")
VALUES (2102, 'SYN-2026-B', '2026-06-01', '2026-05-31');

-- 7. reject pk offering. Expected: pk_offering, SQLSTATE 23505.
INSERT INTO portfolio."offering" ("offering_id", "course_id", "term_id", "section_code", "capacity")
VALUES (3001, 1001, 2001, 'B1', 25);

-- 8. reject uq offering. Expected: uq_offering_0, SQLSTATE 23505.
INSERT INTO portfolio."offering" ("offering_id", "course_id", "term_id", "section_code", "capacity")
VALUES (3101, 1001, 2001, 'A1', 28);

-- 9. reject fk offering course. Expected: fk_offering_0, SQLSTATE 23503.
INSERT INTO portfolio."offering" ("offering_id", "course_id", "term_id", "section_code", "capacity")
VALUES (3102, 910001, 2001, 'C1', 20);

-- 10. reject fk offering term. Expected: fk_offering_1, SQLSTATE 23503.
INSERT INTO portfolio."offering" ("offering_id", "course_id", "term_id", "section_code", "capacity")
VALUES (3103, 1001, 920001, 'D1', 20);

-- 11. reject pk learner. Expected: pk_learner, SQLSTATE 23505.
INSERT INTO portfolio."learner" ("learner_id", "cohort_code", "entry_year")
VALUES (4001, 'SYN-C2', 2027);

-- 12. reject pk registration. Expected: pk_registration, SQLSTATE 23505.
INSERT INTO portfolio."registration" ("registration_id", "learner_id", "offering_id", "registered_on", "status")
VALUES (5001, 4001, 3001, '2026-01-12', 'withdrawn');

-- 13. reject fk registration learner. Expected: fk_registration_0, SQLSTATE 23503.
INSERT INTO portfolio."registration" ("registration_id", "learner_id", "offering_id", "registered_on", "status")
VALUES (5101, 930001, 3001, '2026-01-12', 'withdrawn');

-- 14. reject fk registration offering. Expected: fk_registration_1, SQLSTATE 23503.
INSERT INTO portfolio."registration" ("registration_id", "learner_id", "offering_id", "registered_on", "status")
VALUES (5102, 4001, 940001, '2026-01-12', 'withdrawn');

-- 15. reject registration status. Expected: registration_status_check, SQLSTATE 23514.
INSERT INTO portfolio."registration" ("registration_id", "learner_id", "offering_id", "registered_on", "status")
VALUES (5103, 4001, 3001, '2026-01-12', 'pending');

-- 16. reject active registration. Expected: one_active_registration, SQLSTATE 23505.
INSERT INTO portfolio."registration" ("registration_id", "learner_id", "offering_id", "registered_on", "status")
VALUES (5104, 4001, 3001, '2026-01-13', 'active');

-- 17. reject pk result. Expected: pk_result, SQLSTATE 23505.
INSERT INTO portfolio."result" ("result_id", "registration_id", "score", "result_state", "recorded_at")
VALUES (6001, 5002, 85, 'published', '2026-05-11T09:00:00Z');

-- 18. reject uq result. Expected: uq_result_0, SQLSTATE 23505.
INSERT INTO portfolio."result" ("result_id", "registration_id", "score", "result_state", "recorded_at")
VALUES (6101, 5001, 87, 'published', '2026-05-11T09:00:00Z');

-- 19. reject fk result. Expected: fk_result_0, SQLSTATE 23503.
INSERT INTO portfolio."result" ("result_id", "registration_id", "score", "result_state", "recorded_at")
VALUES (6102, 950001, 87, 'published', '2026-05-11T09:00:00Z');

-- 20. reject result score. Expected: result_score_range, SQLSTATE 23514.
INSERT INTO portfolio."result" ("result_id", "registration_id", "score", "result_state", "recorded_at")
VALUES (6103, 5002, 101, 'published', '2026-05-11T09:00:00Z');

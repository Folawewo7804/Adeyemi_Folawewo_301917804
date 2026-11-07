-- University / Student Result Portal: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."course" (
  "course_id" bigint NOT NULL,
  "course_code" text NOT NULL,
  "title" text NOT NULL,
  "credits" bigint NOT NULL,
  CONSTRAINT "pk_course" PRIMARY KEY ("course_id"),
  CONSTRAINT "uq_course_0" UNIQUE ("course_code")
);
CREATE TABLE portfolio."term" (
  "term_id" bigint NOT NULL,
  "term_code" text NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  CONSTRAINT "pk_term" PRIMARY KEY ("term_id"),
  CONSTRAINT "uq_term_0" UNIQUE ("term_code")
);
CREATE TABLE portfolio."offering" (
  "offering_id" bigint NOT NULL,
  "course_id" bigint NOT NULL,
  "term_id" bigint NOT NULL,
  "section_code" text NOT NULL,
  "capacity" bigint NOT NULL,
  CONSTRAINT "pk_offering" PRIMARY KEY ("offering_id"),
  CONSTRAINT "uq_offering_0" UNIQUE ("course_id", "term_id", "section_code")
);
CREATE TABLE portfolio."learner" (
  "learner_id" bigint NOT NULL,
  "cohort_code" text NOT NULL,
  "entry_year" bigint NOT NULL,
  CONSTRAINT "pk_learner" PRIMARY KEY ("learner_id")
);
CREATE TABLE portfolio."registration" (
  "registration_id" bigint NOT NULL,
  "learner_id" bigint NOT NULL,
  "offering_id" bigint NOT NULL,
  "registered_on" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_registration" PRIMARY KEY ("registration_id")
);
CREATE TABLE portfolio."result" (
  "result_id" bigint NOT NULL,
  "registration_id" bigint NOT NULL,
  "score" numeric(18,2) NOT NULL,
  "result_state" text NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  CONSTRAINT "pk_result" PRIMARY KEY ("result_id"),
  CONSTRAINT "uq_result_0" UNIQUE ("registration_id")
);
ALTER TABLE portfolio."offering" ADD CONSTRAINT "fk_offering_0" FOREIGN KEY ("course_id") REFERENCES portfolio."course" ("course_id");
ALTER TABLE portfolio."offering" ADD CONSTRAINT "fk_offering_1" FOREIGN KEY ("term_id") REFERENCES portfolio."term" ("term_id");
ALTER TABLE portfolio."registration" ADD CONSTRAINT "fk_registration_0" FOREIGN KEY ("learner_id") REFERENCES portfolio."learner" ("learner_id");
ALTER TABLE portfolio."registration" ADD CONSTRAINT "fk_registration_1" FOREIGN KEY ("offering_id") REFERENCES portfolio."offering" ("offering_id");
ALTER TABLE portfolio."result" ADD CONSTRAINT "fk_result_0" FOREIGN KEY ("registration_id") REFERENCES portfolio."registration" ("registration_id");
ALTER TABLE portfolio."term" ADD CONSTRAINT "term_dates_ordered" CHECK ("end_date" > "start_date");
ALTER TABLE portfolio."registration" ADD CONSTRAINT "registration_status_check" CHECK (("status" = 'active') OR ("status" = 'withdrawn') OR ("status" = 'completed'));
CREATE UNIQUE INDEX "one_active_registration" ON portfolio."registration" ("learner_id", "offering_id") WHERE ("status" = 'active');
ALTER TABLE portfolio."result" ADD CONSTRAINT "result_score_range" CHECK (("score" >= 0) AND ("score" <= 100));
COMMIT;

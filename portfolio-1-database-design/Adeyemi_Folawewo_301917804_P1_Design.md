# University / Student Result Portal — database design

My case study records course, term, offering, learner, registration, result.

## Users

- Learners reviewing their registrations and results
- Academic staff managing offerings and recording results

## Main operations

- Register a learner in a course offering and record its final result.
- Review results by course, term, or score range.
- Benchmark plan: create 20000 synthetic result rows, compare the same score-range filter with and without a B-tree index on result.score, and verify both plans return equivalent rows.

## Entities

| Entity | Information stored |
| --- | --- |
| course | Catalog of courses that may be offered in a term. |
| term | Academic term with a code and date range. |
| offering | A specific section of a course scheduled in a term. |
| learner | Minimal synthetic learner record without names or real-world identifiers. |
| registration | A learner's registration in one course offering and the root of the normalization example. |
| result | The optional final score and publication state for a registration. |

## course

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| course_id | BIGINT | PK | Yes |
| course_code | TEXT | Unique | Yes |
| title | TEXT |  | Yes |
| credits | INTEGER |  | Yes |
- Unique key: (course_code).

## term

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| term_id | BIGINT | PK | Yes |
| term_code | TEXT | Unique | Yes |
| start_date | DATE |  | Yes |
| end_date | DATE |  | Yes |
- Unique key: (term_code).

## offering

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| offering_id | BIGINT | PK | Yes |
| course_id | BIGINT | FK | Yes |
| term_id | BIGINT | FK | Yes |
| section_code | TEXT |  | Yes |
| capacity | INTEGER |  | Yes |
- course_id → course.course_id
- term_id → term.term_id
- Unique key: (course_id, term_id, section_code).

## learner

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| learner_id | BIGINT | PK | Yes |
| cohort_code | TEXT |  | Yes |
| entry_year | INTEGER |  | Yes |


## registration

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| registration_id | BIGINT | PK | Yes |
| learner_id | BIGINT | FK | Yes |
| offering_id | BIGINT | FK | Yes |
| registered_on | DATE |  | Yes |
| status | TEXT |  | Yes |
- learner_id → learner.learner_id
- offering_id → offering.offering_id

## result

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| result_id | BIGINT | PK | Yes |
| registration_id | BIGINT | FK, Unique | Yes |
| score | NUMERIC(18,2) |  | Yes |
| result_state | TEXT |  | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
- registration_id → registration.registration_id
- Unique key: (registration_id).

## Relationships and business rules

- Each course has a distinct course code.
- A term's end date must not precede its start date.
- The offering.course_id foreign key references course.course_id.
- The offering.term_id foreign key references term.term_id.
- A course can have only one section with a given section code in a given term.
- The registration.learner_id foreign key references learner.learner_id.
- The registration.offering_id foreign key references offering.offering_id.
- Registration status is limited to active, withdrawn, or completed.
- For each learner and offering pair, at most one registration may have active status; withdrawn or completed registrations do not occupy this partial unique key.
- The result.registration_id foreign key references registration.registration_id.
- Each registration has at most one final result.
- A final score must be between 0 and 100 inclusive.

## Assumptions

- All keys and sample values are synthetic opaque values; no real learner names or identifiers are stored.
- Each entity has a globally unique, single-column primary key.
- A course offering belongs to exactly one course and one term.
- A learner may have at most one active registration in a particular offering.
- Each registration has at most one final result, and a final score is between 0 and 100 inclusive.
- A term's end date is on or after its start date.


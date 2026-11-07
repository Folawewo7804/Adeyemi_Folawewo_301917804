# University / Student Result Portal — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| learner_id | registration records (list) |
| --- | --- |
| 4001 | [5001,5002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| registration.registration_id | registration.learner_id | registration.offering_id | registration.status | learner.learner_id | learner.cohort_code | offering.offering_id | offering.course_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5001 | 4001 | 3001 | active | 4001 | SYN-C1 | 3001 | 1001 |
| 5002 | 4001 | 3001 | withdrawn | 4001 | SYN-C1 | 3001 | 1001 |

Key: registration_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## registration_example

| registration.registration_id | registration.learner_id | registration.offering_id | registration.status | learner.learner_id | learner.cohort_code | offering.offering_id | offering.course_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5001 | 4001 | 3001 | active | 4001 | SYN-C1 | 3001 | 1001 |
| 5002 | 4001 | 3001 | withdrawn | 4001 | SYN-C1 | 3001 | 1001 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## course

| course_id | course_code | title | credits |
| --- | --- | --- | --- |
| 1001 | SYN101 | Synthetic Foundations | 3 |

## term

| term_id | term_code | start_date | end_date |
| --- | --- | --- | --- |
| 2001 | SYN-2026-A | 2026-01-12 | 2026-05-08 |

## offering

| offering_id | course_id | term_id | section_code | capacity |
| --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | A1 | 30 |

## learner

| learner_id | cohort_code | entry_year |
| --- | --- | --- |
| 4001 | SYN-C1 | 2026 |

## registration

| registration_id | learner_id | offering_id | registered_on | status |
| --- | --- | --- | --- | --- |
| 5001 | 4001 | 3001 | 2026-01-10 | active |
| 5002 | 4001 | 3001 | 2026-01-11 | withdrawn |

## result

| result_id | registration_id | score | result_state | recorded_at |
| --- | --- | --- | --- | --- |
| 6001 | 5001 | 91.5 | published | 2026-05-10T14:30:00+00:00 |

## Dependencies

- course: (course_id) → course_code, title, credits
- term: (term_id) → term_code, start_date, end_date
- offering: (offering_id) → course_id, term_id, section_code, capacity
- learner: (learner_id) → cohort_code, entry_year
- registration: (registration_id) → learner_id, offering_id, registered_on, status
- result: (result_id) → registration_id, score, result_state, recorded_at

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.

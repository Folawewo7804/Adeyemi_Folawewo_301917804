# University / Student Result Portal — ER diagram

```mermaid
erDiagram
    direction LR
    course {
        bigint course_id PK
        text course_code UK
        text title
        integer credits
    }
    term {
        bigint term_id PK
        text term_code UK
        date start_date
        date end_date
    }
    offering {
        bigint offering_id PK
        bigint course_id FK
        bigint term_id FK
        text section_code
        integer capacity
    }
    learner {
        bigint learner_id PK
        text cohort_code
        integer entry_year
    }
    registration {
        bigint registration_id PK
        bigint learner_id FK
        bigint offering_id FK
        date registered_on
        text status
    }
    result {
        bigint result_id PK
        bigint registration_id FK,UK
        numeric score
        text result_state
        timestamptz recorded_at
    }
    course ||--o{ offering : "course_id"
    term ||--o{ offering : "term_id"
    learner ||--o{ registration : "learner_id"
    offering ||--o{ registration : "offering_id"
    registration ||--o| result : "registration_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Adeyemi_Folawewo_301917804_ERDiagram.png)

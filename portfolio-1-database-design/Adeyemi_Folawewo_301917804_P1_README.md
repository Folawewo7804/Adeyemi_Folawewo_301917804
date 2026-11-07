# Portfolio 1 — Database Design and Modelling

I organised the data into course, term, offering, learner, registration, result. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| course | 1 |
| term | 1 |
| offering | 1 |
| learner | 1 |
| registration | 2 |
| result | 1 |

The 20 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Adeyemi_Folawewo_301917804_P1_Design.md)
- [ER diagram](Adeyemi_Folawewo_301917804_P1_ERDiagram.md)
- [Normalisation](Adeyemi_Folawewo_301917804_P1_Normalisation.md)
- [Schema](Adeyemi_Folawewo_301917804_P1_Schema.sql)
- [Sample data](Adeyemi_Folawewo_301917804_P1_SampleData.sql)
- [Constraint tests](Adeyemi_Folawewo_301917804_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Adeyemi_Folawewo_301917804_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)


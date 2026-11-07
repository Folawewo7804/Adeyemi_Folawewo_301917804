// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("result_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("result_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "score_recorded",
                    "result_published"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "result"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "result_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("result_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "score_recorded",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "result",
            "key": {
                "result_id": 6001
            },
            "snapshot": {
                "result_id": 6001,
                "registration_id": 5001,
                "score": 91.5,
                "result_state": "published",
                "recorded_at": "2026-05-10T14:30:00Z"
            }
        },
        "embedded": {
            "registration": [
                {
                    "key": {
                        "registration_id": 5001
                    },
                    "snapshot": {
                        "registration_id": 5001,
                        "learner_id": 4001,
                        "offering_id": 3001,
                        "registered_on": "2026-01-10",
                        "status": "active"
                    },
                    "via": [
                        "result.registration_id → registration"
                    ]
                }
            ],
            "offering": [
                {
                    "key": {
                        "offering_id": 3001
                    },
                    "snapshot": {
                        "offering_id": 3001,
                        "course_id": 1001,
                        "term_id": 2001,
                        "section_code": "A1",
                        "capacity": 30
                    },
                    "via": [
                        "result.registration_id → registration.offering_id → offering"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "result_published",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "result",
            "key": {
                "result_id": 6001
            },
            "snapshot": {
                "result_id": 6001,
                "registration_id": 5001,
                "score": 91.5,
                "result_state": "published",
                "recorded_at": "2026-05-10T14:30:00Z"
            }
        },
        "embedded": {
            "registration": [
                {
                    "key": {
                        "registration_id": 5001
                    },
                    "snapshot": {
                        "registration_id": 5001,
                        "learner_id": 4001,
                        "offering_id": 3001,
                        "registered_on": "2026-01-10",
                        "status": "active"
                    },
                    "via": [
                        "result.registration_id → registration"
                    ]
                }
            ],
            "offering": [
                {
                    "key": {
                        "offering_id": 3001
                    },
                    "snapshot": {
                        "offering_id": 3001,
                        "course_id": 1001,
                        "term_id": 2001,
                        "section_code": "A1",
                        "capacity": 30
                    },
                    "via": [
                        "result.registration_id → registration.offering_id → offering"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "reason_code": "illustrative reason_code",
                "source_channel": "illustrative source_channel",
                "revision_note": "illustrative revision_note"
            }
        }
    }
]));
  await db.getCollection("result_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("result_events").find({"eventType":"score_recorded"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("result_events").find({"source.key.result_id":6001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("result_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("result_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("result_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "score_recorded",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "result",
        "key": {
            "result_id": 6001
        },
        "snapshot": {
            "result_id": 6001,
            "registration_id": 5001,
            "score": 91.5,
            "result_state": "published",
            "recorded_at": "2026-05-10T14:30:00Z"
        }
    },
    "embedded": {
        "registration": [
            {
                "key": {
                    "registration_id": 5001
                },
                "snapshot": {
                    "registration_id": 5001,
                    "learner_id": 4001,
                    "offering_id": 3001,
                    "registered_on": "2026-01-10",
                    "status": "active"
                },
                "via": [
                    "result.registration_id → registration"
                ]
            }
        ],
        "offering": [
            {
                "key": {
                    "offering_id": 3001
                },
                "snapshot": {
                    "offering_id": 3001,
                    "course_id": 1001,
                    "term_id": 2001,
                    "section_code": "A1",
                    "capacity": 30
                },
                "via": [
                    "result.registration_id → registration.offering_id → offering"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("result_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "score_recorded",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "result",
        "key": {
            "result_id": 6001
        },
        "snapshot": {
            "result_id": 6001,
            "registration_id": 5001,
            "score": 91.5,
            "result_state": "published",
            "recorded_at": "2026-05-10T14:30:00Z"
        }
    },
    "embedded": {
        "registration": [
            {
                "key": {
                    "registration_id": 5001
                },
                "snapshot": {
                    "registration_id": 5001,
                    "learner_id": 4001,
                    "offering_id": 3001,
                    "registered_on": "2026-01-10",
                    "status": "active"
                },
                "via": [
                    "result.registration_id → registration"
                ]
            }
        ],
        "offering": [
            {
                "key": {
                    "offering_id": 3001
                },
                "snapshot": {
                    "offering_id": 3001,
                    "course_id": 1001,
                    "term_id": 2001,
                    "section_code": "A1",
                    "capacity": 30
                },
                "via": [
                    "result.registration_id → registration.offering_id → offering"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("result_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });

-- =============================================================
-- CRM Sample Data Seed for DenchClaw / DuckDB
-- Run AFTER seed-schema.sql
-- =============================================================

BEGIN;

-- =============================================================
-- CONTACTS
-- =============================================================

-- Helper: insert a contact entry and its fields
-- Pattern: INSERT entry with fixed id, then insert fields referencing that id

-- Contact 1: John Smith
INSERT INTO entries (id, object_id)
SELECT 'cnt_johnsmith_001', o.id FROM objects o WHERE o.name = 'contact'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_johnsmith_001', f.id, 'John Smith'       FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='full_name'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_johnsmith_001', f.id, 'john@acme.com'    FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='email_address'  ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_johnsmith_001', f.id, 'Acme Corp'        FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='company'        ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_johnsmith_001', f.id, '+1-555-0101'      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='phone_number'   ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_johnsmith_001', f.id, '2026-03-08'       FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='last_contacted' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Contact 2: Maria Garcia
INSERT INTO entries (id, object_id)
SELECT 'cnt_mariagarcia_002', o.id FROM objects o WHERE o.name = 'contact'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_mariagarcia_002', f.id, 'Maria Garcia'     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='full_name'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_mariagarcia_002', f.id, 'maria@globex.com' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='email_address'  ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_mariagarcia_002', f.id, 'Globex'           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='company'        ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_mariagarcia_002', f.id, '+1-555-0202'      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='phone_number'   ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_mariagarcia_002', f.id, '2026-03-05'       FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='last_contacted' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Contact 3: James Wilson
INSERT INTO entries (id, object_id)
SELECT 'cnt_jameswilson_003', o.id FROM objects o WHERE o.name = 'contact'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_jameswilson_003', f.id, 'James Wilson'      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='full_name'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_jameswilson_003', f.id, 'james@initech.com' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='email_address'  ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_jameswilson_003', f.id, 'Initech'           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='company'        ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_jameswilson_003', f.id, '2026-02-20'        FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='last_contacted' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Contact 4: Sarah Chen
INSERT INTO entries (id, object_id)
SELECT 'cnt_sarahchen_004', o.id FROM objects o WHERE o.name = 'contact'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_sarahchen_004', f.id, 'Sarah Chen'          FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='full_name'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_sarahchen_004', f.id, 'sarah@techflow.io'   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='email_address'  ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_sarahchen_004', f.id, 'TechFlow'            FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='company'        ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_sarahchen_004', f.id, '2026-03-10'          FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='last_contacted' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Contact 5: Michael Brown
INSERT INTO entries (id, object_id)
SELECT 'cnt_michaelbrown_005', o.id FROM objects o WHERE o.name = 'contact'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_michaelbrown_005', f.id, 'Michael Brown'      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='full_name'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_michaelbrown_005', f.id, 'michael@stark.com'  FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='email_address'  ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_michaelbrown_005', f.id, 'Stark Industries'   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='company'        ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_michaelbrown_005', f.id, '+1-555-0505'        FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='phone_number'   ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_michaelbrown_005', f.id, '2026-03-01'         FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='last_contacted' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Contact 6: Emma Davis
INSERT INTO entries (id, object_id)
SELECT 'cnt_emmadavis_006', o.id FROM objects o WHERE o.name = 'contact'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_emmadavis_006', f.id, 'Emma Davis'          FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='full_name'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_emmadavis_006', f.id, 'emma@wayne.com'      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='email_address'  ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_emmadavis_006', f.id, 'Wayne Enterprises'   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='company'        ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'cnt_emmadavis_006', f.id, '2026-02-28'          FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='contact' AND f.name='last_contacted' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- =============================================================
-- DEALS
-- =============================================================

-- Deal 1: Acme Corp Enterprise Plan
INSERT INTO entries (id, object_id)
SELECT 'deal_acme_001', o.id FROM objects o WHERE o.name = 'deal'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_acme_001', f.id, 'Acme Corp Enterprise Plan' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='deal_name'       ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_acme_001', f.id, 'Acme Corp'                 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='company'         ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_acme_001', f.id, '15000'                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='amount'          ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_acme_001', f.id, 'Negotiation'               FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='stage'           ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_acme_001', f.id, '2026-03-31'                FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='close_date'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_acme_001', f.id, 'John Smith'                FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='primary_contact' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Deal 2: Globex Annual Contract
INSERT INTO entries (id, object_id)
SELECT 'deal_globex_002', o.id FROM objects o WHERE o.name = 'deal'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_globex_002', f.id, 'Globex Annual Contract' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='deal_name'       ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_globex_002', f.id, 'Globex'                 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='company'         ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_globex_002', f.id, '8500'                   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='amount'          ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_globex_002', f.id, 'Proposal'               FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='stage'           ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_globex_002', f.id, '2026-04-15'             FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='close_date'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_globex_002', f.id, 'Maria Garcia'           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='primary_contact' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Deal 3: Initech Cloud Migration
INSERT INTO entries (id, object_id)
SELECT 'deal_initech_003', o.id FROM objects o WHERE o.name = 'deal'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_initech_003', f.id, 'Initech Cloud Migration' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='deal_name'       ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_initech_003', f.id, 'Initech'                 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='company'         ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_initech_003', f.id, '45000'                   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='amount'          ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_initech_003', f.id, 'Discovery'               FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='stage'           ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_initech_003', f.id, '2026-05-30'              FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='close_date'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_initech_003', f.id, 'James Wilson'            FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='primary_contact' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Deal 4: TechFlow Integration (Closed Won)
INSERT INTO entries (id, object_id)
SELECT 'deal_techflow_004', o.id FROM objects o WHERE o.name = 'deal'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_techflow_004', f.id, 'TechFlow Integration' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='deal_name'       ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_techflow_004', f.id, 'TechFlow'             FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='company'         ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_techflow_004', f.id, '12000'                FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='amount'          ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_techflow_004', f.id, 'Closed Won'           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='stage'           ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_techflow_004', f.id, '2026-03-01'           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='close_date'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_techflow_004', f.id, 'Sarah Chen'           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='primary_contact' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Deal 5: Stark Industries AI Suite
INSERT INTO entries (id, object_id)
SELECT 'deal_stark_005', o.id FROM objects o WHERE o.name = 'deal'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_stark_005', f.id, 'Stark Industries AI Suite' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='deal_name'       ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_stark_005', f.id, 'Stark Industries'          FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='company'         ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_stark_005', f.id, '75000'                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='amount'          ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_stark_005', f.id, 'Negotiation'               FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='stage'           ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_stark_005', f.id, '2026-04-30'                FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='close_date'      ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'deal_stark_005', f.id, 'Michael Brown'             FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='deal' AND f.name='primary_contact' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- =============================================================
-- ACTIVITIES
-- =============================================================

-- Activity 1: Call with John Smith
INSERT INTO entries (id, object_id)
SELECT 'act_001', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_001', f.id, 'John Smith'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_001', f.id, 'Call'                                           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_001', f.id, '2026-03-08'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_001', f.id, 'Discussed pricing for the enterprise plan. John is ready to sign pending legal review.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes'   ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_001', f.id, 'Acme Corp Enterprise Plan'                      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='deal'    ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Activity 2: Meeting with Maria Garcia
INSERT INTO entries (id, object_id)
SELECT 'act_002', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_002', f.id, 'Maria Garcia'                                   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_002', f.id, 'Meeting'                                        FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_002', f.id, '2026-03-05'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_002', f.id, 'Presented the annual contract proposal. Maria requested a 10% discount. Following up next week.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_002', f.id, 'Globex Annual Contract'                         FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='deal'    ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Activity 3: Email to James Wilson
INSERT INTO entries (id, object_id)
SELECT 'act_003', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_003', f.id, 'James Wilson'                                   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_003', f.id, 'Email'                                          FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_003', f.id, '2026-02-20'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_003', f.id, 'Sent cloud migration overview deck. James will share with the IT team and respond within 2 weeks.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_003', f.id, 'Initech Cloud Migration'                        FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='deal'    ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Activity 4: Call with Sarah Chen
INSERT INTO entries (id, object_id)
SELECT 'act_004', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_004', f.id, 'Sarah Chen'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_004', f.id, 'Call'                                           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_004', f.id, '2026-03-10'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_004', f.id, 'Closed deal! Contract signed. Onboarding call scheduled for next Monday.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_004', f.id, 'TechFlow Integration'                           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='deal'    ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Activity 5: Meeting with Michael Brown
INSERT INTO entries (id, object_id)
SELECT 'act_005', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_005', f.id, 'Michael Brown'                                  FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_005', f.id, 'Meeting'                                        FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_005', f.id, '2026-03-01'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_005', f.id, 'Presented AI Suite capabilities. Michael is impressed but needs board approval for $75k spend. Reconvene in 2 weeks.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_005', f.id, 'Stark Industries AI Suite'                      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='deal'    ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Activity 6: Note about Emma Davis
INSERT INTO entries (id, object_id)
SELECT 'act_006', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_006', f.id, 'Emma Davis'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_006', f.id, 'Note'                                           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_006', f.id, '2026-02-28'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_006', f.id, 'Inbound inquiry from Wayne Enterprises about process automation. Schedule discovery call.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes' ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Activity 7: Email follow-up to John Smith
INSERT INTO entries (id, object_id)
SELECT 'act_007', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_007', f.id, 'John Smith'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_007', f.id, 'Email'                                          FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_007', f.id, '2026-03-03'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_007', f.id, 'Sent revised contract with legal-friendly terms. Awaiting response.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_007', f.id, 'Acme Corp Enterprise Plan'                      FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='deal'    ON CONFLICT (entry_id, field_id) DO NOTHING;

-- Activity 8: Call with Maria Garcia
INSERT INTO entries (id, object_id)
SELECT 'act_008', o.id FROM objects o WHERE o.name = 'activity'
ON CONFLICT (id) DO NOTHING;

INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_008', f.id, 'Maria Garcia'                                   FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='contact' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_008', f.id, 'Call'                                           FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='type'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_008', f.id, '2026-02-28'                                     FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='date'    ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_008', f.id, 'Discussed discount options. Agreed to 7% off. Sending updated proposal tomorrow.' FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='notes' ON CONFLICT (entry_id, field_id) DO NOTHING;
INSERT INTO entry_fields (id, entry_id, field_id, value)
SELECT nanoid32(), 'act_008', f.id, 'Globex Annual Contract'                         FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name='activity' AND f.name='deal'    ON CONFLICT (entry_id, field_id) DO NOTHING;

COMMIT;

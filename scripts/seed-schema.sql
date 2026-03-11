-- =============================================================
-- CRM Schema Seed for DenchClaw / DuckDB
-- Creates objects, fields, enum values, and PIVOT views
-- =============================================================

BEGIN;

-- ------------------------------------------------------------
-- nanoid32 macro (generates 32-char nanoid-style IDs)
-- ------------------------------------------------------------
CREATE MACRO IF NOT EXISTS nanoid32() AS (
  lower(
    hex(
      hash(
        random()::VARCHAR || epoch_ms(now())::VARCHAR
      )
    )
  )
);

-- ------------------------------------------------------------
-- Core tables (DenchClaw EAV pattern)
-- These are created by DenchClaw on first run; use IF NOT EXISTS
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS objects (
  id          VARCHAR PRIMARY KEY DEFAULT nanoid32(),
  name        VARCHAR NOT NULL UNIQUE,
  label       VARCHAR NOT NULL,
  description VARCHAR,
  created_at  TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fields (
  id          VARCHAR PRIMARY KEY DEFAULT nanoid32(),
  object_id   VARCHAR NOT NULL REFERENCES objects(id),
  name        VARCHAR NOT NULL,
  label       VARCHAR NOT NULL,
  type        VARCHAR NOT NULL,
  required    BOOLEAN DEFAULT false,
  sort_order  INTEGER DEFAULT 0,
  created_at  TIMESTAMP DEFAULT now(),
  UNIQUE (object_id, name)
);

CREATE TABLE IF NOT EXISTS enum_values (
  id        VARCHAR PRIMARY KEY DEFAULT nanoid32(),
  field_id  VARCHAR NOT NULL REFERENCES fields(id),
  value     VARCHAR NOT NULL,
  label     VARCHAR NOT NULL,
  color     VARCHAR,
  sort_order INTEGER DEFAULT 0,
  UNIQUE (field_id, value)
);

CREATE TABLE IF NOT EXISTS entries (
  id         VARCHAR PRIMARY KEY DEFAULT nanoid32(),
  object_id  VARCHAR NOT NULL REFERENCES objects(id),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS entry_fields (
  id        VARCHAR PRIMARY KEY DEFAULT nanoid32(),
  entry_id  VARCHAR NOT NULL REFERENCES entries(id),
  field_id  VARCHAR NOT NULL REFERENCES fields(id),
  value     VARCHAR,
  created_at TIMESTAMP DEFAULT now(),
  UNIQUE (entry_id, field_id)
);

-- =============================================================
-- OBJECT: contact
-- =============================================================
INSERT INTO objects (id, name, label, description)
VALUES (nanoid32(), 'contact', 'Contact', 'A person in the CRM')
ON CONFLICT (name) DO NOTHING;

-- Fields for contact
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'full_name',      'Full Name',      'text',     true,  1 FROM objects o WHERE o.name = 'contact' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'email_address',  'Email Address',  'email',    true,  2 FROM objects o WHERE o.name = 'contact' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'company',        'Company',        'text',     false, 3 FROM objects o WHERE o.name = 'contact' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'phone_number',   'Phone Number',   'phone',    false, 4 FROM objects o WHERE o.name = 'contact' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'last_contacted', 'Last Contacted', 'date',     false, 5 FROM objects o WHERE o.name = 'contact' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'notes',          'Notes',          'richtext', false, 6 FROM objects o WHERE o.name = 'contact' ON CONFLICT (object_id, name) DO NOTHING;

-- =============================================================
-- OBJECT: deal
-- =============================================================
INSERT INTO objects (id, name, label, description)
VALUES (nanoid32(), 'deal', 'Deal', 'A sales opportunity')
ON CONFLICT (name) DO NOTHING;

-- Fields for deal
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'deal_name',       'Deal Name',       'text',     true,  1 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'company',         'Company',         'text',     true,  2 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'amount',          'Amount',          'number',   true,  3 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'stage',           'Stage',           'enum',     false, 4 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'close_date',      'Close Date',      'date',     false, 5 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'primary_contact', 'Primary Contact', 'text',     false, 6 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'assigned_to',     'Assigned To',     'text',     false, 7 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'notes',           'Notes',           'richtext', false, 8 FROM objects o WHERE o.name = 'deal' ON CONFLICT (object_id, name) DO NOTHING;

-- Enum values for deal.stage
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Discovery',   'Discovery',   '#3b82f6', 1 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'deal' AND f.name = 'stage' ON CONFLICT (field_id, value) DO NOTHING;
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Proposal',    'Proposal',    '#6c63ff', 2 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'deal' AND f.name = 'stage' ON CONFLICT (field_id, value) DO NOTHING;
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Negotiation', 'Negotiation', '#f59e0b', 3 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'deal' AND f.name = 'stage' ON CONFLICT (field_id, value) DO NOTHING;
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Closed Won',  'Closed Won',  '#22c55e', 4 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'deal' AND f.name = 'stage' ON CONFLICT (field_id, value) DO NOTHING;
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Closed Lost', 'Closed Lost', '#ef4444', 5 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'deal' AND f.name = 'stage' ON CONFLICT (field_id, value) DO NOTHING;

-- =============================================================
-- OBJECT: activity
-- =============================================================
INSERT INTO objects (id, name, label, description)
VALUES (nanoid32(), 'activity', 'Activity', 'A logged sales activity')
ON CONFLICT (name) DO NOTHING;

-- Fields for activity
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'contact', 'Contact', 'text',     true,  1 FROM objects o WHERE o.name = 'activity' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'type',    'Type',    'enum',     false, 2 FROM objects o WHERE o.name = 'activity' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'date',    'Date',    'date',     true,  3 FROM objects o WHERE o.name = 'activity' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'notes',   'Notes',   'richtext', false, 4 FROM objects o WHERE o.name = 'activity' ON CONFLICT (object_id, name) DO NOTHING;
INSERT INTO fields (id, object_id, name, label, type, required, sort_order)
SELECT nanoid32(), o.id, 'deal',    'Deal',    'text',     false, 5 FROM objects o WHERE o.name = 'activity' ON CONFLICT (object_id, name) DO NOTHING;

-- Enum values for activity.type
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Call',    'Call',    '#3b82f6', 1 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'activity' AND f.name = 'type' ON CONFLICT (field_id, value) DO NOTHING;
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Meeting', 'Meeting', '#6c63ff', 2 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'activity' AND f.name = 'type' ON CONFLICT (field_id, value) DO NOTHING;
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Email',   'Email',   '#f59e0b', 3 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'activity' AND f.name = 'type' ON CONFLICT (field_id, value) DO NOTHING;
INSERT INTO enum_values (id, field_id, value, label, color, sort_order)
SELECT nanoid32(), f.id, 'Note',    'Note',    '#6b7280', 4 FROM fields f JOIN objects o ON f.object_id = o.id WHERE o.name = 'activity' AND f.name = 'type' ON CONFLICT (field_id, value) DO NOTHING;

COMMIT;

-- =============================================================
-- PIVOT VIEW: v_contact
-- =============================================================
CREATE OR REPLACE VIEW v_contact AS
SELECT
  e.id,
  e.created_at,
  e.updated_at,
  MAX(CASE WHEN f.name = 'full_name'      THEN ef.value END) AS "Full Name",
  MAX(CASE WHEN f.name = 'email_address'  THEN ef.value END) AS "Email Address",
  MAX(CASE WHEN f.name = 'company'        THEN ef.value END) AS "Company",
  MAX(CASE WHEN f.name = 'phone_number'   THEN ef.value END) AS "Phone Number",
  MAX(CASE WHEN f.name = 'last_contacted' THEN ef.value END) AS "Last Contacted",
  MAX(CASE WHEN f.name = 'notes'          THEN ef.value END) AS "Notes"
FROM entries e
JOIN objects o ON e.object_id = o.id AND o.name = 'contact'
LEFT JOIN entry_fields ef ON ef.entry_id = e.id
LEFT JOIN fields f ON f.id = ef.field_id
GROUP BY e.id, e.created_at, e.updated_at;

-- =============================================================
-- PIVOT VIEW: v_deal
-- =============================================================
CREATE OR REPLACE VIEW v_deal AS
SELECT
  e.id,
  e.created_at,
  e.updated_at,
  MAX(CASE WHEN f.name = 'deal_name'       THEN ef.value END) AS "Deal Name",
  MAX(CASE WHEN f.name = 'company'         THEN ef.value END) AS "Company",
  MAX(CASE WHEN f.name = 'amount'          THEN ef.value END) AS "Amount",
  MAX(CASE WHEN f.name = 'stage'           THEN ef.value END) AS "Stage",
  MAX(CASE WHEN f.name = 'close_date'      THEN ef.value END) AS "Close Date",
  MAX(CASE WHEN f.name = 'primary_contact' THEN ef.value END) AS "Primary Contact",
  MAX(CASE WHEN f.name = 'assigned_to'     THEN ef.value END) AS "Assigned To",
  MAX(CASE WHEN f.name = 'notes'           THEN ef.value END) AS "Notes"
FROM entries e
JOIN objects o ON e.object_id = o.id AND o.name = 'deal'
LEFT JOIN entry_fields ef ON ef.entry_id = e.id
LEFT JOIN fields f ON f.id = ef.field_id
GROUP BY e.id, e.created_at, e.updated_at;

-- =============================================================
-- PIVOT VIEW: v_activity
-- =============================================================
CREATE OR REPLACE VIEW v_activity AS
SELECT
  e.id,
  e.created_at,
  e.updated_at,
  MAX(CASE WHEN f.name = 'contact' THEN ef.value END) AS "Contact",
  MAX(CASE WHEN f.name = 'type'    THEN ef.value END) AS "Type",
  MAX(CASE WHEN f.name = 'date'    THEN ef.value END) AS "Date",
  MAX(CASE WHEN f.name = 'notes'   THEN ef.value END) AS "Notes",
  MAX(CASE WHEN f.name = 'deal'    THEN ef.value END) AS "Deal"
FROM entries e
JOIN objects o ON e.object_id = o.id AND o.name = 'activity'
LEFT JOIN entry_fields ef ON ef.entry_id = e.id
LEFT JOIN fields f ON f.id = ef.field_id
GROUP BY e.id, e.created_at, e.updated_at;

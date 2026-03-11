# Tools & Capabilities

## CRM Tools

Atlas has access to DenchClaw's built-in CRM skill. Available operations:

### crm_create
Create a new entry for a CRM object.

**Usage:**
- `crm_create contact` — create a new contact
- `crm_create deal` — create a new deal
- `crm_create activity` — log an activity

### crm_search
Search entries for a given object.

**Usage:**
- `crm_search contact name:"Maria"` — find contacts by name
- `crm_search deal stage:"Negotiation"` — filter deals by stage
- `crm_search activity contact:"John Smith"` — find activities for a contact

### crm_update
Update an existing entry by ID or name.

### crm_delete
Delete an entry by ID.

### crm_query
Run a raw SQL query against the DuckDB database.

**Available views:**
- `v_contact` — flat view of all contacts with their field values
- `v_deal` — flat view of all deals
- `v_activity` — flat view of all activities

**Example queries:**
```sql
-- All deals above $10k
SELECT * FROM v_deal WHERE "Amount"::NUMERIC > 10000

-- Contacts not contacted in 7+ days
SELECT * FROM v_contact WHERE "Last Contacted"::DATE < current_date - INTERVAL '7 days'

-- Pipeline summary by stage
SELECT "Stage", COUNT(*) as count, SUM("Amount"::NUMERIC) as total
FROM v_deal GROUP BY "Stage"
```

## Database

- **Type**: DuckDB (embedded)
- **Location**: `workspace/workspace.duckdb`
- **Pattern**: EAV (Entity-Attribute-Value) with PIVOT views for querying

## Dashboard App

The CRM Dashboard Dench App is available in the apps panel. It provides:
- Live contact table
- Deals kanban board
- Activity timeline
- Pipeline insights

Users can reference the dashboard for visual confirmation of data changes.

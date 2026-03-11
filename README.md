# Agent CRM

> **Talk to your CRM instead of clicking forms.**

AI Agent CRM MVP built on [DenchClaw](https://github.com/denchclaw/denchclaw) — a fully working demo that shows an AI agent creating contacts, managing deals, logging activities, and generating pipeline insights through natural language.

---

## Architecture

```
You (Chat)
   │
   ▼
DenchClaw Agent (Atlas)
   │  Natural language → tool calls
   ▼
DenchClaw CRM Skill
   │  EAV object store
   ▼
DuckDB (workspace/workspace.duckdb)
   │  PIVOT views: v_contact, v_deal, v_activity
   ▼
CRM Dashboard App (Dench App)
   │  Queries via window.dench.db.query()
   ▼
Browser UI
```

**Key components:**

| Component | Description |
|---|---|
| `workspace/` | DenchClaw workspace root with agent persona files |
| `workspace/apps/crm-dashboard/` | Custom Dench App — live CRM dashboard |
| `workspace/reports/pipeline.report.json` | Pre-built pipeline analytics report |
| `scripts/seed-schema.sql` | DuckDB schema (objects, fields, views) |
| `scripts/seed-data.sql` | Sample contacts, deals, activities |
| `scripts/setup.sh` | One-command setup script |

---

## Prerequisites

- **Node.js >= 22** ([download](https://nodejs.org/))
- **OpenAI API key** ([get one](https://platform.openai.com/api-keys))
- **DuckDB CLI** (optional — only for manual schema inspection)

---

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/Sergio-Al/agent-crm.git
cd agent-crm

# 2. Set your OpenAI API key
cp .env.example .env
# Edit .env and set OPENAI_API_KEY=sk-...

# 3. Run setup (installs denchclaw, seeds the database)
npm run setup

# 4. Start the agent
npm run dev
```

Open the chat in your browser. Try:

```
Add a contact John from Acme, email john@acme.com
```

---

## How It Works

### DenchClaw Workspace

The `workspace/` directory is a DenchClaw workspace. When you run `npm run dev`, DenchClaw reads:

- `AGENTS.md` — what the agent knows and can do
- `SOUL.md` — the agent's personality
- `IDENTITY.md` — the agent is "Atlas"
- `USER.md` — context about you (the sales user)

### CRM Skill

DenchClaw includes a built-in CRM skill that uses DuckDB with an EAV (Entity-Attribute-Value) pattern. The `seed-schema.sql` creates:

- **Objects**: `contact`, `deal`, `activity`
- **PIVOT views**: `v_contact`, `v_deal`, `v_activity` — flat, queryable views
- **Enum fields**: Deal stages, activity types

### Dench App (CRM Dashboard)

The `workspace/apps/crm-dashboard/` app is a static HTML/CSS/JS dashboard that loads inside DenchClaw's app panel. It queries DuckDB directly via the Bridge API (`window.dench.db.query()`).

Views:
- **Dashboard** — stats cards, recent activity, deals at risk
- **Contacts** — searchable table
- **Deals** — kanban-style pipeline board
- **Activities** — chronological activity feed

---

## Demo Script Summary

| Step | Prompt | What it shows |
|---|---|---|
| 1 | `Add contact John from Acme, email john@acme.com` | AI creates a contact |
| 2 | `Create a $15,000 deal with Acme, stage Negotiation` | AI creates a deal |
| 3 | `Log a call with John about pricing` | AI logs an activity |
| 4 | `Show me all deals above $10k` | AI queries the CRM |
| 5 | `Which deals are at risk?` | AI generates insights |
| 6 | `Who should I follow up with today?` | AI suggests follow-ups |
| 7 | `Write a follow-up email for the Acme deal` | AI drafts an email |
| 8 | *(Open CRM Dashboard app)* | Live data in the UI |
| 9 | *(Open Pipeline Report)* | Pre-built analytics |

See [`docs/demo-script.md`](docs/demo-script.md) for the full guide with expected responses.

---

## Screenshots

*Coming soon — run the demo and add your screenshots here.*

---

## Tech Stack

| Layer | Technology |
|---|---|
| Agent framework | [DenchClaw](https://github.com/denchclaw/denchclaw) |
| LLM | OpenAI GPT-4.1 |
| Database | DuckDB (embedded, via DenchClaw) |
| Dashboard UI | Vanilla HTML/CSS/JS (Dench App) |
| Data pattern | EAV (Entity-Attribute-Value) |

---

## License

MIT


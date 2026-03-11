# Migration Options: Integrating an AI CRM Agent into an Existing App

Three approaches for adding AI agent capabilities to an existing Vue + NestJS application, ranging from minimal effort to full ownership.

---

## Approach 1: OpenClaw as a Sidecar (Least Effort)

Keep OpenClaw running alongside your Vue+NestJS app. Connect them via OpenClaw's WebSocket Gateway or DuckDB's external database support.

### Architecture

```
┌─────────────────────────┐     ┌──────────────────────────┐
│  Your existing app       │     │  OpenClaw (sidecar)       │
│                          │     │                           │
│  Vue frontend            │     │  Agent + Chat UI          │
│    │                     │     │    │                      │
│  NestJS API              │     │  Gateway (WS :19001)      │
│    │                     │     │    │                      │
│  PostgreSQL / MySQL      │◄────│  DuckDB or MCP bridge     │
│                          │     │                           │
└─────────────────────────┘     └──────────────────────────┘
```

### What you'd build

- An **MCP server** in NestJS that exposes your existing CRUD endpoints as tools the OpenClaw agent can call
- Or use DuckDB's `ATTACH` to connect to your PostgreSQL/MySQL directly:
  ```sql
  INSTALL postgres;
  LOAD postgres;
  ATTACH 'postgresql://user:pass@localhost/mydb' AS mydb (TYPE postgres);
  SELECT * FROM mydb.contacts;
  ```

### Pros

- Minimal code — agent capabilities for free
- Existing app untouched
- Full OpenClaw feature set (chat UI, skill system, reports)

### Cons

- Two separate runtimes and UIs
- Data sync complexity if not using DuckDB ATTACH
- Users must interact with OpenClaw's UI for chat (separate from your app)

### Best for

Quick demos, PoCs, internal tools where a separate chat interface is acceptable.

---

## Approach 2: Embed the Agent in NestJS (No OpenClaw)

Build the agent layer directly into your NestJS backend. Full control, no external dependencies.

### Architecture

```
┌──────────────────────────────────────────┐
│  Your Vue + NestJS app                    │
│                                           │
│  Vue frontend                             │
│  ├── Existing pages                       │
│  ├── ChatPanel.vue (new)                  │
│  └── CRM Dashboard (existing or new)     │
│           │                               │
│  NestJS backend                           │
│  ├── Existing modules/controllers         │
│  ├── AgentModule (new)                    │
│  │   ├── AgentService (LLM + tools)       │
│  │   ├── AgentGateway (WebSocket)         │
│  │   └── tools/                           │
│  │       ├── contacts.tool.ts             │
│  │       ├── deals.tool.ts                │
│  │       └── activities.tool.ts           │
│  └── Existing DB modules                  │
│           │                               │
│  PostgreSQL / MySQL (your existing DB)    │
└──────────────────────────────────────────┘
```

### What you'd build

#### Backend (NestJS)

| Component | What it does | Libraries |
|---|---|---|
| **AgentService** (~150-200 lines) | Manages LLM conversations, tool calling loop, message history | `openai` SDK or `@langchain/core` |
| **AgentGateway** (~50-100 lines) | WebSocket endpoint for real-time chat | `@nestjs/websockets`, `socket.io` |
| **Tool definitions** (~50 lines each) | Functions the LLM can call (create contact, query deals, etc.) | OpenAI function calling format |
| **System prompt builder** | Loads persona/skill context, injects CRM instructions | Custom (reads markdown or config files) |
| **Conversation store** | Persists chat history per user/session | Your existing DB or Redis |

#### Frontend (Vue)

| Component | What it does |
|---|---|
| **ChatPanel.vue** (~200 lines) | Chat UI with message list, input, streaming responses |
| **ChatService** | WebSocket client connecting to NestJS AgentGateway |
| Existing CRM views | Already built — your Vue pages for contacts, deals, etc. |

#### AgentService core loop

This is the heart of what OpenClaw does internally — the tool-calling loop:

```
User message
  → Build messages array (system prompt + history + user message)
  → Call LLM (OpenAI chat completions with tools)
  → If LLM returns tool_calls:
      → Execute each tool (your NestJS service methods)
      → Append tool results to messages
      → Call LLM again (loop until no more tool_calls)
  → Return final assistant message
```

#### Tool definition example

Instead of a 3000-line SKILL.md teaching the agent raw SQL, you define typed tool functions that wrap your existing services:

```typescript
const tools = [
  {
    type: 'function',
    function: {
      name: 'create_contact',
      description: 'Create a new CRM contact',
      parameters: {
        type: 'object',
        properties: {
          fullName: { type: 'string' },
          email: { type: 'string' },
          company: { type: 'string' },
        },
        required: ['fullName', 'email'],
      },
    },
  },
];

// Tool executor maps to your existing NestJS services:
async executeTool(name: string, args: any) {
  switch (name) {
    case 'create_contact':
      return this.contactsService.create(args);
    case 'search_deals':
      return this.dealsService.findAll(args.filters);
  }
}
```

### What you DON'T need to replicate from OpenClaw

| OpenClaw feature | Skip? | Why |
|---|---|---|
| DuckDB + EAV pattern | Yes | You already have a database with a proper schema |
| SKILL.md (3000 lines) | Yes | Your tools call typed service methods, not raw SQL |
| `.object.yaml` / triple alignment | Yes | That's OpenClaw's UI framework, not yours |
| `.dench.app` system | Yes | Your Vue app IS the frontend |
| Bridge API (`window.dench.db.query`) | Yes | Your Vue components use your API/store |
| Gateway (WebSocket orchestration) | Partial | You build a simpler one in NestJS |
| Persona files (SOUL.md, etc.) | Optional | Nice to keep as system prompt templates |

### Estimated effort

~500-800 lines of new code total:
- AgentService: ~150-200 lines
- AgentGateway: ~50-100 lines
- Tool definitions: ~50 lines per CRM object
- ChatPanel.vue: ~200 lines
- System prompt: ~50-100 lines

### Pros

- Full control — no external runtime dependency
- Uses your real database directly
- Single deployment, single UI
- Type-safe tool definitions
- Fits into your existing auth, middleware, logging

### Cons

- More upfront work than sidecar
- You maintain the agent loop (error handling, retries, streaming)
- No built-in report/chart system — build or use a Vue chart library

### Best for

Production features in existing applications where you need full control and a unified UX.

---

## Approach 3: Hybrid — OpenClaw Agent + Your API via MCP

Use OpenClaw for the agent intelligence, but have it call your NestJS API through an MCP (Model Context Protocol) server.

### Architecture

```
┌────────────────────────────────┐
│  Vue frontend                  │
│  ├── Your existing UI          │
│  └── Chat (embedded OpenClaw   │
│       iframe or WS client)     │
│           │                    │
│  NestJS backend                │
│  ├── Existing REST API         │
│  ├── MCP Server (new)          │ ◄── OpenClaw connects here
│  │   ├── contacts tools        │
│  │   ├── deals tools           │
│  │   └── activities tools      │
│  └── PostgreSQL                │
│                                │
│  OpenClaw (agent brain only)   │
│  └── Gateway :19001 ──────────►│ calls MCP tools
└────────────────────────────────┘
```

### What you'd build

- An **MCP server module** in NestJS (~200-300 lines) that wraps your existing services as MCP tools
- Chat integration in Vue — embed OpenClaw's WebSocket connection or iframe its chat UI

### Pros

- Best of both — OpenClaw handles the complex agent loop, your app owns the data
- MCP is a standard protocol — swappable agent backends in the future
- Less code than building the full agent loop yourself

### Cons

- Still runs OpenClaw as a dependency (separate process)
- MCP protocol adds a layer of indirection
- Chat UI integration requires WebSocket bridging or iframe embedding

### Best for

When you want agent intelligence without rebuilding the LLM tool-calling loop, and your app needs to remain the source of truth for data.

---

## Comparison

| Factor | Approach 1 (Sidecar) | Approach 2 (Embedded) | Approach 3 (Hybrid MCP) |
|---|---|---|---|
| **Effort** | Low | Medium | Medium-Low |
| **New code** | ~50-100 lines | ~500-800 lines | ~200-300 lines |
| **External dependency** | OpenClaw runtime | None (just `openai` SDK) | OpenClaw runtime |
| **Database** | DuckDB (+ ATTACH) | Your existing DB | Your existing DB |
| **UI** | Separate (OpenClaw) | Unified (your Vue app) | Hybrid (embedded chat) |
| **Control** | Low | Full | Medium |
| **Production-ready** | Demo/internal | Yes | Yes (with monitoring) |
| **Auth integration** | Separate | Your existing auth | Bridged |

## Recommendation

| Scenario | Best approach |
|---|---|
| Quick demo / PoC | **Approach 1** — hook OpenClaw to your DB via ATTACH or MCP |
| Production feature in existing app | **Approach 2** — full control, single deployment, no external dependency |
| Want agent smarts without rebuilding the LLM loop | **Approach 3** — OpenClaw handles AI, your app handles data |

# Demo Script — AI Agent CRM

**Audience**: Investors, potential customers, developers
**Duration**: ~10–15 minutes
**Goal**: Show that an AI agent can manage CRM data through natural language

---

## Setup

Before the demo:
1. Run `npm run setup` and `npm run dev`
2. Open the CRM Dashboard app in the apps panel
3. Have the chat interface visible
4. Ensure sample data is seeded (so the dashboard isn't empty)

---

## Step 1: Introduction

**Say:**
> "Traditional CRMs make you click through forms to log every call, update every deal, and build every report. What if you could just *talk* to your CRM?"

Open the chat. Type:

```
Hi Atlas, what can you help me with?
```

**Expected response:**
> "Hi! I'm Atlas, your AI CRM assistant. I can help you:
> - Add contacts and deals
> - Log calls, meetings, and emails
> - Query your pipeline
> - Generate insights and follow-up suggestions
>
> What would you like to do?"

**Talking point:** This is not a chatbot. Atlas has direct access to a real database and can read and write CRM data.

---

## Step 2: Create a Contact

**Type:**
```
Add a contact John from Acme Corp, email john@acme.com, phone 555-0101
```

**Expected response:**
> ✅ Contact created: **John Smith** (Acme Corp) — john@acme.com
> Want me to create a deal for Acme Corp too?

**Action:** Switch to the Contacts tab in the CRM Dashboard. John now appears in the table.

**Talking point:** One sentence created a complete contact record. The dashboard updates live.

---

## Step 3: Create a Deal

**Type:**
```
Create a $15,000 deal with Acme Corp, stage Negotiation, close date March 31
```

**Expected response:**
> ✅ Deal created: **Acme Corp Enterprise Plan** — $15,000 · Negotiation · closes Mar 31
> Shall I assign this to John Smith as the primary contact?

**Type:**
```
Yes, assign it to John
```

**Expected response:**
> ✅ Updated: John Smith set as primary contact on the Acme Corp Enterprise Plan deal.

**Action:** Switch to the Deals tab. The deal card appears in the Negotiation column of the kanban board.

**Talking point:** The AI understood context ("assign it to John") from the previous message. No form, no dropdowns.

---

## Step 4: Log an Activity

**Type:**
```
Log a call with John about pricing for the Acme deal
```

**Expected response:**
> ✅ Activity logged:
> - **Contact**: John Smith
> - **Type**: Call
> - **Date**: Today
> - **Deal**: Acme Corp Enterprise Plan
>
> Add any notes from the call?

**Type:**
```
He's ready to sign pending legal review
```

**Expected response:**
> ✅ Notes added: "Ready to sign pending legal review."

**Action:** Switch to Activities. The call appears at the top of the feed.

---

## Step 5: Query the CRM

**Type:**
```
Show me all deals above $10k
```

**Expected response:**
> Here are your deals above $10,000:
>
> | Deal | Company | Amount | Stage |
> |---|---|---|---|
> | Acme Corp Enterprise Plan | Acme Corp | $15,000 | Negotiation |
> | Initech Cloud Migration | Initech | $45,000 | Discovery |
> | Stark Industries AI Suite | Stark Industries | $75,000 | Negotiation |
> | TechFlow Integration | TechFlow | $12,000 | Closed Won |
>
> Total: $147,000

**Talking point:** Natural language → SQL query → formatted response. No report builder needed.

---

## Step 6: Generate Insights

**Type:**
```
Which deals are at risk?
```

**Expected response:**
> ⚠️ Here are deals that may need attention:
>
> **Initech Cloud Migration** ($45,000 · Discovery)
> — Last activity was 19 days ago. James Wilson hasn't been contacted recently.
>
> **Globex Annual Contract** ($8,500 · Proposal)
> — Still in Proposal stage. Follow up on the discount request from March 5th.
>
> Want me to draft follow-up messages for these?

**Talking point:** The AI is doing proactive analysis — not just answering queries. It's checking dates, comparing stages, and reasoning about risk.

---

## Step 7: Follow-up Suggestions

**Type:**
```
Who should I follow up with today?
```

**Expected response:**
> Based on your pipeline, I'd prioritize these today:
>
> 1. 🔴 **James Wilson** (Initech) — no contact in 19 days, $45k deal in Discovery
> 2. 🟡 **Maria Garcia** (Globex) — promised updated proposal after March 5 call
> 3. 🟡 **Michael Brown** (Stark Industries) — board review meeting coming up, good time to check in
>
> Want me to draft outreach emails for any of these?

**Talking point:** This is what a great SDR does manually every morning. The AI does it in seconds.

---

## Step 8: Email Generation

**Type:**
```
Write a follow-up email for the Acme Corp deal
```

**Expected response:**
> Here's a follow-up email for John Smith:
>
> ---
> **Subject**: Following up — Acme Corp Enterprise Plan
>
> Hi John,
>
> Thanks for the productive call last week. I wanted to follow up on the legal review — please let me know if you need anything from our side to keep things moving.
>
> We're excited to get Acme Corp onboarded. Looking forward to your update.
>
> Best,
> [Your name]
>
> ---
> Want me to adjust the tone or add specific details?

**Talking point:** The AI used context from the activity log ("legal review") to write a relevant, personalized email — not a generic template.

---

## Step 9: Open the CRM Dashboard

**Say:**
> "Now let's look at the visual dashboard."

Click the CRM Dashboard app in the apps panel.

**Walk through:**
- **Dashboard tab**: Stats cards (6 contacts, 5 deals, $155,500 pipeline value), recent activity feed, open deals list
- **Contacts tab**: Table with all 6 contacts, searchable
- **Deals tab**: Kanban board showing all 5 deals in their respective stages
- **Activities tab**: Chronological log of all 8 activities

**Talking point:** Every action we took in the chat is reflected here in real time. The dashboard is just a view on top of the same DuckDB database the AI writes to.

---

## Step 10: Show Pipeline Report

**Say:**
> "DenchClaw also has built-in reporting."

Open the Pipeline Report from the reports panel (or mention it's pre-built at `workspace/reports/pipeline.report.json`).

**Walk through:**
- **Deals by Stage** (funnel chart): Discovery → Proposal → Negotiation funnel
- **Revenue by Stage** (bar chart): Negotiation stage has highest value
- **Deals Over Time** (area chart): Growth trend

**Talking point:** No BI tool, no export to Excel. The report runs live SQL queries against the same database.

---

## Closing

**Say:**
> "What you just saw:
> - 6 contacts, 5 deals, 8 activities — created and queried in under 5 minutes
> - Zero form fills
> - AI that reasons about your pipeline, not just retrieves data
> - A full dashboard and reporting layer included
>
> This is Agent CRM — built on DenchClaw."

**Call to action options:**
- "Try it yourself: `git clone` + `npm run setup`"
- "What would your team ask the CRM every day?"

---

## Backup Prompts (Q&A)

If the audience asks questions, use these prompts to demonstrate:

```
What's my total pipeline value?
How many deals are in Negotiation?
Show me all contacts from Stark Industries
Update the Globex deal stage to Negotiation
What did we last talk about with Maria Garcia?
Create a deal with Wayne Enterprises for $30,000, Discovery stage
```

/* insights.js — Dashboard home: stat cards, recent activity, deals at risk */

async function renderInsights() {
  const container = document.getElementById('view-insights');
  container.innerHTML = `<div class="loading"><div class="spinner"></div> Loading dashboard…</div>`;

  let contacts = [];
  let deals = [];
  let activities = [];

  try {
    if (window.dench && window.dench.db) {
      [contacts, deals, activities] = await Promise.all([
        window.dench.db.query(`SELECT "Full Name", "Company", "Last Contacted" FROM v_contact`),
        window.dench.db.query(`SELECT "Deal Name", "Company", "Amount", "Stage" FROM v_deal`),
        window.dench.db.query(`SELECT "Contact", "Type", "Date", "Notes", "Deal" FROM v_activity ORDER BY "Date" DESC LIMIT 5`),
      ]);
    }
  } catch (e) {
    console.warn('[CRM] insights query failed:', e);
  }

  // Compute stats
  const totalContacts = contacts.length;
  const totalDeals = deals.length;
  const pipelineValue = deals.reduce((sum, d) => sum + (parseFloat(d['Amount']) || 0), 0);
  const activeDeals = deals.filter(
    (d) => d['Stage'] !== 'Closed Won' && d['Stage'] !== 'Closed Lost'
  ).length;
  const closedWon = deals.filter((d) => d['Stage'] === 'Closed Won').length;
  const winRate = totalDeals > 0 ? Math.round((closedWon / totalDeals) * 100) : 0;

  // Deals at risk — no recent activity (we use a simple heuristic: show all open deals)
  const openDeals = deals.filter((d) => d['Stage'] !== 'Closed Won' && d['Stage'] !== 'Closed Lost');

  const html = `
    <div class="page-header">
      <div>
        <div class="page-title">Dashboard</div>
        <div class="page-subtitle">Pipeline overview</div>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-label">Total Contacts</div>
        <div class="stat-value blue">${totalContacts}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Total Deals</div>
        <div class="stat-value purple">${totalDeals}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Pipeline Value</div>
        <div class="stat-value green">${fmtCurrencyFull(pipelineValue)}</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Active Deals</div>
        <div class="stat-value yellow">${activeDeals}</div>
      </div>
      ${totalDeals > 0 ? `
      <div class="stat-card">
        <div class="stat-label">Win Rate</div>
        <div class="stat-value green">${winRate}%</div>
        <div class="stat-change">${closedWon} closed won</div>
      </div>` : ''}
    </div>

    <div class="two-col">
      <!-- Recent Activity -->
      <div class="card">
        <div class="card-title">📋 Recent Activity</div>
        ${activities.length === 0
          ? `<div style="font-size:13px;color:var(--color-text-muted);">No activities yet. Log your first activity with the AI agent.</div>`
          : `<div class="activity-list">${activities.map(renderActivityItem).join('')}</div>`
        }
      </div>

      <!-- Deals at Risk -->
      <div class="card">
        <div class="card-title">⚠️ Open Deals</div>
        ${openDeals.length === 0
          ? `<div style="font-size:13px;color:var(--color-text-muted);">No open deals. Create your first deal with the AI agent.</div>`
          : openDeals.slice(0, 5).map(renderRiskItem).join('')
        }
      </div>
    </div>

    <!-- AI Suggestion Prompts -->
    <div class="card">
      <div class="card-title">🤖 Ask Atlas</div>
      <div class="ai-prompts">
        <span class="prompt-chip">Which deals are at risk?</span>
        <span class="prompt-chip">Who should I follow up with today?</span>
        <span class="prompt-chip">Show me all deals above $10k</span>
        <span class="prompt-chip">Summarize my pipeline</span>
        <span class="prompt-chip">Write a follow-up email for the Acme deal</span>
        <span class="prompt-chip">What's my win rate this month?</span>
      </div>
    </div>
  `;

  container.innerHTML = html;
}

function renderActivityItem(r) {
  const icons = { Call: '📞', Meeting: '🤝', Email: '✉️', Note: '📝' };
  const badges = { Call: 'badge-call', Meeting: 'badge-meeting', Email: 'badge-email', Note: 'badge-note' };
  const type = r['Type'] || 'Note';
  const icon = icons[type] || '📋';
  const badgeClass = badges[type] || 'badge-note';
  const date = r['Date'] ? fmtDateShort(r['Date']) : '';

  return `
    <div class="activity-item">
      <div class="activity-icon">${icon}</div>
      <div class="activity-body">
        <div class="activity-meta">
          <span class="activity-contact">${esc(r['Contact'] || '—')}</span>
          <span class="badge ${badgeClass}">${esc(type)}</span>
          <span class="activity-date">${date}</span>
        </div>
        ${r['Notes'] ? `<div class="activity-notes">${esc(r['Notes'])}</div>` : ''}
      </div>
    </div>
  `;
}

function renderRiskItem(r) {
  const stageBadges = {
    'Discovery':   'badge-discovery',
    'Proposal':    'badge-proposal',
    'Negotiation': 'badge-negotiation',
  };
  const stage = r['Stage'] || '';
  const badgeClass = stageBadges[stage] || 'badge-note';
  const amount = parseFloat(r['Amount']) || 0;

  return `
    <div class="risk-item">
      <div>
        <div class="risk-name">${esc(r['Deal Name'] || '—')}</div>
        <div class="risk-company">${esc(r['Company'] || '—')} · ${fmtCurrencyFull(amount)}</div>
      </div>
      <span class="badge ${badgeClass}">${esc(stage)}</span>
    </div>
  `;
}

function fmtCurrencyFull(value) {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(value);
}

function fmtDateShort(dateStr) {
  if (!dateStr) return '';
  try {
    const d = new Date(dateStr);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  } catch {
    return dateStr;
  }
}

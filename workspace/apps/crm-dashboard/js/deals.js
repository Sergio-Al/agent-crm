/* deals.js — Deals pipeline (kanban-style board) */

const DEAL_STAGES = [
  { key: 'Discovery',    slug: 'discovery',    label: 'Discovery'    },
  { key: 'Proposal',     slug: 'proposal',     label: 'Proposal'     },
  { key: 'Negotiation',  slug: 'negotiation',  label: 'Negotiation'  },
  { key: 'Closed Won',   slug: 'closed-won',   label: 'Closed Won'   },
  { key: 'Closed Lost',  slug: 'closed-lost',  label: 'Closed Lost'  },
];

async function renderDeals() {
  const container = document.getElementById('view-deals');
  container.innerHTML = `<div class="loading"><div class="spinner"></div> Loading deals…</div>`;

  let rows = [];
  try {
    if (window.dench && window.dench.db) {
      rows = await window.dench.db.query(`
        SELECT
          "Deal Name",
          "Company",
          "Amount",
          "Stage",
          "Close Date",
          "Primary Contact"
        FROM v_deal
        ORDER BY created_at DESC
      `);
    }
  } catch (e) {
    console.warn('[CRM] deals query failed:', e);
  }

  const totalDeals = rows.length;
  const totalValue = rows.reduce((sum, r) => sum + (parseFloat(r['Amount']) || 0), 0);

  const html = `
    <div class="page-header">
      <div>
        <div class="page-title">Deals Pipeline</div>
        <div class="page-subtitle">${totalDeals} deal${totalDeals !== 1 ? 's' : ''} · ${fmtCurrency(totalValue)} total</div>
      </div>
    </div>

    ${totalDeals === 0 ? renderDealsEmpty() : renderPipelineBoard(rows)}
  `;

  container.innerHTML = html;
}

function renderPipelineBoard(rows) {
  const byStage = {};
  DEAL_STAGES.forEach((s) => { byStage[s.key] = []; });
  rows.forEach((r) => {
    const stage = r['Stage'] || 'Discovery';
    if (!byStage[stage]) byStage[stage] = [];
    byStage[stage].push(r);
  });

  const columns = DEAL_STAGES.map(({ key, slug, label }) => {
    const deals = byStage[key] || [];
    const total = deals.reduce((sum, r) => sum + (parseFloat(r['Amount']) || 0), 0);

    const cards = deals.length
      ? deals.map((r) => `
          <div class="deal-card">
            <div class="deal-card-name">${esc(r['Deal Name'] || '—')}</div>
            <div class="deal-card-company">${esc(r['Company'] || '—')}</div>
            <div class="deal-card-amount">${fmtCurrency(parseFloat(r['Amount']) || 0)}</div>
            ${r['Primary Contact'] ? `<div class="deal-card-company" style="margin-top:4px">👤 ${esc(r['Primary Contact'])}</div>` : ''}
          </div>
        `).join('')
      : `<div style="font-size:12px;color:var(--color-text-muted);padding:8px 4px;">No deals</div>`;

    return `
      <div class="pipeline-column stage-${slug}">
        <div class="pipeline-header">
          <div class="pipeline-stage">${label}</div>
          <div class="pipeline-total">${deals.length} deal${deals.length !== 1 ? 's' : ''} · ${fmtCurrency(total)}</div>
        </div>
        <div class="pipeline-cards">${cards}</div>
      </div>
    `;
  }).join('');

  return `<div class="pipeline-board">${columns}</div>`;
}

function renderDealsEmpty() {
  return `
    <div class="empty-state">
      <div class="empty-state-icon">💼</div>
      <div class="empty-state-title">No deals in the pipeline</div>
      <div class="empty-state-text">Ask the AI agent to create your first deal.</div>
      <div class="prompt-chips">
        <span class="prompt-chip">Create a $15,000 deal with Acme, stage Negotiation</span>
        <span class="prompt-chip">Add a $8,500 deal with Globex, stage Proposal</span>
        <span class="prompt-chip">Show me all open deals</span>
      </div>
    </div>
  `;
}

function fmtCurrency(value) {
  if (value >= 1000) {
    return '$' + (value / 1000).toFixed(1).replace(/\.0$/, '') + 'k';
  }
  return '$' + value.toFixed(0);
}

/* activities.js — Activity log / timeline view */

const ACTIVITY_ICONS = {
  Call:    '📞',
  Meeting: '🤝',
  Email:   '✉️',
  Note:    '📝',
};

const ACTIVITY_BADGE = {
  Call:    'badge-call',
  Meeting: 'badge-meeting',
  Email:   'badge-email',
  Note:    'badge-note',
};

async function renderActivities() {
  const container = document.getElementById('view-activities');
  container.innerHTML = `<div class="loading"><div class="spinner"></div> Loading activities…</div>`;

  let rows = [];
  try {
    if (window.dench && window.dench.db) {
      rows = await window.dench.db.query(`
        SELECT
          "Contact",
          "Type",
          "Date",
          "Notes",
          "Deal"
        FROM v_activity
        ORDER BY "Date" DESC
      `);
    }
  } catch (e) {
    console.warn('[CRM] activities query failed:', e);
  }

  const html = `
    <div class="page-header">
      <div>
        <div class="page-title">Activities</div>
        <div class="page-subtitle">${rows.length} activit${rows.length !== 1 ? 'ies' : 'y'}</div>
      </div>
    </div>

    ${rows.length === 0 ? renderActivitiesEmpty() : renderActivityFeed(rows)}
  `;

  container.innerHTML = html;
}

function renderActivityFeed(rows) {
  const items = rows.map((r) => {
    const type = r['Type'] || 'Note';
    const icon = ACTIVITY_ICONS[type] || '📋';
    const badgeClass = ACTIVITY_BADGE[type] || 'badge-note';
    const date = r['Date'] ? fmtDate(r['Date']) : '—';
    const notes = r['Notes'] || '';

    return `
      <div class="activity-item">
        <div class="activity-icon">${icon}</div>
        <div class="activity-body">
          <div class="activity-meta">
            <span class="activity-contact">${esc(r['Contact'] || '—')}</span>
            <span class="badge ${badgeClass}">${esc(type)}</span>
            ${r['Deal'] ? `<span style="font-size:12px;color:var(--color-text-muted)">· ${esc(r['Deal'])}</span>` : ''}
            <span class="activity-date">${date}</span>
          </div>
          ${notes ? `<div class="activity-notes">${esc(notes)}</div>` : ''}
        </div>
      </div>
    `;
  }).join('');

  return `
    <div class="card">
      <div class="activity-list">${items}</div>
    </div>
  `;
}

function renderActivitiesEmpty() {
  return `
    <div class="empty-state">
      <div class="empty-state-icon">📋</div>
      <div class="empty-state-title">No activities logged yet</div>
      <div class="empty-state-text">Ask the AI agent to log your first activity.</div>
      <div class="prompt-chips">
        <span class="prompt-chip">Log a call with John about pricing</span>
        <span class="prompt-chip">Log a meeting with Maria from Globex</span>
        <span class="prompt-chip">Add a note about the Acme deal</span>
      </div>
    </div>
  `;
}

function fmtDate(dateStr) {
  if (!dateStr) return '—';
  try {
    const d = new Date(dateStr);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  } catch {
    return dateStr;
  }
}

/* contacts.js — Contacts table view */

async function renderContacts() {
  const container = document.getElementById('view-contacts');
  container.innerHTML = `<div class="loading"><div class="spinner"></div> Loading contacts…</div>`;

  let rows = [];
  try {
    if (window.dench && window.dench.db) {
      rows = await window.dench.db.query(`
        SELECT
          "Full Name",
          "Email Address",
          "Company",
          "Phone Number",
          "Last Contacted"
        FROM v_contact
        ORDER BY "Full Name" ASC
      `);
    }
  } catch (e) {
    console.warn('[CRM] contacts query failed:', e);
  }

  const html = `
    <div class="page-header">
      <div>
        <div class="page-title">Contacts</div>
        <div class="page-subtitle">${rows.length} contact${rows.length !== 1 ? 's' : ''}</div>
      </div>
    </div>

    <div class="search-bar">
      <input
        type="text"
        class="search-input"
        id="contact-search"
        placeholder="Search by name, email, or company…"
      />
    </div>

    ${rows.length === 0 ? renderContactsEmpty() : renderContactsTable(rows)}
  `;

  container.innerHTML = html;

  // Bind search
  const searchInput = document.getElementById('contact-search');
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      filterContactTable(e.target.value.toLowerCase());
    });
  }

    // Sort by clicking headers — re-render with sorted data
    container.querySelectorAll('th[data-col]').forEach((th) => {
      th.addEventListener('click', () => renderContacts());
    });
}

function renderContactsTable(rows) {
  const trs = rows
    .map(
      (r) => `
      <tr data-search="${[r['Full Name'], r['Email Address'], r['Company']].join(' ').toLowerCase()}">
        <td>${esc(r['Full Name'] || '—')}</td>
        <td>${r['Email Address'] ? `<a href="mailto:${esc(r['Email Address'])}">${esc(r['Email Address'])}</a>` : '—'}</td>
        <td>${esc(r['Company'] || '—')}</td>
        <td>${esc(r['Last Contacted'] || '—')}</td>
      </tr>
    `
    )
    .join('');

  return `
    <div class="table-container">
      <table class="data-table" id="contacts-table">
        <thead>
          <tr>
            <th data-col="name">Full Name</th>
            <th data-col="email">Email</th>
            <th data-col="company">Company</th>
            <th data-col="last-contacted">Last Contacted</th>
          </tr>
        </thead>
        <tbody>${trs}</tbody>
      </table>
    </div>
  `;
}

function renderContactsEmpty() {
  return `
    <div class="empty-state">
      <div class="empty-state-icon">👥</div>
      <div class="empty-state-title">No contacts yet</div>
      <div class="empty-state-text">Ask the AI agent to create your first contact.</div>
      <div class="prompt-chips">
        <span class="prompt-chip">Add a contact John from Acme, email john@acme.com</span>
        <span class="prompt-chip">Add Maria Garcia from Globex, email maria@globex.com</span>
        <span class="prompt-chip">Show me all my contacts</span>
      </div>
    </div>
  `;
}

function filterContactTable(query) {
  const table = document.getElementById('contacts-table');
  if (!table) return;
  table.querySelectorAll('tbody tr').forEach((tr) => {
    const match = !query || tr.dataset.search.includes(query);
    tr.style.display = match ? '' : 'none';
  });
}


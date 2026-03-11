/* utils.js — Shared utilities for the CRM Dashboard */

/**
 * Escape HTML special characters to prevent XSS when rendering user data.
 * @param {unknown} str - Value to escape
 * @returns {string} Escaped HTML string
 */
function esc(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

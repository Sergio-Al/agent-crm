/* app.js — Main orchestrator: navigation, init, auto-refresh */

(function () {
  const VIEWS = ['insights', 'contacts', 'deals', 'activities'];
  let currentView = 'insights';
  let refreshInterval = null;

  function navigate(view) {
    if (!VIEWS.includes(view)) return;
    currentView = view;

    // Update nav items
    document.querySelectorAll('.nav-item').forEach((el) => {
      el.classList.toggle('active', el.dataset.view === view);
    });

    // Update view panels
    document.querySelectorAll('.view').forEach((el) => {
      el.classList.toggle('active', el.id === `view-${view}`);
    });

    // Render the active view
    switch (view) {
      case 'insights':    renderInsights();    break;
      case 'contacts':    renderContacts();    break;
      case 'deals':       renderDeals();       break;
      case 'activities':  renderActivities();  break;
    }
  }

  function bindNavigation() {
    document.querySelectorAll('.nav-item').forEach((el) => {
      el.addEventListener('click', () => navigate(el.dataset.view));
    });
  }

  function startAutoRefresh() {
    if (refreshInterval) clearInterval(refreshInterval);
    refreshInterval = setInterval(() => {
      navigate(currentView);
    }, 60000); // refresh every 60 seconds
  }

  function init() {
    bindNavigation();
    navigate('insights');
    startAutoRefresh();
  }

  // Wait for DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();

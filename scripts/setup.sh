#!/usr/bin/env bash
# =============================================================
# setup.sh — One-command setup for Agent CRM
# =============================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

log()   { echo -e "${CYAN}▶ $1${RESET}"; }
ok()    { echo -e "${GREEN}✓ $1${RESET}"; }
warn()  { echo -e "${YELLOW}⚠ $1${RESET}"; }
error() { echo -e "${RED}✗ $1${RESET}"; exit 1; }

echo ""
echo -e "${CYAN}╔══════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║        Agent CRM — Setup             ║${RESET}"
echo -e "${CYAN}╚══════════════════════════════════════╝${RESET}"
echo ""

# ---------------------------------------------------------------
# 1. Check Node.js >= 22
# ---------------------------------------------------------------
log "Checking Node.js version..."

if ! command -v node &> /dev/null; then
  error "Node.js not found. Please install Node.js >= 22 from https://nodejs.org/"
fi

NODE_VERSION=$(node -e "process.stdout.write(process.version.slice(1).split('.')[0])")
if [ "$NODE_VERSION" -lt 22 ]; then
  error "Node.js >= 22 required. Found: $(node --version). Please upgrade."
fi

ok "Node.js $(node --version)"

# ---------------------------------------------------------------
# 2. Check .env file
# ---------------------------------------------------------------
log "Checking .env file..."

if [ ! -f ".env" ]; then
  if [ -f ".env.example" ]; then
    cp .env.example .env
    warn ".env not found — copied from .env.example"
    warn "Please edit .env and set your OPENAI_API_KEY before running 'npm run dev'"
  else
    error ".env file not found. Please create one with OPENAI_API_KEY=sk-..."
  fi
else
  ok ".env found"
fi

# ---------------------------------------------------------------
# 3. Install / check denchclaw
# ---------------------------------------------------------------
log "Checking denchclaw..."

if ! command -v denchclaw &> /dev/null; then
  log "Installing denchclaw globally..."
  npm install -g denchclaw
  ok "denchclaw installed"
else
  ok "denchclaw found: $(denchclaw --version 2>/dev/null || echo 'installed')"
fi

# ---------------------------------------------------------------
# 4. Create workspace directory if needed
# ---------------------------------------------------------------
log "Preparing workspace..."

if [ ! -d "workspace" ]; then
  error "workspace/ directory not found. Are you in the agent-crm root?"
fi

ok "workspace/ ready"

# ---------------------------------------------------------------
# 5. Seed the DuckDB database
# ---------------------------------------------------------------
if command -v duckdb &> /dev/null; then
  log "Seeding DuckDB schema..."
  duckdb workspace/workspace.duckdb < scripts/seed-schema.sql
  ok "Schema seeded"

  log "Seeding sample data..."
  duckdb workspace/workspace.duckdb < scripts/seed-data.sql
  ok "Sample data seeded"
else
  warn "DuckDB CLI not found — skipping database seed."
  warn "Install DuckDB CLI from https://duckdb.org/docs/installation/"
  warn "Then run: npm run seed"
fi

# ---------------------------------------------------------------
# 6. Done
# ---------------------------------------------------------------
echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗${RESET}"
echo -e "${GREEN}║         Setup complete! 🎉            ║${RESET}"
echo -e "${GREEN}╚══════════════════════════════════════╝${RESET}"
echo ""
echo -e "  Next steps:"
echo -e "  ${CYAN}1.${RESET} Edit ${YELLOW}.env${RESET} and set your ${YELLOW}OPENAI_API_KEY${RESET}"
echo -e "  ${CYAN}2.${RESET} Run ${YELLOW}npm run dev${RESET} to start DenchClaw"
echo -e "  ${CYAN}3.${RESET} Open the CRM Dashboard app in the apps panel"
echo -e "  ${CYAN}4.${RESET} Ask Atlas: ${YELLOW}\"Who should I follow up with today?\"${RESET}"
echo ""

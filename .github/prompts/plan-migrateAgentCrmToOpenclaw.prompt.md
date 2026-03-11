# Plan: Migrate Agent CRM from DenchClaw to OpenClaw

Replace the DenchClaw dependency with OpenClaw directly. The CRM agent, dashboard, and database schema stay nearly identical — the main work is swapping CLI commands, including the real CRM skill, adding `.object.yaml` files, and packaging the dashboard as a proper `.dench.app`.

---

## Phase 1: Project scaffolding & setup script
*Can start immediately*

1. Update `package.json` — replace all `denchclaw` scripts with `openclaw` equivalents (`openclaw gateway run`, `openclaw gateway stop`, etc.)
2. Rewrite `scripts/setup.sh` — install `openclaw` instead of `denchclaw`, copy workspace files into the OpenClaw profile directory (`~/.openclaw-dench/workspace/`)
3. Create a new `scripts/install-workspace.sh` — copies persona files, CRM skill, dashboard app, and reports into the OpenClaw workspace. Won't overwrite existing files without `--force`.

## Phase 2: CRM Skill file
*Parallel with Phase 1*

4. Add `workspace/skills/crm/SKILL.md` to the repo — copy from `~/.openclaw-dench/workspace/skills/crm/SKILL.md` (the ~3000-line skill that teaches the agent DuckDB operations, object management, post-mutation checklists, etc.)
5. Simplify `workspace/AGENTS.md` — remove CRM tool documentation (the skill handles that now), keep general agent behavior guidelines only

## Phase 3: Database & object alignment
*Depends on Phase 1 (needs install path finalized)*

6. Update seed scripts to target `~/.openclaw-dench/workspace/workspace.duckdb` — schema SQL itself is unchanged
7. Create `.object.yaml` files for `contact`, `deal`, and `activity` — OpenClaw requires these for sidebar rendering and "triple alignment" (DuckDB name = directory name = .yaml name)
8. Create matching object directories (`workspace/contact/`, `workspace/deal/`, `workspace/activity/`)

## Phase 4: Dashboard app migration
*Parallel with Phases 1-3*

9. Rename app folder to `crm-dashboard.dench.app/` (OpenClaw naming convention)
10. Add `.dench.yaml` manifest (declaring `database` permission, `static` runtime)
11. All JS/CSS/HTML files stay **unchanged** — the Bridge API (`window.dench.db.query()`) is the same under OpenClaw

## Phase 5: Documentation & cleanup
*Depends on Phases 1-4*

12. Rewrite `README.md` — architecture diagram, prerequisites, quick start, all referencing OpenClaw
13. Update `docs/demo-script.md` — remove DenchClaw-specific references
14. Add gateway lifecycle instructions (start, stop, uninstall)

---

## Relevant files

| Action | File |
|---|---|
| **Modify** | `package.json`, `scripts/setup.sh`, `workspace/AGENTS.md`, `README.md`, `docs/demo-script.md` |
| **Create** | `workspace/skills/crm/SKILL.md`, `workspace/apps/crm-dashboard.dench.app/.dench.yaml`, `workspace/contact/.object.yaml`, `workspace/deal/.object.yaml`, `workspace/activity/.object.yaml`, `scripts/install-workspace.sh` |
| **Unchanged** | All 6 JS files, CSS, HTML, seed SQL files, `IDENTITY.md`, `SOUL.md`, `USER.md`, `TOOLS.md`, `pipeline.report.json` |

## Verification

1. `npm run setup` → openclaw installed, DB seeded, workspace files copied
2. `npm run bootstrap` → gateway starts, web UI opens
3. Chat: *"What CRM objects can you manage?"* → agent lists contact, deal, activity
4. CRUD: create contact/deal/activity via chat → data appears in DuckDB
5. Open CRM Dashboard app → all 4 views render data
6. Open pipeline report → charts render
7. `npm run stop` → `pgrep -fl openclaw` returns nothing

## Decisions

- **Fresh repo vs in-place:** Recommend fresh repo (`openclaw-crm`), but can be done on a branch
- **CRM objects:** Keep `contact`/`deal`/`activity` (not OpenClaw's defaults `people`/`company`/`task`)
- **Dashboard:** Port existing — rename + add manifest, code unchanged
- **Profile:** Use existing `~/.openclaw-dench/` (already bootstrapped)

## Further Considerations

1. **Workspace safety** — setup copies files into `~/.openclaw-dench/workspace/` which could overwrite existing data. Recommend `--force` flag for explicit overwrites.
2. **Version pinning** — `npm install -g openclaw` installs latest. Consider pinning a known-good version.
3. **DenchClaw cleanup** — README should include `npm uninstall -g denchclaw` for users migrating.

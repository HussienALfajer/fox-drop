# apps/admin

The admin panel «لوحة الإدارة»: a static single-page app (architecture §10). The rules shared with the owner web portal (feature and page pairs, API, same origin, Arabic, lint, money, time, permissions, commands, CSP, UI, tests) are `.claude/rules/web-apps.md`; they load by themselves here.

## Rules

- **City:** the `city` search parameter travels on every link; the panel shows and types times on that city's clock.

## Commands

- `pnpm --filter @fox-drop/admin dev`: the panel on http://localhost:5173.
- `pnpm --filter @fox-drop/admin test:e2e`: build, then the smoke tests (port 4173). `pnpm verify` runs both for every app.

## More

Behaviour, decisions and history: `docs/code/apps/admin.md`. Grep it for what you change; never read it whole.

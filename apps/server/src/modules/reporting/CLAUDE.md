# reporting module

Statements, reports, the dashboard, the Excel exports and the read-only profiles (restaurants, captains, audit log) (architecture §4.2, §5.9; AP §9). It reads other modules through their public services and owns only `reporting.exports`.

## Rules

- **Read, never write:** a report reads other modules through their public services (`MerchantPeriodService`, `AdminSessionsService.names`, the audit module's `search`, and so on); never read their schemas. Only `reporting.exports` is written here.
- **Pure figures first:** the numbers live in pure files with tests (`daily-figures.ts`, `dashboard-figures.ts`, `cost-report.ts`, `report-tables.ts`, `restaurant-report.ts`); services gather the data and call them. Copy that split for a new report.
- **Money:** integer minor units, sent as strings; an Excel amount is a number in major units written from its digits (`majorOf`), never a float sum. A statement and its opening balance are read in one repeatable-read snapshot.
- **Days and time:** a business day runs from `finance.business_day_cutoff` on the city's clock (`YYYY-MM-DD`, both ends included); times in a file use the city's clock. Periods are bounded (`PERIOD_MAX_DAYS`, 366) with `400 invalid_period`.
- **Exports (architecture §5.9):** one transaction records `reporting.exports` (pending), sends `QUEUES.exportBuild` and audits `export.create`; the route answers `202`. The key is unique per requester (`422 idempotency_key_reused`). `ExportsWorker` writes the workbook with ExcelJS (one right-to-left sheet) to `private-docs` and sends `QUEUES.exportExpiry` for 24 hours later. Both jobs re-read the export and act only on its state, so a repeat changes nothing.
- **Downloads:** `GET /v1/admin/exports/{exportId}` answers its requester only (`404 unknown_export`); a download signs a short URL and audits `export.download` (architecture §5.8). Each kind has its own permission (`exportPermissions`, `mayReadExport`); a merchant kind is never readable through the panel's.
- **Merchant portal files:** asked by an owner from the portal only (`@AppSignedIn({ portal: true })`; `403 not_in_portal`, `403 owner_only`), with the same key, record and audit.
- **Words:** the file's labels live in the content module (`export-labels.ts`) and must equal the panel's words; their tests enforce it. Never write a label here.
- **A new workbook:** add the kind to `adminExportKinds` or `merchantExportKinds` with its permission, a `*-workbook.ts` with its test, and the worker's case.
- **Audit log read:** `GET /v1/admin/audit-log` only reads; no route changes the log.

## More

Behaviour, decisions and slice history: `docs/code/apps/server/src/modules/reporting.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.

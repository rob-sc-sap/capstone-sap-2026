# Vendor Selection Optimization — Full-Stack CAP Application

> **Scope:** This repository contains the complete full-stack application — CDS schema, mock seed data (CSV files), OData service definition, service handlers, and SAP Fiori Elements UI apps — for the Vendor Selection Optimization capstone project. It is designed specifically for **SAP Build Code** (SAP's cloud-based IDE on BTP) and is not intended to run as a standalone application outside of that environment.

**Team StackUnderflow (#6)** — Francisco Martinez, Kush Dang, Harsh Deodhar, Amritsai Sivasubramanian

---

## What This Repo Contains

| Path | Purpose |
|------|---------|
| `db/schema.cds` | Full CDS data model (entities, associations, types) |
| `db/data/*.csv` | Mock seed data — auto-loaded by CAP on startup |
| `srv/procurement-service.cds` | OData service definition (exposes all entities, computed criticality fields) |
| `srv/procurement-service.ts` | Service handler (auto-increments integer PKs, reset actions) |
| `app/products1/` | SAP Fiori Elements app — Products list & object page |
| `app/purchaseorders1/` | SAP Fiori Elements app — Purchase Orders list & object page |
| `app/kpiprofile1/` | SAP Fiori Elements app — KPI Profile list & object page |
| `app/services.cds` | Aggregates all UI app annotation imports |
| `test/http/ProcurementService.http` | HTTP test file covering all OData endpoints |
| `mta.yaml` | Multi-Target Application descriptor for BTP deployment |
| `xs-security.json` | XSUAA security descriptor |

---

## Data Model Overview

```
Master Data:       Product, Country
Vendor Layer:      Vendor, VendorContract, VendorQuote
Tariffs & KPIs:    Tariff, KPI_profile
Procurement Flow:  ProcurementRequest → ApprovalLog → PlannerComment
Optimization:      OptimizationScenario → AllocationResult → DecisionOverride → PurchaseOrder → ProcurementIssue
AI / Agent Layer:  AgentContext, AgentActionLog, AgentActionReference
```

The service is exposed at `/odata/v4/procurement/` and requires XSUAA authentication in production.

---

## OData Service — Entities & Actions

All entities are exposed via `ProcurementService`. Several projections include computed `criticality` fields used by the Fiori UI to drive color coding:

| Entity | Criticality Logic |
|--------|-------------------|
| `Products` | `1` (red) when `current_stock_level < safety_stock_level`; `3` (green) otherwise |
| `PurchaseOrders` | `1` (red) for `cancelled`, `2` (orange) for `delayed`, `0` (none) otherwise |
| `KPIprofile` | `2` (warning) when OTIF score < 90, risk rating > 40, logistic cost > 1.0, or vendor not compliant |

### Actions

| Action | Description |
|--------|-------------|
| `ResetProcurementRequests()` | Deletes all rows from `ProcurementRequest`; returns `Boolean` |
| `ResetProcurementIssues()` | Deletes all rows from `ProcurementIssue`; returns `Boolean` |

---

## Frontend — Fiori Elements UI Apps

Three SAP Fiori Elements apps are served directly by the CAP server via the `cds-plugin-ui5` plugin. Each app is a standard List Report + Object Page layout.

| App | Entity | URL (local) |
|-----|--------|-------------|
| `products1` | `Products` | `/products1/index.html` |
| `purchaseorders1` | `PurchaseOrders` | `/purchaseorders1/index.html` |
| `kpiprofile1` | `KPIprofile` | `/kpiprofile1/index.html` |

**`cds.fiori.direct_crud: true`** is set in `package.json` — this disables draft mode so all CRUD operations go directly to the active entity without a draft workflow.

Each app includes OPA5 integration tests under `webapp/test/integration/`.

---

## Seed Data

All mock data lives in `db/data/` as CSV files named `<namespace>-<EntityName>.csv` (e.g., `mydb-Vendor.csv`). CAP loads them automatically on startup.

| CSV File | Entity |
|----------|--------|
| `mydb-Product.csv` | Products (with stock levels) |
| `mydb-Vendor.csv` | Vendors (with risk rating, compliance) |
| `mydb-VendorContract.csv` | Vendor contracts |
| `mydb-VendorQuote.csv` | Vendor quotes |
| `mydb-KPI_profile.csv` | KPI profiles linked to vendors |
| `mydb-PurchaseOrder.csv` | Purchase orders |
| `mydb-ProcurementIssue.csv` | Procurement issues |
| `mydb-ProcurementRequest.csv` | Procurement requests |
| `mydb-Country.csv` | Countries |
| `mydb-Tariff.csv` | Tariffs |
| `mydb-ApprovalLog.csv` | Approval log entries |
| `mydb-PlannerComment.csv` | Planner comments |
| `mydb-OptimizationScenario.csv` | Optimization scenarios |
| `mydb-AllocationResult.csv` | Allocation results |
| `mydb-DecisionOverride.csv` | Decision overrides |
| `mydb-AgentContext.csv` | AI agent sessions |
| `mydb-AgentActionLog.csv` | AI agent action log |
| `mydb-AgentActionReference.csv` | AI agent action references |

- **Local / hybrid:** restart `cds watch` to reset data
- **Production (HANA):** re-running the HDI deployer via `cf deploy` re-applies the seed data

---

## Prerequisites

### BTP Account Requirements

You must have access to an **SAP BTP subaccount** with the following configured:

| Requirement | Details |
|-------------|---------|
| SAP Build Code | Dev Space with the **Full Stack Cloud Application** extension enabled |
| Cloud Foundry environment | Enabled on your BTP subaccount with an org and space |
| SAP HANA Cloud | An active HANA Cloud instance in your CF space |
| XSUAA | Provided automatically by BTP — no manual setup needed |
| Destination Service | An existing service instance named `app-frontend-shared-destination-service` in your CF space |

> SAP Build Code comes with `cf`, `mbt`, Node.js, and the SAP CAP CLI (`cds`) pre-installed in the Dev Space. No local tooling installation is required.

### BTP Services Required in Your CF Space

The `mta.yaml` references these services — confirm they exist in your space before deploying:

| Service Name | Service Type | Plan | Created by |
|---|---|---|---|
| `vendor-selection-db` | SAP HANA Cloud (HDI) | `hdi-shared` | MTA deployer (auto) |
| `vendor-selection-auth` | XSUAA | `application` | MTA deployer (auto) |
| `app-frontend-shared-destination-service` | Destination | — | Must already exist in your space |

---

## Development Workflow

Changes to the schema (`db/schema.cds`), mock data (`db/data/*.csv`), service (`srv/`), and UI apps (`app/`) are made **locally**, then deployed through SAP Build Code where Cloud Foundry is pre-installed.

---

## Deploying via SAP Build Code

All deployment commands are run from the terminal inside the **SAP Build Code** online IDE.

### 1. Open the project

Log in to [SAP Build Code](https://build.cloud.sap) and open the **Vendor Selection** project.

### 2. Log in to Cloud Foundry

```bash
cf login
```

When prompted for the API endpoint, enter:

```
https://api.cf.eu10-005.hana.ondemand.com
```

Then enter your BTP email and password.

### 3. Build the MTA archive

```bash
mbt build
```

This runs `npm ci` and `npx cds build --production` (as defined in `mta.yaml`), then packages everything into `mta_archives/vendor-selection_1.0.0.mtar`.

### 4. Deploy to Cloud Foundry

```bash
cf deploy ./mta_archives/vendor-selection_1.0.0.mtar
```

This deploys three modules in parallel:
- `vendor-selection-srv` — the Node.js CAP service (includes the Fiori UI apps)
- `vendor-selection-db-deployer` — the HDI deployer (applies the schema and seed data to HANA)
- `vendor-selection-destinations` — registers the service URL as a BTP Destination

### 5. Bind the local project to the cloud HANA database

```bash
cds bind --to vendor-selection-db
```

This creates a local binding so the project can connect to the deployed HANA HDI container for hybrid testing.

### 6. Add HTTP configuration

```bash
cds add http
```

### 7. Check deployment logs

```bash
cf logs vendor-selection-srv --recent
```

Use this to verify the service started correctly and to diagnose any deployment errors.

### 8. Run in hybrid mode

```bash
cds watch --profile hybrid
```

This starts the CAP service locally but connected to the cloud HANA database instead of SQLite — useful for testing with real deployed data.

---

## Testing

HTTP test requests for all OData endpoints are in `test/http/ProcurementService.http`. These can be run directly from VS Code (REST Client extension) or SAP Build Code's HTTP client.

---

## Joule Studio Integration

Once the backend is deployed, the OData endpoints are registered as **actions** in Joule Studio and called through **skills**.

### Adding or updating API endpoints

1. Open Joule Studio and navigate to the **Actions** menu
2. Add or update the OData endpoint as an action
3. After any change to the actions, you must **release a new version** of the namespace service in Joule Studio
4. Update the **dependency** in Joule Studio to point to the new version

> Every time the API endpoints change (new entities exposed, service URL updated, etc.), steps 3 and 4 are required — Joule Studio will not pick up changes until a new version is released.

---

## Notes

- **AI Core:** The `GENERATIVE_AI_HUB` configuration in `package.json` points to an `AI_CORE` BTP Destination. That destination must be set up separately in your BTP subaccount — it is not part of this repo.
- **Authentication:** XSUAA is enforced in production. Local development via `cds watch` bypasses auth entirely.
- **Direct CRUD:** `cds.fiori.direct_crud: true` in `package.json` disables SAP Fiori draft mode — all UI edits go directly to the active entity.
- **Pre-built archive:** `mta_archives/vendor-selection_1.0.0.mtar` is checked in for convenience. Always run `mbt build` before deploying if you have made schema, service, or UI changes.

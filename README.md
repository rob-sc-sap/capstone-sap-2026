# Vendor Selection Optimization — Backend Data & Schema

> **Scope:** This repository contains **only the backend data layer** — the CDS schema, mock seed data (CSV files), and OData service definition — for the Vendor Selection Optimization capstone project. It is designed specifically for **SAP Build Code** (SAP's cloud-based IDE on BTP) and is not intended to run as a standalone application outside of that environment.

**Team StackUnderflow (#6)** — Francisco Martinez, Kush Dang, Harsh Deodhar, Amritsai Sivasubramanian

---

## What This Repo Contains

| Path | Purpose |
|------|---------|
| `db/schema.cds` | Full CDS data model (entities, associations, types) |
| `db/data/*.csv` | Mock seed data — auto-loaded by CAP on startup |
| `srv/procurement-service.cds` | OData service definition (exposes all entities) |
| `srv/procurement-service.ts` | Service handler (auto-increments integer PKs) |
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

Changes to the schema (`db/schema.cds`) and mock data (`db/data/*.csv`) are made **locally**, then deployed through SAP Build Code where Cloud Foundry is pre-installed.

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
- `vendor-selection-srv` — the Node.js CAP service
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

## Joule Studio Integration

Once the backend is deployed, the OData endpoints are registered as **actions** in Joule Studio and called through **skills**.

### Adding or updating API endpoints

1. Open Joule Studio and navigate to the **Actions** menu
2. Add or update the OData endpoint as an action
3. After any change to the actions, you must **release a new version** of the namespace service in Joule Studio
4. Update the **dependency** in Joule Studio to point to the new version

> Every time the API endpoints change (new entities exposed, service URL updated, etc.), steps 3 and 4 are required — Joule Studio will not pick up changes until a new version is released.

---

## Seed Data

All mock data lives in `db/data/` as CSV files named `<namespace>-<EntityName>.csv` (e.g., `mydb-Vendor.csv`). CAP loads them automatically on startup.

- **Local / hybrid:** restart `cds watch` to reset data
- **Production (HANA):** re-running the HDI deployer via `cf deploy` re-applies the seed data

---

## Notes

- **AI Core:** The `GENERATIVE_AI_HUB` configuration in `package.json` points to an `AI_CORE` BTP Destination. That destination must be set up separately in your BTP subaccount — it is not part of this repo.
- **Authentication:** XSUAA is enforced in production. Local development via `cds watch` bypasses auth entirely.
- **Pre-built archive:** `mta_archives/vendor-selection_1.0.0.mtar` is checked in for convenience. Always run `mbt build` before deploying if you have made schema or service changes.

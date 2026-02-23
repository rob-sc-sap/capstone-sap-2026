using { cuid, managed } from '@sap/cds/common';

namespace sap.vendoropt;

// ─── ENUMS ──────────────────────────────────────────────────────────────────

type CurrencyCode : String(3) enum {
  USD;
  EUR;
  INR;
  GBP;
  JPY;
}

type RequestStatus : String(20) enum {
  PENDING_BUDGET;
  BUDGET_APPROVED;
  IN_SOURCING;
  PENDING_APPROVAL;
  APPROVED;
  PO_CREATED;
  CANCELLED;
}

type ApprovalStage : String(30) enum {
  BUDGET;
  VENDOR_RECOMMENDATION;
  RISK;
  CONTRACT;
}

type ApprovalDecision : String(10) enum {
  PENDING;
  APPROVED;
  REJECTED;
}

type ObjectiveFunction : String(20) enum {
  MINIMIZE_COST;
  BALANCE_RISK;
  MINIMIZE_LEAD_TIME;
}

type AgentActionStatus : String(10) enum {
  SUCCESS;
  FAILED;
  SKIPPED;
}

// ─── MASTER DATA ────────────────────────────────────────────────────────────

/**
 * Raw materials or components being sourced.
 * safetystocklevel is the automated trigger point for future auto-initiation.
 */
entity Product : cuid {
  name             : String  @mandatory;
  category         : String;
  safetystocklevel : Double  default 0;
}

/**
 * Approved supplier registry.
 * isCompliant and riskRating are used by agent for auto-filtering.
 */
entity Vendor : cuid {
  name        : String   @mandatory;
  country     : String;
  riskRating  : Integer  default 3;   // 1=Low Risk, 5=High Risk
  isCompliant : Boolean  default true;
}

/**
 * 1-to-1 with Vendor.
 * Agent periodically refreshes this and fires alerts if KPIs degrade post-PO.
 */
entity KPIProfile : cuid {
  vendor           : Association to Vendor  @mandatory;
  otifScore        : Double;               // On-Time In-Full %, higher is better
  currentTariffRate: Double;               // Current applicable tariff %
  logisticsCost    : Double;               // Cost of logistics per unit
  lastUpdated      : Timestamp             default $now;
}

/**
 * Active contract terms per vendor-product pair.
 * Agent uses MOQ and discount tiers during optimization to calculate true effective cost.
 */
entity VendorContract : cuid {
  vendor              : Association to Vendor    @mandatory;
  product             : Association to Product   @mandatory;
  startDate           : Date                     @mandatory;
  endDate             : Date;
  minimumOrderQty     : Integer;                 // Agent must not allocate below this value
  volumeDiscountTiers : LargeString;             // JSON e.g. [{"min_qty":500,"discount":0.05}]
  penaltyClause       : String;
}

// ─── PROCUREMENT TRIGGER ────────────────────────────────────────────────────

/**
 * Root trigger for the entire procurement workflow.
 * MVP = manually raised. Future = auto-triggered when current_stock < safetystocklevel.
 */
entity ProcurementRequest : cuid {
  product      : Association to Product  @mandatory;
  requestedQty : Integer                 @mandatory;
  status       : RequestStatus           default #PENDING_BUDGET;
  raisedBy     : String                  @mandatory;  // User ID of Business actor
  createdAt    : Timestamp               default $now;
}

// ─── HUMAN-IN-THE-LOOP GATES ────────────────────────────────────────────────

/**
 * Immutable audit trail of every human decision.
 * Joule reads decision=APPROVED to advance the workflow.
 * One row per stage per request.
 */
entity ApprovalLog : cuid {
  request   : Association to ProcurementRequest  @mandatory;
  stage     : ApprovalStage                      @mandatory;
  actorRole : String                             @mandatory;  // Finance | Business | Risk | Legal
  decision  : ApprovalDecision                   default #PENDING;
  comments  : String;
  decidedAt : Timestamp;
}

// ─── SOURCING & QUOTES ──────────────────────────────────────────────────────

/**
 * A vendor bid for a specific product.
 * Optionally linked to a VendorContract so agent can apply MOQ and discount logic.
 */
entity VendorQuote : cuid {
  vendor        : Association to Vendor           @mandatory;
  product       : Association to Product          @mandatory;
  contract      : Association to VendorContract;  // Optional — links to active contract terms
  unitPrice     : Double                          @mandatory;
  capacityLimit : Integer;                        // Max units this vendor can supply
  leadTimeDays  : Integer;
  currency      : CurrencyCode                    default #USD;
}

// ─── OPTIMIZATION ───────────────────────────────────────────────────────────

/**
 * Configuration for a single agent solver run.
 * Linked to a ProcurementRequest so the full chain is traceable.
 */
entity OptimizationScenario : cuid {
  request           : Association to ProcurementRequest  @mandatory;
  quote             : Association to VendorQuote          @mandatory;
  tariffMultiplier  : Double                              default 1.0;
  capacityDelta     : Double                              default 0;
  objectiveFunction : ObjectiveFunction                   default #MINIMIZE_COST;
  createdAt         : Timestamp                           default $now;
}

/**
 * One row per vendor-product pair in the split.
 * Surfaced to Business for VENDOR_RECOMMENDATION approval gate.
 */
entity AllocationResult : cuid {
  scenario           : Association to OptimizationScenario  @mandatory;
  vendor             : Association to Vendor                 @mandatory;
  product            : Association to Product                @mandatory;
  allocatedQuantity  : Integer                               @mandatory;
  totalEffectiveCost : Double;   // unit_price * qty + logistics + tariff (discounts applied)
  rationaleSummary   : String;   // Agent-generated explanation for Business approval
  createdAt          : Timestamp default $now;
}

// ─── FEEDBACK & OVERRIDE LOOP ───────────────────────────────────────────────

/**
 * Human feedback on agent decisions.
 * Agent reads this to avoid repeating rejected suggestions in future scenarios.
 */
entity PlannerComment : cuid {
  request      : Association to ProcurementRequest  @mandatory;
  authorId     : String                             @mandatory;
  linkedEntity : String                             @mandatory;  // Table name e.g. AllocationResult
  linkedId     : String                             @mandatory;  // Specific record ID
  textContent  : String                             @mandatory;
  createdAt    : Timestamp                          default $now;
}

/**
 * Records when a human manually changes an agent-generated allocation.
 * Agent uses this as a training signal to adjust future scenario weighting.
 */
entity DecisionOverride : cuid {
  originalAllocation : Association to AllocationResult  @mandatory;
  overriddenBy       : String                           @mandatory;
  newQuantity        : Integer                          @mandatory;
  overrideReasonCode : String;  // e.g. PREFERRED_VENDOR, BUDGET_CAP, RELATIONSHIP, COMPLIANCE
  createdAt          : Timestamp                        default $now;
}

// ─── AGENT SESSION STATE ────────────────────────────────────────────────────

/**
 * Lightweight session state for Joule. One active session per ProcurementRequest.
 * Joule handles agent logic; CAP stores state here.
 */
entity AgentContext : cuid {
  request           : Association to ProcurementRequest  @mandatory;
  allocation        : Association to AllocationResult;
  activeConstraints : LargeString;  // JSON e.g. {"max_risk_rating":3,"preferred_countries":["IN"]}
  lastAction        : String;       // e.g. QUOTES_FETCHED, SOLVER_RAN
  updatedAt         : Timestamp     default $now;
}

/**
 * Audit log of every autonomous agent action.
 * Pairs with ApprovalLog to give the full human + agent activity history.
 */
entity AgentActionLog : cuid {
  session    : Association to AgentContext  @mandatory;
  actionType : String                       @mandatory;  // e.g. FETCH_QUOTES, RUN_SOLVER, FLAG_RISK
  status     : AgentActionStatus            default #SUCCESS;
  inputRef   : String;   // ID of the record the agent acted on
  outputRef  : String;   // ID of the record the agent produced
  timestamp  : Timestamp default $now;
}

namespace mydb;

// -------------------------------------------------------
// Master Data
// -------------------------------------------------------

entity Product {
  @Common.Label : 'Product ID'
  key product_id         : Integer;
      name               : String(45) not null;
      category           : String(45);
      safety_stock_level  : Double;
      current_stock_level : Double;
}

entity Country {
  key country_id   : Integer;
      country_name : String(45) not null;
}

// -------------------------------------------------------
// Vendor & Contracts
// -------------------------------------------------------

entity Vendor {
  key vendor_id     : Integer;
      name          : String(45) not null;
      risk_rating   : Integer;
      is_compliant  : Boolean;
      contact_name  : String(45);
      contact_email : String(100);
      country       : Association to Country;
      product       : Association to Product;
}

entity VendorContract {
  key contract_id            : Integer;
      start_date             : DateTime not null;
      end_date               : DateTime;
      minimum_order_quantity : Integer;
      volume_discount_tiers  : LargeString;
      penalty_clause         : String(45);
      contract_pdf           : LargeBinary;
      vendor                 : Association to Vendor;
      product                : Association to Product;
}

entity VendorQuote {
  key quote_id       : Integer;
      unit_price     : Double not null;
      capacity_limit : Integer;
      lead_time_days : Integer;
      currency       : String(45);
      vendor         : Association to Vendor;
      contract       : Association to VendorContract;
      product        : Association to Product;
}

// -------------------------------------------------------
// Tariffs & KPIs
// -------------------------------------------------------

entity Tariff {
  key tariff_id           : Integer;
      current_tariff_rate : Double not null;
      effective_date      : DateTime;
      expiring_date       : DateTime;
      country             : Association to Country;
      product             : Association to Product;
}

entity KPI_profile {
  key kpi_id        : Integer;
      otif_score    : Double;
      logistic_cost : Double;
      last_updated  : DateTime;
      vendor        : Association to Vendor;
      tariff        : Association to Tariff;
}

// -------------------------------------------------------
// Procurement
// -------------------------------------------------------

entity ProcurementRequest {
  key request_id    : Integer;
      requested_qty : Integer not null;
      status        : String(10);  // pending | approved | rejected | fulfilled
      raised_by     : String(45) not null;
      created_at    : DateTime;
      product       : Association to Product;
}

entity ApprovalLog {
  key log_id     : Integer;
      stage      : String(15) not null;  // processing | complete
      actor_role : String(45) not null;
      decision   : String(10);           // denied | complete | pending
      decided_at : DateTime;
      request    : Association to ProcurementRequest;
}

entity PlannerComment {
  key comment_id   : Integer;
      author_id    : String(45);
      text_content : LargeString;
      created_at   : DateTime;
      approval_log : Association to ApprovalLog;
      contract     : Association to VendorContract;
      request      : Association to ProcurementRequest;
      vendor       : Association to Vendor;
}

// -------------------------------------------------------
// Optimization & Allocation
// -------------------------------------------------------

entity OptimizationScenario {
  key scenario_id        : Integer;
      tariff_multiplier  : Double;
      capacity_delta     : Double;
      objective_function : String(45);
      created_at         : DateTime;  // snapshot — tariffs can change daily
      request            : Association to ProcurementRequest;
      quote              : Association to VendorQuote;
}

entity AllocationResult {
  key allocation_id       : Integer;
      allocated_quantity  : Integer not null;
      total_effective_cost: Double;
      rationale_summary   : LargeString;
      created_at          : DateTime;
      suggested_by_agent  : Boolean;
      scenario            : Association to OptimizationScenario;
      vendor              : Association to Vendor;
      product             : Association to Product;
}

entity DecisionOverride {
  key override_id  : Integer;
      overridden_by: String(45) not null;
      new_quantity : Integer not null;
      created_at   : DateTime;
      reason_code  : String(45);
      allocation   : Association to AllocationResult;
}

entity PurchaseOrder {
  @Common.Label : 'Purchase Order ID'
  key po_id                  : Integer;
      status                 : String(15);  // active | delayed | cancelled | resolved
      po_pdf                 : LargeBinary;
      expected_delivery_date : DateTime;
      received_date          : DateTime;
      disruption_reason      : String(200);
      product_quantity       : Integer;
      po_total               : Double;
      allocation             : Association to AllocationResult;
      product                : Association to Product;
      vendor                 : Association to Vendor;
}

entity ProcurementIssue {
  key issue_id      : Integer;
      status        : String(15) not null;  // open | in_progress | resolved
      description   : LargeString;
      created_at    : DateTime;
      resolved_by   : String(10);          
      notes         : LargeString;
      purchase_order: Association to PurchaseOrder;
      vendor        : Association to Vendor;
}

// -------------------------------------------------------
// Agent / AI Workflow
// -------------------------------------------------------

entity AgentContext {
  key session_id        : Integer;
      active_constraints: LargeString;  // stored as JSON string
      last_action       : String(45);
      updated_at        : DateTime;
      request           : Association to ProcurementRequest;
}

entity AgentActionLog {
  key action_id   : Integer;
      action_type : String(25);  // suggested_allocation | query_vendor | override_check
      status      : String(10);  // pending | success | failed | skipped
      timestamp   : DateTime;
      context     : Association to AgentContext;
}

entity AgentActionReference {
  key reference_id  : Integer;
      direction     : String(10);   // input | output
      ref_type      : String(45);   // e.g. vendor_quote, kpi_profile, allocation_result
      ref_id        : String(45);
      snapshot_data : LargeString;
      created_at    : DateTime;
      action        : Association to AgentActionLog;
}
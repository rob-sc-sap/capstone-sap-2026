using mydb from '../db/schema';


service ProcurementService {
    @odata.draft.enabled
    entity Products         as projection on mydb.Product
    {
        *,
          // 1 = Red (Low Stock), 3 = Green (OK)
        
        case
        when current_stock_level < safety_stock_level then 1
        else 3
        end as criticality : Integer
    };
    entity Vendors          as projection on mydb.Vendor;
    entity Countries        as projection on mydb.Country;
    entity Tariffs          as projection on mydb.Tariff;
    entity VendorContracts  as projection on mydb.VendorContract;
    @odata.draft.enabled
    entity PurchaseOrders   as projection on mydb.PurchaseOrder
     {
        *,
          // 1 = Red (Low Stock), 3 = Green (OK)
        
        case
        when status == 'cancelled' then 1
        when status == 'delayed' then 2
        else 0
        end as criticality : Integer
    };
    entity VendorQuote      as projection on mydb.VendorQuote;
    entity KPIprofile as select from mydb.KPI_profile {
    kpi_id,
    otif_score,
    logistic_cost,
    last_updated,
    vendor.vendor_id    as vendor_id,
    vendor.name         as vendor_name,
    vendor.risk_rating  as vendor_risk_rating,
    vendor.is_compliant as vendor_is_compliant
    };
    @odata.draft.enabled
    entity ProcurementRequest as projection on mydb.ProcurementRequest;
    entity ApprovalLog as projection on mydb.ApprovalLog;
    entity PlannerComment as projection on mydb.PlannerComment;
    entity OptimizationScenario as projection on mydb.OptimizationScenario;
    entity AllocationResult as projection on mydb.AllocationResult;
    entity DecisionOverride as projection on mydb.DecisionOverride;
    entity AgentContext as projection on mydb.AgentContext;
    entity AgentActionLog as projection on mydb.AgentActionLog;
    entity AgentActionReference as projection on mydb.AgentActionReference;
    @odata.draft.enabled
    entity ProcurementIssue as projection on mydb.ProcurementIssue;
    action ResetProcurementRequests() returns Boolean;
    action ResetProcurementIssues() returns Boolean;
}
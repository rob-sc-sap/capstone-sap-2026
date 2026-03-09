using mydb from '../db/schema';

service ProcurementService {
    entity Products         as projection on mydb.Product;
    entity Vendors          as projection on mydb.Vendor;
    entity Countries        as projection on mydb.Country;
    entity Tariffs          as projection on mydb.Tariff;
    entity VendorContracts  as projection on mydb.VendorContract;
    entity PurchaseOrders   as projection on mydb.PurchaseOrder;
    entity VendorQuote      as projection on mydb.VendorQuote;
    entity KPIprofile       as projection on mydb.KPI_profile;
    entity ProcurementRequest as projection on mydb.ProcurementRequest;
    entity ApprovalLog as projection on mydb.ApprovalLog;
    entity PlannerComment as projection on mydb.PlannerComment;
    entity OptimizationScenario as projection on mydb.OptimizationScenario;
    entity AllocationResult as projection on mydb.AllocationResult;
    entity DecisionOverride as projection on mydb.DecisionOverride;
    entity AgentContext as projection on mydb.AgentContext;
    entity AgentActionLog as projection on mydb.AgentActionLog;
    entity AgentActionReference as projection on mydb.AgentActionReference;
}
using { sap.vendoropt.Product, sap.vendoropt.Vendor, sap.vendoropt.ProcurementRequest, sap.vendoropt.VendorContract, sap.vendoropt.KPIProfile, sap.vendoropt.OptimizationScenario, sap.vendoropt.AllocationResult, sap.vendoropt.PlannerComment, sap.vendoropt.DecisionOverride, sap.vendoropt.AgentContext, sap.vendoropt.AgentActionLog } from '../db/schema';

service KeystoneService {
  entity Products              as projection on Product;
  entity Vendors               as projection on Vendor;
  entity ProcurementRequests   as projection on ProcurementRequest;
  entity VendorContracts   as projection on VendorContract;
  entity KPIProfiles       as projection on KPIProfile;
  entity OptimizationScenarios as projection on OptimizationScenario;
  entity AllocationResults as projection on AllocationResult;
  entity PlannerComments as projection on PlannerComment;
  entity DecisionOverrides as projection on DecisionOverride;
  entity AgentContexts as projection on AgentContext;
  entity AgentActionLogs as projection on AgentActionLog;
}
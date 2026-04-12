import cds from '@sap/cds';

export default class ProcurementService extends cds.ApplicationService {
  async init() {
    const {
      Products,
      Vendors,
      Countries,
      Tariffs,
      VendorContracts,
      PurchaseOrders,
      VendorQuote,
      KPIprofile,
      ProcurementRequest,
      ApprovalLog,
      PlannerComment,
      OptimizationScenario,
      AllocationResult,
      DecisionOverride,
      AgentContext,
      AgentActionLog,
      AgentActionReference
    } = this.entities;

    // Products (product_id: Integer)
    this.before('CREATE', Products, async (req) => {
      if (req?.data && (req.data.product_id === undefined || req.data.product_id === null)) {
        const result = await SELECT.one.from(Products).columns('max(product_id) as maxId');
        req.data.product_id = (result?.maxId ?? 0) + 1;
      }
    });

    // Countries
    this.before('CREATE', Countries, async (req) => {
      if (req?.data && (req.data.country_id === undefined || req.data.country_id === null)) {
        const result = await SELECT.one.from(Countries).columns('max(country_id) as maxId');
        req.data.country_id = (result?.maxId ?? 0) + 1;
      }
    });

    // Vendors
    this.before('CREATE', Vendors, async (req) => {
      if (req?.data && (req.data.vendor_id === undefined || req.data.vendor_id === null)) {
        const result = await SELECT.one.from(Vendors).columns('max(vendor_id) as maxId');
        req.data.vendor_id = (result?.maxId ?? 0) + 1;
      }
    });

    // VendorContracts
    this.before('CREATE', VendorContracts, async (req) => {
      if (req?.data && (req.data.contract_id === undefined || req.data.contract_id === null)) {
        const result = await SELECT.one.from(VendorContracts).columns('max(contract_id) as maxId');
        req.data.contract_id = (result?.maxId ?? 0) + 1;
      }
    });

    // VendorQuote
    this.before('CREATE', VendorQuote, async (req) => {
      if (req?.data && (req.data.quote_id === undefined || req.data.quote_id === null)) {
        const result = await SELECT.one.from(VendorQuote).columns('max(quote_id) as maxId');
        req.data.quote_id = (result?.maxId ?? 0) + 1;
      }
    });

    // Tariffs
    this.before('CREATE', Tariffs, async (req) => {
      if (req?.data && (req.data.tariff_id === undefined || req.data.tariff_id === null)) {
        const result = await SELECT.one.from(Tariffs).columns('max(tariff_id) as maxId');
        req.data.tariff_id = (result?.maxId ?? 0) + 1;
      }
    });

    // KPIprofile
    this.before('CREATE', KPIprofile, async (req) => {
      if (req?.data && (req.data.kpi_id === undefined || req.data.kpi_id === null)) {
        const result = await SELECT.one.from(KPIprofile).columns('max(kpi_id) as maxId');
        req.data.kpi_id = (result?.maxId ?? 0) + 1;
      }
    });

    // ProcurementRequest
    this.before('CREATE', ProcurementRequest, async (req) => {
      if (req?.data && (req.data.request_id === undefined || req.data.request_id === null)) {
        const result = await SELECT.one.from(ProcurementRequest).columns('max(request_id) as maxId');
        req.data.request_id = (result?.maxId ?? 0) + 1;
      }
    });

    // ApprovalLog
    this.before('CREATE', ApprovalLog, async (req) => {
      if (req?.data && (req.data.log_id === undefined || req.data.log_id === null)) {
        const result = await SELECT.one.from(ApprovalLog).columns('max(log_id) as maxId');
        req.data.log_id = (result?.maxId ?? 0) + 1;
      }
    });

    // PlannerComment
    this.before('CREATE', PlannerComment, async (req) => {
      if (req?.data && (req.data.comment_id === undefined || req.data.comment_id === null)) {
        const result = await SELECT.one.from(PlannerComment).columns('max(comment_id) as maxId');
        req.data.comment_id = (result?.maxId ?? 0) + 1;
      }
    });

    // OptimizationScenario
    this.before('CREATE', OptimizationScenario, async (req) => {
      if (req?.data && (req.data.scenario_id === undefined || req.data.scenario_id === null)) {
        const result = await SELECT.one.from(OptimizationScenario).columns('max(scenario_id) as maxId');
        req.data.scenario_id = (result?.maxId ?? 0) + 1;
      }
    });

    // AllocationResult
    this.before('CREATE', AllocationResult, async (req) => {
      if (req?.data && (req.data.allocation_id === undefined || req.data.allocation_id === null)) {
        const result = await SELECT.one.from(AllocationResult).columns('max(allocation_id) as maxId');
        req.data.allocation_id = (result?.maxId ?? 0) + 1;
      }
    });

    // DecisionOverride
    this.before('CREATE', DecisionOverride, async (req) => {
      if (req?.data && (req.data.override_id === undefined || req.data.override_id === null)) {
        const result = await SELECT.one.from(DecisionOverride).columns('max(override_id) as maxId');
        req.data.override_id = (result?.maxId ?? 0) + 1;
      }
    });

    // PurchaseOrders (po_id)
    this.before('CREATE', PurchaseOrders, async (req) => {
      if (req?.data && (req.data.po_id === undefined || req.data.po_id === null)) {
        const result = await SELECT.one.from(PurchaseOrders).columns('max(po_id) as maxId');
        req.data.po_id = (result?.maxId ?? 0) + 1;
      }
    });

    // AgentContext
    this.before('CREATE', AgentContext, async (req) => {
      if (req?.data && (req.data.session_id === undefined || req.data.session_id === null)) {
        const result = await SELECT.one.from(AgentContext).columns('max(session_id) as maxId');
        req.data.session_id = (result?.maxId ?? 0) + 1;
      }
    });

    // AgentActionLog
    this.before('CREATE', AgentActionLog, async (req) => {
      if (req?.data && (req.data.action_id === undefined || req.data.action_id === null)) {
        const result = await SELECT.one.from(AgentActionLog).columns('max(action_id) as maxId');
        req.data.action_id = (result?.maxId ?? 0) + 1;
      }
    });

    // AgentActionReference
    this.before('CREATE', AgentActionReference, async (req) => {
      if (req?.data && (req.data.reference_id === undefined || req.data.reference_id === null)) {
        const result = await SELECT.one.from(AgentActionReference).columns('max(reference_id) as maxId');
        req.data.reference_id = (result?.maxId ?? 0) + 1;
      }
    });

    return super.init();
  }
}


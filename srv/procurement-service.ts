import cds from '@sap/cds';

export default class ProcurementService extends cds.ApplicationService {
  async init() {
    const { PurchaseOrders } = this.entities;

    // Before CREATE handler to generate unique po_id
    this.before('CREATE', PurchaseOrders, async (req) => {
      if (!req.data.po_id) {
        // Query for the maximum existing po_id
        const result = await SELECT.one
          .from(PurchaseOrders)
          .columns('max(po_id) as maxId');
        
        // Generate new ID: max + 1, or 1 if no records exist
        req.data.po_id = (result?.maxId ?? 0) + 1;
      }
    });

    return super.init();
  }
}
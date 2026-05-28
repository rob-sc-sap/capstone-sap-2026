using ProcurementService as service from '../../srv/procurement-service';
annotate service.PurchaseOrders with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'po_id',
                Value : po_id,
            },
            {
                $Type : 'UI.DataField',
                Label : 'status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_pdf',
                Value : po_pdf,
            },
            {
                $Type : 'UI.DataField',
                Label : 'expected_delivery_date',
                Value : expected_delivery_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'received_date',
                Value : received_date,
            },
            {
                $Type : 'UI.DataField',
                Label : 'disruption_reason',
                Value : disruption_reason,
            },
            {
                $Type : 'UI.DataField',
                Label : 'product_quantity',
                Value : product_quantity,
            },
            {
                $Type : 'UI.DataField',
                Label : 'po_total',
                Value : po_total,
            },
            {
                $Type : 'UI.DataField',
                Label : 'allocation_allocation_id',
                Value : allocation_allocation_id,
            },
            {
                $Type : 'UI.DataField',
                Label : 'product_product_id',
                Value : product_product_id,
            },
            {
                $Type : 'UI.DataField',
                Label : 'vendor_vendor_id',
                Value : vendor_vendor_id,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Purchase Order ID',
            Value : po_id,
            Criticality : criticality,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
            Criticality : criticality,
        },
        {
            $Type : 'UI.DataField',
            Label : 'PDF',
            Value : po_pdf,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Expected Delivery Date',
            Value : expected_delivery_date,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Received Date',
            Value : received_date,
        },
    ],
);

annotate service.PurchaseOrders with {
    allocation @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'AllocationResult',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : allocation_allocation_id,
                ValueListProperty : 'allocation_id',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'allocated_quantity',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'total_effective_cost',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'rationale_summary',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'created_at',
            },
        ],
    }
};

annotate service.PurchaseOrders with {
    product @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Products',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : product_product_id,
                ValueListProperty : 'product_id',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'category',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'safety_stock_level',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'current_stock_level',
            },
        ],
    }
};

annotate service.PurchaseOrders with {
    vendor @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Vendors',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : vendor_vendor_id,
                ValueListProperty : 'vendor_id',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'risk_rating',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'is_compliant',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'contact_name',
            },
        ],
    }
};


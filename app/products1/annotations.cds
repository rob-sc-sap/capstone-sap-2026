using ProcurementService as service from '../../srv/procurement-service';
annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'product_id',
                Value : product_id,
            },
            {
                $Type : 'UI.DataField',
                Label : 'name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'category',
                Value : category,
            },
            {
                $Type : 'UI.DataField',
                Label : 'safety_stock_level',
                Value : safety_stock_level,
            },
            {
                $Type : 'UI.DataField',
                Label : 'current_stock_level',
                Value : current_stock_level,
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
            Label : 'product_id',
            Value : product_id,
        },
        {
            $Type : 'UI.DataField',
            Label : 'name',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'category',
            Value : category,
        },
        {
            $Type : 'UI.DataField',
            Label : 'safety_stock_level',
            Value : safety_stock_level,
        },
        {
            $Type : 'UI.DataField',
            Label : 'current_stock_level',
            Value : current_stock_level,
            Criticality : criticality,
        },
    ],
);


using ProcurementService as service from '../../srv/procurement-service';

annotate service.KPIprofile with @(

    // ─── OBJECT PAGE FIELD GROUPS ───────────────────────────────

    UI.FieldGroup #KPIDetails : {
        $Type : 'UI.FieldGroupType',
        Label : 'KPI Details',
        Data  : [
            {
                $Type : 'UI.DataField',
                Label : 'KPI ID',
                Value : kpi_id,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OTIF Score',
                Value : otif_score,
                Criticality : criticality,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Logistic Cost',
                Value : logistic_cost,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Last Updated',
                Value : last_updated,
            },
        ],
    },

    UI.FieldGroup #VendorInfo : {
        $Type : 'UI.FieldGroupType',
        Label : 'Vendor Information',
        Data  : [
            {
                $Type : 'UI.DataField',
                Label : 'Vendor ID',
                Value : vendor_id,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Vendor Name',
                Value : vendor_name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Risk Rating',
                Value : vendor_risk_rating,
                Criticality : criticality,   // reuse criticality for color coding
            },
            {
                $Type : 'UI.DataField',
                Label : 'Compliant',
                Value : vendor_is_compliant,
            },
        ],
    },

    // ─── OBJECT PAGE FACETS (tabs/sections) ─────────────────────

    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'KPIDetailsFacet',
            Label  : 'KPI Details',
            Target : '@UI.FieldGroup#KPIDetails',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'VendorInfoFacet',
            Label  : 'Vendor Information',
            Target : '@UI.FieldGroup#VendorInfo',
        },
    ],

    // ─── LIST REPORT TABLE COLUMNS ──────────────────────────────

    UI.LineItem :  [
        {
            $Type : 'UI.DataField',
            Label : 'KPI ID',
            Value : kpi_id,
            Criticality : criticality,
        },
        {
            $Type : 'UI.DataField',
            Label : 'OTIF Score',
            Value : otif_score,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Logistic Cost',
            Value : logistic_cost,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Last Updated',
            Value : last_updated,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Vendor',
            Value : vendor_name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Risk Rating',
            Value : vendor_risk_rating,
        },
        {
            $Type       : 'UI.DataField',
            Label       : 'Compliant',
            Value       : vendor_is_compliant,
        },
    ],
   ![@UI.Criticality] : criticality,
);
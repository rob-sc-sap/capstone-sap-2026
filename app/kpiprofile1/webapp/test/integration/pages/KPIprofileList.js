sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'kpiprofile1',
            componentId: 'KPIprofileList',
            contextPath: '/KPIprofile'
        },
        CustomPageDefinitions
    );
});
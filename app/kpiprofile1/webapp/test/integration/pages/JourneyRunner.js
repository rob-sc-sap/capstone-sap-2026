sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"kpiprofile1/test/integration/pages/KPIprofileList",
	"kpiprofile1/test/integration/pages/KPIprofileObjectPage"
], function (JourneyRunner, KPIprofileList, KPIprofileObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('kpiprofile1') + '/test/flp.html#app-preview',
        pages: {
			onTheKPIprofileList: KPIprofileList,
			onTheKPIprofileObjectPage: KPIprofileObjectPage
        },
        async: true
    });

    return runner;
});


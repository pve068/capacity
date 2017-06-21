"use strict";

describe("leg api service", function () {
    var legService, urlService, httpBackend;
    var baseUrl;


    beforeEach(module('capx'));

    beforeEach(inject(function (_legService_, _urlService_, $httpBackend) {
        legService = _legService_;
        urlService = _urlService_;
        baseUrl = urlService.getBaseUrl();

        httpBackend = $httpBackend;
    }));
    

    it("should exist", function () {
        expect(legService).toBeDefined();
        expect(urlService).toBeDefined();
    });

    it("should return legs over and under capacity within 13 weeks", function () {
        httpBackend.whenGET(baseUrl + '84kn').respond(
            [{
                    "week": 3,
                    "undercapacity": 213,
                    "overcapacity": 129
                },
                {
                    "week": 4,
                    "undercapacity": 116,
                    "overcapacity": 269
                },
                {
                    "week": 5,
                    "undercapacity": 138,
                    "overcapacity": 190
                },
                {
                    "week": 6,
                    "undercapacity": 246,
                    "overcapacity": 165
                },
                {
                    "week": 10,
                    "undercapacity": 161,
                    "overcapacity": 152
                }
            ]
        );

        legService.getLegsByService('84kn').then(function (legs) {
            expect(legs.length).toEqual(5);
        });
        httpBackend.flush();
    });

    it("should return critical legs for service and week", function () {
        httpBackend.whenGET(baseUrl + '84kn/5').respond(
            [{
                "leg": "B-C",
                "vessel": "28B-1712",
                "dd": ["freesale", "commitment", "empties", "overbooking", "MSK"],
                "teu": [1415, 1128, 1207, 1488, 1046],
                "mts": [1833, 1944, 1706, 1334, 1905],
                "plugs": [1852, 1556, 1002, 1846, 1279]
            }, {
                "leg": "E-F",
                "vessel": "28B-1712",
                "dd": ["freesale", "commitment", "empties", "overbooking", "MSK"],
                "teu": [1121, 1439, 1544, 1919, 1383],
                "mts": [1129, 1309, 1603, 1604, 1527],
                "plugs": [1466, 1465, 1339, 1397, 1438]
            }, {
                "leg": "E-F",
                "vessel": "28B-1712",
                "dd": ["freesale", "commitment", "empties", "overbooking", "MSK"],
                "teu": [1844, 1662, 1479, 1736, 1389],
                "mts": [1382, 1088, 1983, 1717, 1908],
                "plugs": [1612, 1694, 1912, 1020, 1870]
            }, {
                "leg": "C-D",
                "vessel": "25B-1710",
                "dd": ["freesale", "commitment", "empties", "overbooking", "MSK"],
                "teu": [1873, 1940, 1363, 1360, 1566],
                "mts": [1054, 1454, 1193, 1429, 1231],
                "plugs": [1644, 1302, 1153, 1531, 1764]
            }]
        );

        legService.getLegsByWeek('84kn', '5').then(function (legs) {
            expect(legs.length).toEqual(4);
        });

        httpBackend.flush();
    });

    it("should return the units of measurement", function () {
        httpBackend.whenGET(baseUrl + 'listunits/').respond(['mts', 'teu', 'plugs']);
        legService.listUnits().then(function (units) {
            expect(units.length).toEqual(3);
        });
        httpBackend.flush();
    });
});
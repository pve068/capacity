angular.module('capx').factory(
    'chartMetaService', [function () {
        return ({
            getColors: getGenericColors,
            getOptions: getGenericOptions,
        });


        function getGenericOptions(unit) {
            return {
                legend: {
                    display: true,
                    fontFamily: 'ZettasSans'
                },
                title: {
                    display: true,
                    text: 'In ' + unit,
                    fontFamily: 'ZettasSans',
                    fontSize: 16
                },
                scales: {
                    yAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: unit.toUpperCase(),
                            fontFamily: 'ZettasSans'
                        },
                        stacked: true
                    }],
                    xAxes: [{
                        scaleLabel: {
                            display: true,
                            labelString: 'Leg',
                            fontFamily: 'ZettasSans'
                        },
                        stacked: true
                    }]
                }
            };
        }

        function getGenericColors() {
            return [{
                backgroundColor: 'rgba(105, 184, 214, 0.6)',
                borderColor: 'rgba(105, 184, 214, 1.0)',
                borderWidth: 1
            }, {
                backgroundColor: 'rgba(0, 78, 107,0.6)',
                borderColor: 'rgba(0, 78, 107,1.0)',
                borderWidth: 1
            }, {
                backgroundColor: 'rgba(252, 185, 28,0.6)',
                borderColor: 'rgba(252, 185, 28,1.0)',
                borderWidth: 1
            }, {
                backgroundColor: 'rgba(66, 155, 69,0.6)',
                borderColor: 'rgba(66, 155, 69,1.0)',
                borderWidth: 1
            }, {
                backgroundColor: 'rgba(181, 0, 48, 0.6)',
                borderColor: 'rgba(181, 0, 48, 1.0)',
                borderWidth: 1
            }, {
                backgroundColor: 'rgba(255, 117,7,0.6)',
                borderColor: 'rgba(255, 117,7,1.0)',
                borderWidth: 1
            }];
        }
    }]);
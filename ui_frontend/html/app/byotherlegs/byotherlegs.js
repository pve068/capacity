'use strict';
angular.module('capx').component('byotherlegs', {
    templateUrl: 'byotherlegs/byotherlegs.template.html',
    controller: ByOtherlegsController,
    controllerAs: 'vm',
});

function ByOtherlegsController($filter, $state, $stateParams, chartMetaService) {
    var vm = this;

    vm.$onInit = function () {
        if ($stateParams.other_consumption === null) {
            $state.go('^');
        } else {
            render(vm, $stateParams.other_consumption);
        }
    }

    function render(vm, data) {
        var chartUnits = ["teu", "mts", "plugs"];
        vm.chart = {};
        var sortedList = $filter('orderBy')(data, 'leg_date');
        for (var i = 0; i < chartUnits.length; i++) {
            var unit = chartUnits[i];
            vm.chart[unit] = initVariables(unit);
            var iObj = initData(sortedList, unit);
            vm.chart[unit].labels = iObj.labels;
            vm.chart[unit].data = iObj.data;
            vm.chart[unit].datasetOverride = iObj.datasetOverride;
        }

    }

    function createChart(unit) {
        vm.chart[unit] = initVariables(unit);
        vm.chart[unit].data = initData();
    }

    function initVariables(unit) {
        var generic = {
            type: "StackedBar",
            options: chartMetaService.getOptions(unit),
            colors: chartMetaService.getColors()
        }
        generic.options.scales.xAxes[0].scaleLabel.labelString = "Departing date of the leg";
        return generic;
    }

    function splitLabel(label, splitter) {
        return label.indexOf(splitter) !== -1 ? label.split(splitter) : label;
    }

    function generateDataOrder(original, desired) {
        var indexList = [];
        for (var i in desired) {
            indexList.push(original.indexOf(desired[i]));
        }
        return indexList;
    }

    function initData(sortedList, unit) {
        var labels = [];
        var dataDefinition = ["msk", "overbooking", "other", "focus"];
        var dataOrder = generateDataOrder(sortedList[0].dd, dataDefinition);
        // var dataDefinitionIndex = [0,1,3,4];
        var datasets = [];
        var datasetOverride = [];
        for (var i = 0; i < dataDefinition.length; i++) {
            if (dataDefinition[i] === "msk" || dataDefinition[i] === "overbooking") {
                datasetOverride.push({
                    "label": dataDefinition[i],
                    "stack": "capacity",
                    "type": "bar"
                });
            } else {
                datasetOverride.push({
                    "label": dataDefinition[i],
                    "stack": "consumption",
                    "type": "bar"
                });
            }
        }
        for (var i = 0; i < dataOrder.length; i++) {
            datasets[i] = [];
            for (var j = 0; j < sortedList.length; j++) {
                datasets[i].push(+sortedList[j][unit][dataOrder[i]]);
            }
        }
        for (var k = 0; k < sortedList.length; k++) {
            var d = new Date(sortedList[k].leg_date)
            labels.push(d.toISOString().substring(0, 10));
        }
        return {
            labels: labels,
            data: datasets,
            datasetOverride: datasetOverride
        };
    }
}
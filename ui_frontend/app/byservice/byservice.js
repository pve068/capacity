'use strict';

angular.module('capx')
    .component('byservice', {
        templateUrl: "byservice/byservice.template.html",
        controller: ByServiceController,
        controllerAs: "vm",
    });

function ByServiceController($filter, $state, $stateParams, chartMetaService) {
    var vm = this;

    vm.$onInit = function () {
        var chartUnits = ["teu", "mts", "plugs"];
        if ($stateParams.data === null) {
            $state.go('^');
        } else {
            vm.chart = {};
            var sortedList = $filter('orderBy')($stateParams.data, 'week', true);
            for (var i = 0; i < chartUnits.length; i++) {
                var unit = chartUnits[i];
                vm.chart[unit] = initVariables(unit);
                var iObj = initData(sortedList, unit);
                vm.chart[unit].labels = iObj.labels;
                vm.chart[unit].data = iObj.data;
                vm.chart[unit].datasetOverride = iObj.datasetOverride;
            }
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
        generic.options.scales.xAxes[0].scaleLabel.labelString = "Weeks to departure";
        return generic;
    }

    function splitLabel(label, splitter) {
        return label.indexOf(splitter) !== -1 ? label.split(splitter) : label;
    }

    function generateDataOrder(original, desired){
        var indexList = [];
        for (var i in desired){
            indexList.push(original.indexOf(desired[i]));
        }
        return indexList;
    }

    function initData(sortedList, unit) {
        var labels = [];
        var dataDefinition = ["msk", "overbooking","total_consumption"];
        var dataOrder = generateDataOrder(sortedList[0].dd, dataDefinition);
        
        var datasets = [];
        var datasetOverride = [];
        for (var i = 0; i < dataDefinition.length; i++) {
            if (dataDefinition[i] === "msk" || dataDefinition[i] === "overbooking") {
                datasetOverride.push({
                    "label": dataDefinition[i],
                    "stack": "capacity",
                    "type": "bar"
                });
            } else if (dataDefinition[i] === "total_consumption") {
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
            labels.push(sortedList[k].week);
        }
        return {
            labels: labels,
            data: datasets,
            datasetOverride: datasetOverride
        };
    }
}
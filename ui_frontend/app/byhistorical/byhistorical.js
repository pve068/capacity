'use strict';
angular.module('capx').component('byhistorical', {
    templateUrl: 'byhistorical/byhistorical.template.html',
    controller: ByHistoricalController,
    controllerAs: 'vm',
});

function ByHistoricalController($filter, $state, $stateParams, chartMetaService) {
    var vm = this;
    vm.$onInit = function () {
        if ($stateParams.historical_consumption=== null) {
            $state.go('^');
        } else {
            render(vm, $stateParams.historical_consumption);
        }
    }

    function render(vm, data) {
        var chartUnits = ["teu", "mts", "plugs"];
        vm.chart = {};
        var sortedList = $filter('orderBy')(data.consumption, 'vv_date', true);
        for (var i = 0; i < chartUnits.length; i++) {
            var unit = chartUnits[i];
            vm.chart[unit] = initVariables(unit);
            var iObj = initData(sortedList, unit);
            vm.chart[unit].labels = iObj.labels;
            vm.chart[unit].data = [iObj.data];
            vm.chart[unit].series = ['Total Consumption'];
        }
    }

    function initVariables(unit) {
        var generic = {
            type: "line",
            options: chartMetaService.getOptions(unit),
            colors: chartMetaService.getColors()
        };
        generic.options.scales.yAxes.stacked = false;
        generic.options.scales.xAxes.stacked = false;
        generic.colors[0].backgroundColor = 'rgba(255,255,255,0.1)';
        generic.options.scales.xAxes[0].scaleLabel.labelString = "Weeks to departure";

        return generic;
    }

    function initData(sortedList, unit) {
        var labels = [];
        var data = [];
        var colors = [];
        for (var i = 0; i < sortedList.length; i++) {
            labels.push(sortedList[i].week + "");
            data.push(+sortedList[i][unit][0]);
        }
        return {
            labels: labels,
            data: data,
            colors: colors
        };
    }

}
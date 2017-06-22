'use strict';
angular.module('capx').component('customuboat', {
    templateUrl: 'customuboat/customuboat.template.html',
    controller: CustomUboatController,
    controllerAs: 'vm',
    bindings: {
        unit: '@',
        definition: '=',
        data: '='
    }
});

function CustomUboatController() {
    var vm = this;

    vm.freesale_length = -1;
    vm.commits_length = -1;

    vm.freesale_box_color = null;
    vm.commits_box_color = null;


    vm.$onInit = function () {
        var pc = getPercentages(vm.definition, vm.data);
        vm.freesale_length = Math.round(pc.freesale_percentage * 12 === 12? 11: pc.freesale_percentage * 12);
        vm.commits_length = 12 - vm.freesale_length;

        vm.freesale_box_color = pc.freesale_box_color;
        vm.freesale_box_height = Math.round(pc.freesale_box_height);

        vm.commits_box_color = pc.commits_box_color;
        vm.commits_box_height = Math.round(pc.commits_box_height);

        vm.overbooking_box_color = pc.overbooking_box_color;
        vm.overbooking_box_height = Math.round(pc.overbooking_box_height);

        vm.freesale_tooltip = "Freesale Consumption: "+pc.freesale_consumption+", Freesale Allocation: "+pc.freesale_available;
        vm.commits_tooltip = "Commitment Consumption: "+pc.commitment_consumption+", Commitment Allocation"+pc.commitment_allocation;
    };

    function getPercentages(definition, data) {
        var index = mapIndex(definition);
        var total_allocation = (data[index.freesale_available] + data[index.commitment_allocation]) * 1.0;
        var commits_filled = (data[index.commitment_consumption] * 100.0)/ (data[index.commitment_allocation]);
        var freesale_filled = (data[index.freesale_consumption] * 100.0)/ (data[index.freesale_available] - data[index.overbooking]);
        
        var overbooking_consumption = (data[index.freesale_consumption] - (data[index.freesale_available] -  data[index.overbooking]));
        overbooking_consumption = overbooking_consumption < 0? 0: overbooking_consumption;
        var overbooking_filled = overbooking_consumption * 100.0 / data[index.overbooking];

        return {
            freesale_available: data[index.freesale_available],
            freesale_consumption: data[index.freesale_consumption],
            commitment_allocation: data[index.commitment_allocation],
            commitment_consumption: data[index.commitment_consumption],
            freesale_percentage : data[index.freesale_available] / total_allocation,
            commitment_percentage : data[index.commitment_allocation] / total_allocation,
            
            freesale_box_height: freesale_filled >= 100? 100: freesale_filled,
            freesale_box_color: getBoxColor(data[index.freesale_consumption]/data[index.freesale_available]),

            commits_box_color: getBoxColor(data[index.commitment_consumption] / data[index.commitment_allocation]),
            commits_box_height: commits_filled >= 100? 100: commits_filled,

            overbooking_box_height: overbooking_filled >= 100? 100: overbooking_filled,
            overbooking_box_color: getBoxColor(overbooking_consumption/data[index.overbooking]),
        };
    }

    function getBoxColor(percentage){
        return percentage > 1? "red": percentage > 0.6? "green": "yellow";
    }

    function mapIndex(definition) {
        var idx = {
            freesale_consumption: definition.indexOf('freesale_consumption'),
            freesale_available: definition.indexOf('freesale_available'),
            commitment_consumption: definition.indexOf('commitment_consumption'),
            commitment_allocation: definition.indexOf('commitment_allocation'),
            overbooking: definition.indexOf('overbooking'),
        };
        return idx;
    }
}
'use strict';
angular.module('capx').component('byuboat', {
    templateUrl: 'byuboat/byuboat.template.html',
    controller: ByUboatController,
    controllerAs: 'vm',
});

function ByUboatController($filter, $state, $stateParams, chartMetaService) {
    var vm = this;

    vm.$onInit = function () {
        if ($stateParams.uboat_consumption === null) {
            $state.go('^');
        } else {
            initVars(vm);
            render(vm, $stateParams.uboat_consumption);
        }
    }

    function initVars(vm) {
        vm.uboat = {
            teu: {},
            mts: {},
            plugs: {}
        }
    }

    function render(vm, data) {
        vm.uboat.teu.dd = vm.uboat.mts.dd = vm.uboat.plugs.dd = data.dd;
        vm.uboat.teu.data = data.teu;
        vm.uboat.mts.data = data.mts;
        vm.uboat.plugs.data = data.plugs;
    }
}
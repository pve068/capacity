'use strict';

angular.module('capx')
    .component('byleg', {
        templateUrl: "byleg/byleg.template.html",
        controller: ByLegController,
        controllerAs: "vm",
    });

function ByLegController($state, $stateParams, legService) {
    var vm = this;
    vm.$onInit = function () {
        if (checkState()) {
            $state.go('^');
        } else {
            vm.details = $stateParams.details;
            vm.loadHistorical();
        }
    };

    function checkState() {
        return ($stateParams.details === undefined || $stateParams.details === null);
    }

    vm.loadOtherlegs = function () {
        if (checkState()) {
            $state.go('^');
        } else {
            legService.getComparisonByLeg(vm.details.serviceid, vm.details.weekid, vm.details.vv, vm.details.leg).then(function (data) {
                $state.go('capacity.byleg.otherlegs', {
                    other_consumption: data
                });
            });
        }
    };

    vm.loadHistorical = function () {
        if (checkState()) {
            $state.go('^');
        } else {
            legService.getHistoryByLeg(vm.details.serviceid, vm.details.weekid, vm.details.vv, vm.details.leg).then(function (data) {
                $state.go('capacity.byleg.historical', {
                    historical_consumption: data
                });
            });
        }
    };

    vm.loadUboat = function () {
        if (checkState()) {
            $state.go('^');
        } else {
            legService.getUboat(vm.details.serviceid, vm.details.weekid, vm.details.vv, vm.details.leg).then(function (data) {
                $state.go('capacity.byleg.uboat', {
                    uboat_consumption: data
                });
            });
        }
    };
}
'use strict';

angular.module('capx')
    .component('capacity', {
        templateUrl: "capacity/capacity.template.html",
        controller: capacityController,
        controllerAs: "vm"
    });

function capacityController($state, $modal, legService) {
    var vm = this;

    vm.selectedService = null;
    vm.selectedServiceChanged = false;
    vm.selectedWeek = -1;
    vm.selectedWeekChanged = false;
    vm.selectedLeg = null;
    vm.selectedLegChanged = false;
    vm.selectedVV = null;

    vm.showVVModal = false;

    vm.services = [];
    vm.weeks = [];
    vm.legs = []
    vm.vv = []

    vm.disableRender = vm.disableVVList = vm.disableWeeksList = vm.disableLegsList = true;

    vm.showVVModal = function () {
        /// TODO: change this to template based rather than hardcoded
        var modalInstance = $modal.open({
            template: '<div class="row"><div class="text-center"><h3>Missing Vessel-Voyage</h3></div></div>\
            <div class="row"><div class="text-center">The vessel voyage needs to be selected before any charts can be rendered.</div></div> \
            <div class="row"><div class="text-center"><button class="button info small" ng-click="ok()">OK</button></div></div>',
            controller: ['$scope', '$modalInstance', function ($scope, $modalInstance) {
                $scope.ok = function () {
                    $modalInstance.close();
                }
            }],
            resolve: {}
        });
        return modalInstance;
    }

    vm.$onInit = function () {
        legService.listServices().then(function (services) {
            vm.services = services;
        });
    }

    vm.fetchWeeks = function () {
        vm.disableRender = vm.disableWeeksList = !(vm.selectedService !== null && vm.selectedService.id !== undefined); /// TODO: depending on the id we'll need to change this condition
        vm.weeks = legService.listWeeks(vm.selectedService.id);
        //vm.selectedServiceChanged = true;
        vm.disableLegsList = vm.selectedServiceChanged;
    }

    vm.fetchVV = function () {
        vm.disableVVList = !(vm.selectedWeek && vm.selectedWeek > -1);
        legService.listVV(vm.selectedService.id, vm.selectedWeek).then(function (vv) {
            vm.vv = vv;
        });
    }

    vm.fetchLegs = function () {
        vm.disableLegsList = !(!vm.disableVVList && vm.selectedVV && vm.selectedVV !== null);
        legService.getLegsByVV(vm.selectedService.id, vm.selectedWeek, vm.selectedVV.id).then(function (legs) {
            vm.legs = legs;
            vm.selectedSerivceChanged = false;
        });
        //vm.selectedWeekChanged = true;
    }

    vm.loadState = function () {
        // The strategy is to climb the if-else ladder in a bottom-up fasion, as opposed to top down
        // so that its easier to handle all the cases
        if (vm.selectedLeg !== null) {
            var data = {
                "serviceid": vm.selectedService.id,
                "weekid": vm.selectedWeek,
                "vv": vm.selectedVV.id,
                "leg": vm.selectedLeg.legseq_id
            }
            // legService.getAllByLeg(vm.selectedService.id, vm.selectedWeek, vm.selectedVV.id, vm.selectedLeg.legseq_id).then(function (data) {
            $state.go('capacity.byleg', {
                details: data
            });
            // });
        } else if (vm.selectedVV !== null) {
            legService.getLegsByVV(vm.selectedService.id, vm.selectedWeek, vm.selectedVV.id).then(function (data) {
                $state.go('capacity.byweek', {
                    data: data
                });
            });
        } else if (vm.selectedWeek > 0) {
            vm.showVVModal();
        } else if (vm.selectedService.id !== null) {
            legService.getLegsByService(vm.selectedService.id).then(function (data) {
                $state.go('capacity.byservice', {
                    data: data
                });
            });
        }
        /// TODO: the default condition has not yet been specified. 
    }
}
'use strict';

angular.module('capx')
    .component('home', {
        templateUrl: "home/home.template.html",
        controller: homeController,
        controllerAs: "vm"
    });

function homeController(legService, prefService) {
    var vm = this;

    vm.selectedService = null;
    vm.selectedServiceChanged = false;
    vm.selectedWeek = -1;
    vm.selectedWeekChanged = false;
    vm.selectedLeg = null;
    vm.selectedLegChanged = false;

    vm.services = [];
    vm.weeks = [];
    vm.legs = []

    vm.disableRender = vm.disableWeeksList = vm.disableLegsList = true;

    vm.$onInit = function () {
        legService.listServices().then(function (services) {
            vm.services = services;
        });
    }

    vm.fetchWeeks = function () {
        vm.disableRender = vm.disableWeeksList = !(vm.selectedService != null && vm.selectedService.id > 0); /// TODO: depending on the id we'll need to change this condition
        vm.weeks = legService.listWeeks();
        //vm.selectedServiceChanged = true;
        vm.disableLegsList = vm.selectedServiceChanged;
    }

    vm.fetchLegs = function () {
        vm.disableLegsList = !(vm.selectedWeek && vm.selectedWeek > -1);
        legService.getLegsByWeek(vm.selectedService, vm.selectedWeek).then(function (legs) {
            vm.legs = legs;
            for (var i = 0; i < legs.length; i++) vm.legs[i].id = i;
            vm.selectedSerivceChanged = false;
        });
        //vm.selectedWeekChanged = true;
    }

    vm.loadState = function () {
        if (vm.selectedService !== null && vm.selectedWeek === -1 && vm.selectedLeg === null) {
            legService.getLegsByService(vm.selectedService).then(function (data) {
                $state.go('capacity.byservice', {
                    data: data
                });
            });
        } else if (vm.selectedService !== null && vm.selectedWeek !== -1 && vm.selectedLeg === null) {
            if (vm.legs.length > 0) {
                $state.go('capacity.byweek', {
                    data: vm.legs
                });
            } else {
                legService.getLegsByWeek(vm.selectedService.id, vm.selectedWeek).then(function (data) {
                    $state.go('capacity.byweek', {
                        data: data
                    });
                });
            }
        } else {
            legService.getAllByLeg(vm.selectedService.id, vm.selectedWeek, vm.selectedLeg).then(function (data) {
                $state.go('capacity.byleg', {
                    data: data
                });
            });
        }
    }
}
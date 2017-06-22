'use strict';

angular.module('capx')
    .component('home', {
        templateUrl: "home/home.template.html",
        controller: homeController,
        controllerAs: "vm"
    });

function homeController(legService, prefService) {
    var vm = this;

    vm.$onInit = function() {
        vm.dataAvailable = [];
        legService.getPreferredServices().then(function(dataset) {
            vm.preferredServices = dataset;
            vm.serviceDetails = {};
            vm.idpairs = getPairs(vm.preferredServices);
            // for (var i = 0; i < dataset.length-1; i++) {

            vm.preferredServices.forEach(function(element) {
                legService.getServiceDetails(element.id).then(function(ui_data) {
                    vm.serviceDetails[element.id] = ui_data;
                    vm.dataAvailable.push(element.id);
                });

            }, this);
            //var id = dataset[]
        });
    };

    function getPairs(dataset) {
        var res = [];
        if (dataset === undefined || dataset.length === 0) {
            return res;
        }
        for (var i = 0; i < dataset.length - 1; i += 2) {
            res.push([dataset[i].id, dataset[i + 1].id]);
        }
        if ((dataset.length % 2) == 1) {
            res.push([dataset[dataset.length - 1]])
        }
        return res;
    }
}
'use strict';
angular.module('capx').component('customtubemap', {
    templateUrl: 'customtubemap/customtubemap.template.html',
    controller: CustomTubemapController,
    controllerAs: 'vm',
    bindings: {
        title: '=',
        data: '=',
        showgrids: '@'
    }
});

function CustomTubemapController() {
    var vm = this;

    /** When the user firt loads the page with the tubemap,
     * all the categories should be "visible" by default. This 
     * functtion precisely does that
     * 
     * @param {object} vm - The self object
     * @param {object} ui_data - The json data from the endpoint
     */
    function resetCategories(vm, ui_data) {
        vm.selections = {};
        for (var i = 0; i < ui_data.categories.length; i++) {
            vm.selections[ui_data.categories[i]] = "visible";
        }
    }

    /** Used to preprocess the incoming ui_data and extract the 
     * spacings and get the valid indices.
     * 
     * @param {object} ui_data - The json data from the endpoint
     */
    function preprocess(ui_data, validCondition) {
        for (var i = 0; i < ui_data.vvs.length; i++) {
            ui_data.vvs[i].spacings = getSpacings(ui_data.vvs[i].skip, validCondition);
            ui_data.vvs[i].indices = getValidIndices(ui_data.vvs[i].skip, validCondition);
        }
    }

    /** Get the spacings between the two points for all the points. 
     * This is required because many times a port might be skipped by
     * a vessel voyage.
     * 
     * @param {object} ui_data - The json data from the endpoint
     */
    function getSpacings(ui_data, validCondition) {
        var counter = 1;
        var result = [];
        for (var i = 0; i < ui_data.length; i++) {
            if (ui_data[i] !== validCondition) {
                counter++;
            } else {
                result.push(counter);
                counter = 1;
            }
        }
        result = result.slice(1, result.length);
        return result;
    }

    function getValidIndices(ui_data, validCondition) {
        var result = [];
        for (var i = 0; i < ui_data.length; i++) {
            if (ui_data[i] === validCondition) {
                result.push(i);
            }
        }
        result.pop();
        return result;
    }

    function initVariables(vm, ui_data) {
        vm.fontSize = 12;
        vm.counter = 50;
        vm.xOffset = 20;
        vm.yOffset = 50;

        vm.ySpacing = 25;
        vm.xSpacing = 75;

        vm.markerStrokeColor = "rgba(38,38,38,0.6)";
        vm.markerFillColor = "white";
        vm.markerRadius = 5;
        vm.markerStrokeWidth = 3;

        vm.tubeStrokeWidth = 3;

        vm.canvasHeight = vm.yOffset + ui_data.vvs.length * vm.ySpacing + 50;
        vm.canvasWidth = vm.xOffset + ui_data.ports.length * vm.xSpacing;

        vm.gridStrokeColor = "rgb(237,237,237)";
        vm.gridStrokeWidth = "1px";
        vm.gridVisibility = vm.showgrids === "false"? "hidden":"visible";

        vm.serviceid = vm.title;
        vm.ports = ui_data.ports;
        vm.vvs = ui_data.vvs;
        vm.categories = ui_data.categories;
    }


    vm.$onInit = function() {
        if (vm.data) {
            preprocess(vm.data, 1);
            resetCategories(vm, vm.data);
            initVariables(vm, vm.data);
        }
    };

}
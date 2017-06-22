"use strict";
angular.module('capx').factory(
    'prefService', ['$http', '$q', '$log', 'urlService',
        function ($http, $q, $log, urlService) {
            return ({
                getServices: getServiceList,
                addService: addService,
            });

            /**
             * Returns the base url. 
             */
            function getBaseUrl() {
                return urlService.getBaseUrl();
            }

            /**
             * Returns the list of preferred services that the user wants to 
             * keep track of
             */
            function getServiceList() {

            }

            /**
             * Adds a service to the list of preferred services
             * @param {string} serviceId - The service id of the preferred service
             */
            function addService(serviceId) {

            }

            /**
             * Removes a service from the preferred list
             * @param {string} serviceId - The service id of the undesired service
             */
            function removeService(serviceId) {}
        }
    ]);
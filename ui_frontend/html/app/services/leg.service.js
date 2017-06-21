angular.module('capx').factory(
    'legService', ['$http', 'helperService', 'urlService', function ($http, helperService, urlService) {
        return ({
            listWeeks: listWeeks,
            listServices: listServices,
            listUnits: listUnits,
            listVV: listVV,
            getLegsByService: getLegsByService,
            getVVByWeek: listVV,
            getLegsByVV: getLegsByVV,
            getComparisonByLeg: getComparisonByLeg,
            getUboat: getUboat,
            getHistoryByLeg: getHistoryByLeg
        });

        /**
         * Returns the base url. 
         */
        function getBaseUrl() {
            return urlService.getBaseUrl();
        }

        /**
         * List all the units of measurements 
         */
        function listUnits() {
            var request = $http({
                method: 'get',
                url: getBaseUrl() + "listunits/"
            });
            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }

        /**
         * List all the unique services to populate the dropdown box
         */
        function listServices() {
            var request = $http({
                method: 'get',
                url: getBaseUrl() + "allservicedirections"
            });
            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }

        /** Technically yes, we sure can get away with returning and array of 0-13
         * in the calling function. The main reason for doing this is to ensure that
         * there's only one point of failure - eg. when the week changes to 1-13 or
         * 1-5 or whatever
         */
        function listWeeks(serviceId) {
            var v = [];
            for (var i = 0; i < 14; i++) v.push(i);
            return v;
        }

        /** Fetches all the vessel voyages departing in the given week along with teh service id
         * @param {string} serviceId - The id of the service
         * @param {int} week - The week of the voyage departure
         */
        function listVV(serviceId, week) {
            var request = $http({
                method: 'get',
                url: getBaseUrl() + serviceId + "/" + week
            });
            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }


        /** 
         * Fetches all the critical legs for the given service id.
         * @param {string} serviceId - All the critical legs will be pulled for this service id
         */
        function getLegsByService(serviceId) {
            var request = $http({
                method: 'get',
                url: getBaseUrl() + serviceId +"/limitingleg"
            });

            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }

        /** 
         * Fetches all the critical legs departing in the provided week along with service week. 
         * Its important to note that the week provided is not the week of the voyage departure.
         * The voyage might have been started before this week. This is when the critical leg
         * departs. Again, its the date of critical leg departure (not just leg departure)
         * @param {string} serviceId - The id of the service
         * @param {int} week - The number of weeks remaining for the vessel to depart
         * @param {string} vvId - The id of the vessel voyage
         */
        function getLegsByVV(serviceId, week, vvId) {
            var request = $http({
                method: 'get',
                url: getBaseUrl() + serviceId + "/" + week + "/" + vvId
            });

            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }

        /**
         * Fetches all the subsequent leg+voyages for the selected critical leg. This function
         * enables the users to pull the voyages taking place between today and 13 weeks from
         * today for that particular leg enabling the users to make decisions to shuffle the 
         * containers so as to minimize the under capacity.
         * @param {string} serviceId - The id of the service
         * @param {int} week - The number of weeks remaining for the vessel to depart
         * @param {string} vvId - The id of the vessel voyage
         * @param {string} legId - The id of the critical leg under review
         */
        function getComparisonByLeg(serviceId, week, vvId, legId) {
            var request = $http({
                method: 'get',
                url: getBaseUrl() + serviceId + "/" + week + "/" + vvId + "/" + legId +"/comparison"
            });
            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }

        function getUboat(serviceId, week, vvId, legId){
            var request = $http({
                method: 'get',
                url: getBaseUrl() + serviceId + "/" + week + "/" + vvId + "/" + legId +"/uboat"
            });
            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }

        function getHistoryByLeg(serviceId, week, vvId, legId){
        // function getHistoryByLeg(){
            var request = $http({
                method: 'get',
                url: getBaseUrl() +serviceId + "/" + week + "/" + vvId + "/" + legId +"/history"
                // url: "http://127.0.0.1:5000/v1.0/84kn/1/25B1612/1/history"
            });
            return (request.then(helperService.handleHTTPSuccess, helperService.handleHTTPError));
        }
    }]);
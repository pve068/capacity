"use strict";
angular.module('capx').factory(
    'urlService', ['$rootScope', '$log', function ($rootScope, $log) {
        return ({
            getBaseUrl: getBaseUrl,
        });

        /**
         * Returns the base url. This was wrapped inside a service
         * to ensure a single point of failure i.e, if the URL gets
         * changed, then you'd only need to change it at once place.
         * The appConfig here comes from the global app.config.js 
         * file. The reason being that this endpoint is subjected to
         * change and that change should be reflected from the CI/CD
         * tool and not the code.
         */
        function getBaseUrl() {
            if ($rootScope.config.hasOwnProperty("server_url"))
                return $rootScope.config.server_url;
            else {
                $log.log("Could not reach the server. Endpoint not available");
                return null;
            }
        }
    }]);
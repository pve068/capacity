angular.module('capx').factory(
    'urlService', [function () {
        return ({
            getBaseUrl: getBaseUrl,
        });

        /**
         * Returns the base url. This was wrapped inside a service
         * to ensure a single point of failure i.e, if the URL gets
         * changed, then you'd only need to change it at once place
         */
        function getBaseUrl() {
            return 'http://localhost:5000/v1.0/';
        }
    }]);
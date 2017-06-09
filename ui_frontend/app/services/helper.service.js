angular.module('capx').factory(
    'helperService',
    ['$http', '$q', '$log', function ($http, $q, $log) {
        return ({
            handleHTTPError: handleHTTPError,
            handleHTTPSuccess: handleHTTPSuccess,
        });

       /**
         * Handle the error from the $http request
         * @param {*} response 
         */
        function handleHTTPError(response) {
            if (
                !angular.isObject(response.data) ||
                !response.data.message
            ) {
                // If is not an object or something, the line below would show it
                return ($q.reject(response));
            }
            // We'd like to capture in case the error is not caused by either of above conditions
            $log.log(response.data.message);
            return ($q.reject(response.data.message));
        }

        /**
         * Handle the success from the $http request
         * @param {*} response 
         */
        function handleHTTPSuccess(response) {
            return (response.data);
        }
    }]);

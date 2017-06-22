'use strict';

// Declare app level module which depends on views, and components
angular.module('capx', ['ui.router', 'chart.js', 'mm.foundation']);

angular.module('capx')
    
    .config(['$stateProvider', '$urlRouterProvider', '$httpProvider',
        function ($stateProvider, $urlRouterProvider, $httpProvider) {
            $stateProvider.state('settings', {
                url: '/settings',
                template: '<div class="row">This is the settings area. This should appear if the user clicks on the settings</div>'
            });

            $stateProvider.state('capacity', {
                url: '/capacity',
                component: 'capacity'
            });

            $stateProvider.state('capacity.byservice', {
                url: '/byservice',
                params: {
                    data: null
                },
                component: 'byservice'
            });

            $stateProvider.state('capacity.byweek', {
                url: '/byweek',
                params: {
                    data: null
                },
                component: 'byweek'
            });

            $stateProvider.state('capacity.byleg', {
                url: '/byleg',
                params: {
                    details: null
                },
                component: 'byleg'
            });

            $stateProvider.state('capacity.byleg.otherlegs', {
                url: '/otherlegs',
                cache: false,
                params: { other_consumption: null},
                component: 'byotherlegs'
            });

            $stateProvider.state('capacity.byleg.historical', {
                url: '/historical',
                cache: false,
                params: { historical_consumption: null},
                component: 'byhistorical'
            });

            $stateProvider.state('capacity.byleg.uboat', {
                url: '/uboat',
                params: { uboat_consumption: null},
                component: 'byuboat'
            });

            $stateProvider.state('home', {
                url: '/home',
                component: 'home'
            });

            $urlRouterProvider.otherwise('home');
            
        }
    ])
    .run(["$rootScope", function($rootScope){
        /* setting the configuration object from the configuration file
        */
        $rootScope.config = appConfig || {};
    }]);
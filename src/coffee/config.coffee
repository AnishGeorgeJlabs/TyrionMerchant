angular.module 'app.config', []
.config(($stateProvider, $urlRouterProvider, $ionicConfigProvider) ->
  $ionicConfigProvider.tabs.position('bottom')
  $stateProvider
  .state('tabsController',
    url: '/tab'
    abstract: true
    templateUrl: 'templates/tabsController.html'
  )

  .state('login',
    url: '/login'
    templateUrl: 'templates/login.html'
    controller: 'loginCtrl'
  )

  .state('tabsController.newOrders',
    url: '/new'
    views:
      'tab1':
        templateUrl: 'templates/newOrders.html'
        controller: 'newOrdersCtrl'
  )

  .state('tabsController.currentOrders',
    url: '/current'
    views:
      'tab2':
        templateUrl: 'templates/currentOrders.html'
        controller: 'currentOrdersCtrl'
  )

  .state('tabsController.pastOrders',
    url: '/past'
    views:
      'tab3':
        templateUrl: 'templates/pastOrders.html',
        controller: 'pastOrdersCtrl'
  )

  .state('orderDetails',
    url: '/details'
    templateUrl: 'templates/orderDetails.html'
    controller: 'orderDetailsCtrl'
  )

  $urlRouterProvider.otherwise('/login')
)

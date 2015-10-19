angular.module 'app.config', []
.config(($stateProvider, $urlRouterProvider, $ionicConfigProvider) ->
  $ionicConfigProvider.tabs.position('bottom')

  if _.contains(['android', 'ios', 'windowsphone'], ionic.Platform.platform())
    base_dir = "templates_phone/"
  else
    base_dir = "templates_desk/"

  $stateProvider
  .state('tabs',
    url: '/tab'
    abstract: true
    templateUrl: 'templates_phone/tabsController.html'
  )

  .state('login',
    url: '/login'
    templateUrl: base_dir + 'login.html'
    controller: 'loginCtrl'
  )

  .state('tabs.new',
    url: '/new'
    views:
      'tab1':
        templateUrl: 'templates_phone/newOrders.html'
        controller: 'newOrdersCtrl'
  )

  .state('tabs.current',
    url: '/current'
    views:
      'tab2':
        templateUrl: 'templates_phone/currentOrders.html'
        controller: 'currentOrdersCtrl'
  )

  .state('tabs.past',
    url: '/past'
    views:
      'tab3':
        templateUrl: 'templates_phone/pastOrders.html',
        controller: 'pastOrdersCtrl'
  )

  .state('orderDetails',
    url: '/details'
    templateUrl: 'templates_phone/orderDetails.html'
    controller: 'orderDetailsCtrl'
  )

  $urlRouterProvider.otherwise('/login')
)

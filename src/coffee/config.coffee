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
    templateUrl: base_dir + 'tabsController.html'
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
        templateUrl: base_dir + 'newOrders.html'
        controller: 'newOrdersCtrl'
  )

  .state('tabs.current',
    url: '/current'
    views:
      'tab2':
        templateUrl: base_dir + 'currentOrders.html'
        controller: 'currentOrdersCtrl'
  )

  .state('tabs.past',
    url: '/past'
    views:
      'tab3':
        templateUrl: base_dir + 'pastOrders.html',
        controller: 'pastOrdersCtrl'
  )

  .state('orderDetails',
    url: '/details'
    templateUrl: base_dir + 'orderDetails.html'
    controller: 'orderDetailsCtrl'
  )

  $urlRouterProvider.otherwise('/login')
)

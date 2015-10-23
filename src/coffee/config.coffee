angular.module 'app.config', ['app.services']
.config(($stateProvider, $urlRouterProvider, $ionicConfigProvider, tyApiEndpointsProvider) ->
  $ionicConfigProvider.tabs.position('bottom')
  tyApiEndpointsProvider.useLocalHost(true)

  base_dir = window.template_dir

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
      new_tab:
        templateUrl: base_dir + 'newOrders.html'
        controller: 'newOrdersCtrl'
  )

  .state('tabs.current',
    url: '/current'
    views:
      cur_tab:
        templateUrl: base_dir + 'currentOrders.html'
        controller: 'currentOrdersCtrl'
  )

  .state('tabs.past',
    url: '/past'
    views:
      pas_tab:
        templateUrl: base_dir + 'pastOrders.html',
        controller: 'pastOrdersCtrl'
  )

  # ---------------------------- Phone based details view ------------------------------------------------------------ #
  .state('tabs.new-details',
    url: '/details'
    views:
      new_tab:
        templateUrl: base_dir + 'orderDetails.html'
        controller: 'orderDetailsCtrl'
  )
  .state('tabs.current-details',
    url: '/details'
    views:
      cur_tab:
        templateUrl: base_dir + 'orderDetails.html'
        controller: 'orderDetailsCtrl'
  )
  .state('tabs.past-details',
    url: '/details'
    views:
      pas_tab:
        templateUrl: base_dir + 'orderDetails.html'
        controller: 'orderDetailsCtrl'
  )

  # ---------------------------- Web based details View -------------------------------------------------------------- #
  .state('tabs.new.details',
    url: '/details'
    templateUrl: base_dir + 'orderDetails.html'
    controller: 'orderDetailsCtrl'
  )
  .state('tabs.current.details',
    url: '/details'
    templateUrl: base_dir + 'orderDetails.html'
    controller: 'orderDetailsCtrl'
  )
  .state('tabs.past.details',
    url: '/details'
    templateUrl: base_dir + 'orderDetails.html'
    controller: 'orderDetailsCtrl'
  )

  $urlRouterProvider.otherwise('/login')
)

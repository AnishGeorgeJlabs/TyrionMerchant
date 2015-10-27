angular.module 'app.config', ['app.services']
.config(($stateProvider, $urlRouterProvider, $ionicConfigProvider, tyApiEndpointsProvider) ->
  $ionicConfigProvider.tabs.position('bottom')
  tyApiEndpointsProvider.useLocalHost(false)

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
    params: {
      type: "new"
    }
    views:
      new_tab:
        templateUrl: base_dir + 'tab.html'
        controller: 'TabCtrl'
  )

  .state('tabs.current',
    url: '/current'
    params: {
      type: "current"
    }
    views:
      cur_tab:
        templateUrl: base_dir + 'tab.html'
        controller: 'TabCtrl'
  )

  .state('tabs.past',
    url: '/past'
    params: {
      type: "past"
    }
    views:
      pas_tab:
        templateUrl: base_dir + 'tab.html',
        controller: 'TabCtrl'
  )

  # ---------------------------- Phone based details view ------------------------------------------------------------ #
  .state('tabs.new-details',
    url: '/details/:order_number'
    views:
      new_tab:
        templateUrl: base_dir + 'orderDetails.html'
        controller: 'orderDetailsCtrl'
  )
  .state('tabs.current-details',
    url: '/details/:order_number'
    views:
      cur_tab:
        templateUrl: base_dir + 'orderDetails.html'
        controller: 'orderDetailsCtrl'
  )
  .state('tabs.past-details',
    url: '/details/:order_number'
    views:
      pas_tab:
        templateUrl: base_dir + 'orderDetails.html'
        controller: 'orderDetailsCtrl'
  )

  # ---------------------------- Web based details View -------------------------------------------------------------- #
  .state('tabs.new.details',
    url: '/details/:order_number'
    templateUrl: base_dir + 'orderDetails.html'
    controller: 'orderDetailsCtrl'
  )
  .state('tabs.current.details',
    url: '/details/:order_number'
    templateUrl: base_dir + 'orderDetails.html'
    controller: 'orderDetailsCtrl'
  )
  .state('tabs.past.details',
    url: '/details/:order_number'
    templateUrl: base_dir + 'orderDetails.html'
    controller: 'orderDetailsCtrl'
  )

  $urlRouterProvider.otherwise('/login')
)

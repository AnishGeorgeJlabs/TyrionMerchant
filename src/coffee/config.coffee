angular.module 'app'
.config([ '$stateProvider', '$urlRouterProvider', '$ionicConfigProvider', 'tyApiEndpointsProvider',
  ($stateProvider, $urlRouterProvider, $ionicConfigProvider, tyApiEndpointsProvider) ->

    # --- Set tabs at the bottom of the screen
    $ionicConfigProvider.tabs.position('bottom')
    
    # --- For development, use local host where your tyrion dev server is running
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
      controller: 'LoginCtrl'
    )
    .state('changePass',
      url: '/change_pass'
      templateUrl: base_dir + 'changePass.html'
      controller: 'ChangePassCtrl'
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
])

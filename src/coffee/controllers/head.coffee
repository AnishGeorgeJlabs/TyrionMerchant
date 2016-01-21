angular.module('app.controllers')
.controller('HeadCtrl', ['$scope', '$log', '$window',
    ($scope, $log, $window) ->
      ###
      # Works on the document <head>
      # Contains dynamic scripts and stylesheets
      ###

      if $window.isPhone
        $scope.style_sheets = ["css/ionic.app.min.css"]
        $scope.scripts = []
      else
        $scope.style_sheets = ["lib/bootstrap/dist/css/bootstrap.min.css",
                               "css/app_bootstrap.min.css",
                               "lib/toastr/toastr.min.css"
                               "custom_lib/font-awesome/css/font-awesome.min.css"]
        $scope.scripts = ['lib/toastr/toastr.min.js', 'lib/bootstrap/dist/js/bootstrap.min.js']

      $scope.isPhone = $window.isPhone
  ]
)

.controller('DeviceCtrl', ['$scope', '$state', '$rootScope', '$window',
                           'tyColors', 'tyOrderOps', 'tyUserCreds', 'tyNotify', 'tyAudioAlert',
    ($scope, $state, $rootScope, $window, tyColors, tyOrderOps, tyUserCreds, tyNotify, tyAudioAlert) ->
      ###
      # This is probably a master controller
      # Attached to <body>
      ###

      # ----------- Service functions --------------------------- #
      $scope.isPhone = $window.isPhone    # template function to check if phone
      $scope.get_color = tyColors         # get the ui colors according to status

      # ------- routing functions ------------------------------- #
      $scope.stateCheck = (name) ->
        $state.includes(name)
      $scope.goTo = (name) ->
        $state.go(name)

      # ---------- Setup the merchant name ---------------------- #
      $scope.merchant_name = "Tyrion's merch app"
      $rootScope.$on("app:logged_in", (evt, creds) ->
        $scope.merchant_name = creds.name
      )

      # ---------- Sound control -------------------------------- #
      $scope.toggle_mute = () ->
        tyAudioAlert.toggle_mute()
      $scope.is_mute = tyAudioAlert.is_mute

      # ---------- Badge control --------------------------------- #
      $scope.badges =
        new: 0
        current: 0

      tyOrderOps.register_callback('new', (d) ->
        $scope.badges.new = d.length
      )
      tyOrderOps.register_callback('current', (d) ->
        $scope.badges.current = d.length
      )

      # -------- Function to logout ------------------------------ #
      $scope.logout = () ->
        tyUserCreds.logout()
        tyNotify("You have been successfully logged out")
        $state.go 'login'
  ]
)

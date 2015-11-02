angular.module('app.controllers')
.controller('HeadCtrl', ['$scope', '$log', '$window', ($scope, $log, $window) ->
  if $window.isPhone
    $scope.style_sheets = [ "css/ionic.app.min.css" ]
    $scope.scripts = []
  else
    $scope.style_sheets = [ "lib/bootstrap/dist/css/bootstrap.min.css",
                            "css/app_bootstrap.min.css",
                            "lib/toastr/toastr.min.css"
                            "custom_lib/font-awesome/css/font-awesome.min.css"]
    $scope.scripts = ['lib/toastr/toastr.min.js', 'lib/bootstrap/dist/js/bootstrap.min.js']
  $scope.isPhone = $window.isPhone

  # --------- Just some logging for testing ----------- #
  $log.info "device: #{JSON.stringify(ionic.Platform.device())}"
  $log.info "Window dimensions: #{$window.innerWidth} x #{$window.innerHeight}"
])

.controller('DeviceCtrl', ['$scope', '$state', '$rootScope', '$window',
                           'tyColors', 'tyOrderOps', 'tyUserCreds', 'tyNotify', 'tyAudioAlert',
  ($scope, $state, $rootScope, $window, tyColors, tyOrderOps, tyUserCreds, tyNotify, tyAudioAlert) ->
    $scope.isPhone = $window.isPhone
    $scope.stateCheck = (name) ->
      $state.includes(name)

    $scope.merchant_name = "Tyrion's merch app"
    $rootScope.$on("app:logged_in", (evt, creds) ->
      $scope.merchant_name = creds.name
    )

    $scope.goTo = (name) ->
      $state.go(name)

    $scope.get_color = tyColors


    $scope.badges =
      new: 0
      current: 0

    tyOrderOps.register_callback('new', (d) ->
      $scope.badges.new = d.length
    )
    tyOrderOps.register_callback('current', (d) ->
      $scope.badges.current = d.length
    )

    $scope.logout = () ->
      tyUserCreds.logout()
      tyNotify("You have been successfully logged out")
      $state.go 'login'

    $scope.toggle_mute = () ->
      tyAudioAlert.toggle_mute()
    $scope.is_mute = tyAudioAlert.is_mute
])

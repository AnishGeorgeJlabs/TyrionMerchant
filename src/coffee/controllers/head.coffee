angular.module('app.controllers')
.controller('HeadCtrl', ($scope, $log, $window) ->
  if $window.isPhone
    $scope.style_sheets = [ "css/ionic.app.min.css" ]
    $scope.scripts = []
  else
    $scope.style_sheets = [ "lib/bootstrap/dist/css/bootstrap.min.css", "css/app_bootstrap.min.css", 'lib/toastr/toastr.min.css']
    $scope.scripts = ['lib/toastr/toastr.min.js']
  $scope.isPhone = $window.isPhone
)
.controller('DeviceCtrl', ($scope, $state, $rootScope, $log, $window) ->
  $scope.isPhone = $window.isPhone
  $scope.stateCheck = (name) ->
    $state.includes(name)

  $scope.merchant_name = "Tyrion's merch app"
  $rootScope.$on("app:logged_in", (evt, creds) ->
    $scope.merchant_name = creds.name
  )

  $scope.goTo = (name) ->
    $state.go(name)

)

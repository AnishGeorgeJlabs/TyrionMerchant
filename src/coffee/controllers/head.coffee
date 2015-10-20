angular.module('app.controllers')
.controller('HeadCtrl', ($scope, $log, agIsPhone) ->
  if agIsPhone()
    $scope.style_sheets = [ "css/ionic.app.min.css" ]
  else
    $scope.style_sheets = [ "lib/bootstrap/dist/css/bootstrap.min.css", "css/app_bootstrap.min.css"]
)
.controller('DeviceCtrl', ($scope, agIsPhone, $state, $rootScope, $log) ->
  $scope.isPhone = agIsPhone
  $scope.stateCheck = (name) ->
    $state.includes(name)

  $scope.merchant_name = "Tyrion's merch app"
  $rootScope.$on("app:logged_in", (evt, creds) ->
    $scope.merchant_name = creds.name
  )

)

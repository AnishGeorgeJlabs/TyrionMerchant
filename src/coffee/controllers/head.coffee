angular.module('app.controllers')
.controller('HeadCtrl', ($scope, $log, agIsPhone) ->
  if agIsPhone()
    $scope.style_sheets = [ "css/ionic.app.min.css" ]
  else
    $scope.style_sheets = [ "lib/bootstrap/dist/css/bootstrap.min.css", "css/app_bootstrap.min.css"]
)
.controller('DeviceCtrl', ($scope, agIsPhone, agHttp, tyApiEndpoints, $log) ->
  $scope.isPhone = agIsPhone
)

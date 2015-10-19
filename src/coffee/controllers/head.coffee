angular.module('app.controllers')
.controller('HeadCtrl', ($scope, $log, agIsPhone) ->
  if agIsPhone()
    $scope.main_css = "css/ionic.app.min.css"
  else
    $scope.main_css = "lib/bootstrap/dist/css/bootstrap.min.css"
)
.controller('DeviceCtrl', ($scope, agIsPhone) ->
  $scope.isPhone = agIsPhone
)

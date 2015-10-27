angular.module('app.controllers')
.controller('TabCtrl', ($scope, $stateParams, tyOrderOps, $log, tyNotify) ->
  $scope.config = {
    tab: $stateParams.type
    buttons_accept_cancel: $stateParams.type == "new"
    buttons_complete: $stateParams.type == "current"
  }

  $scope.orders = []
  tyOrderOps.order_list($scope.config.tab)
  .then((data) ->
    $scope.orders = data
  , (reason) ->
  )

  $scope.update_status = tyOrderOps.update_status
)

angular.module('app.controllers')
.controller('TabCtrl', ($scope, $stateParams, tyOrderOps, $log) ->
  $scope.config = {
    tab: $stateParams.type
    buttons_accept_cancel: $stateParams.type == "new"
    buttons_complete: $stateParams.type == "current"
  }

  $scope.orders = []
  tyOrderOps.order_list($scope.config.tab)
  .then((data) ->
    $scope.orders = data
    $log.debug "We have data: #{JSON.stringify($scope.orders)}"
  , (reason) ->
    $log.debug "No orders retrieved: #{JSON.stringify(reason)}"
  )

  $scope.update_status = tyOrderOps.update_status
)

angular.module 'app.controllers'
.controller 'newOrdersCtrl', ($scope, tyOrderOps, $log) ->
  $scope.orders = []
  tyOrderOps.order_list('placed')
  .then((data) ->
    $scope.orders = data
    $log.debug "We have data: #{JSON.stringify($scope.orders)}"
  , (reason) ->
    $log.debug "No orders retrieved: #{JSON.stringify(reason)}"
  )

angular.module 'app.controllers'
.controller 'orderDetailsCtrl', ($scope, $stateParams, $log, tyOrderOps, tyNotify) ->
  $log.debug "Order details got params: #{JSON.stringify($stateParams)}"
  tyOrderOps.order_details($stateParams.order_number)
  .then(
    (data) ->

      $scope.order = data.pretty_order
      $scope.amount = data.amount
      $scope.details = _.omit(data, ['pretty_order', 'amount'])

    , (failure) ->
      tyNotify("Failed to fetch order details, please refresh main page and try again", "error")
      $log.debug "Order details fetch failed: #{JSON.stringify(failure)}"
  )

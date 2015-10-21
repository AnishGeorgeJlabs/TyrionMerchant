angular.module 'app.controllers'
.controller 'newOrdersCtrl', ($scope, tyOrderOps, $log) ->
  $scope.orders = []
  tyOrderOps.order_list('placed')
  .success( (d) ->
      if d.success
        $scope.orders = d.data
        $log.debug "We have data: #{JSON.stringify($scope.orders)}"
      else
        $log.debug "No orders retrieved: #{JSON.stringify(d)}"
  )

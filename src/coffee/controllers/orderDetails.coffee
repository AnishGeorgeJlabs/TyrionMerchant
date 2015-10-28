angular.module 'app.controllers'
.controller 'orderDetailsCtrl', ($scope, $stateParams, $log, tyOrderOps, tyNotify, tyUserCreds, $state) ->
  if not tyUserCreds.isLoggedIn()
    $state.go('login')
  $scope.loading = true

  get_details = () ->
    tyOrderOps.order_details($stateParams.order_number)
    .then(
      (data) ->
        $scope.order = data.pretty_order
        $log.info "We have a pretty order: #{JSON.stringify($scope.order)}"
        $scope.amount = data.amount
        $scope.details = _.omit(data, ['pretty_order', 'amount'])
        $scope.loading = false

    , (failure) ->
      tyNotify("Failed to fetch order details, please refresh main page and try again", "error")
      $log.debug "Order details fetch failed: #{JSON.stringify(failure)}"
      $scope.loading = false
    )

  get_details()

  $scope.update_status = (status) ->
    tyOrderOps.update_status($scope.details.order_number, status)
    .then(
      () -> get_details()
    )

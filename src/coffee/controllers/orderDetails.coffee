angular.module 'app.controllers'
.controller('orderDetailsCtrl', [ '$scope', '$state', '$stateParams', '$log', 'tyOrderOps', 'tyNotify', 'tyUserCreds',
  ($scope, $state, $stateParams, $log, tyOrderOps, tyNotify, tyUserCreds) ->
    ###
    # For the order details page
    ###
    if not tyUserCreds.isLoggedIn()
      $state.go('login')
    $scope.loading = true
    $scope.disable_buttons = false

    get_details = () ->
      tyOrderOps.order_details($stateParams.order_number)
      .then(
        (data) ->
          $scope.order = data.pretty_order
          $scope.amount = data.amount
          delete data.pretty_order
          delete data.amount
          $scope.details = data

          $scope.loading = false

      , (failure) ->
        tyNotify("Failed to fetch order details, please refresh main page and try again", "error")
        $log.debug "Order details fetch failed: #{JSON.stringify(failure)}"
        $scope.loading = false
      )

    get_details()

    $scope.update_status = (status) ->
      $scope.disable_buttons = true
      tyOrderOps.update_status($scope.details.order_number, status, $scope.details.status == "placed")
      .then(
        () ->
          get_details()
          $scope.disable_buttons = false
      )
])

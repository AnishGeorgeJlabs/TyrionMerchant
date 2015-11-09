angular.module('app.controllers')
.controller('TabCtrl', ['$scope', '$state', '$stateParams', 'tyOrderOps', 'tyUserCreds',
  ($scope, $state, $stateParams, tyOrderOps, tyUserCreds) ->
    if not tyUserCreds.isLoggedIn()
      $state.go('login')

    $scope.config = {
      tab: $stateParams.type
      buttons_accept_cancel: $stateParams.type == "new"
      buttons_complete: $stateParams.type == "current"
      right_swipe: switch $stateParams.type
        when "new" then "past"
        when "current" then "new"
        when "past" then "current"
      left_swipe: switch $stateParams.type
        when "new" then "current"
        when "current" then "past"
        when "past" then "new"
    }

    $scope.orders = []
    tyOrderOps.register_callback($scope.config.tab, (data) ->
      $scope.orders = data
    )

    $scope.update_status = (order_number, status) ->
      tyOrderOps.update_status(order_number, status, $scope.config.tab == "new")
])

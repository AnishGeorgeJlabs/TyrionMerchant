angular.module('app.controllers')
.controller('TabCtrl', ($scope, $stateParams, tyOrderOps, $log) ->
  $scope.config = {
    tab: $stateParams.type
    buttons_accept_cancel: $stateParams.type == "new"
    buttons_complete: $stateParams.type == "current"
  }

  $scope.orders = []
  tyOrderOps.register_callback($scope.config.tab, (data) ->
    $scope.orders = data
    $log.debug "Got data for #{$scope.config.tab}"
  )

  $scope.update_status = tyOrderOps.update_status
)

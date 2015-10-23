angular.module('app.directives', ['app.services'])
.directive('orderCard', ($window) ->
  base_dir = $window.template_dir

  return {
    restrict: 'E'
    scope:
      detailsState: '@'
      order: '='
      showAccept: '='
      showCancel: '='
    templateUrl: base_dir + "dir_orderCard.html"
    controller: ($scope, tyOrderOps) ->
      $scope.accept = () ->
        tyOrderOps.update_status('accepted')
      $scope.cancel = () ->
        tyOrderOps.update_status('cancelled')
  }
)

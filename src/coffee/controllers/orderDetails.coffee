angular.module 'app.controllers'
.controller 'orderDetailsCtrl', ($scope, $stateParams, $log) ->
  $log.debug "Order details got params: #{JSON.stringify($stateParams)}"

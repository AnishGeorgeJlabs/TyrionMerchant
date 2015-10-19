angular.module('app.controllers')
.controller('HeadCtrl', ($scope, $log, agIsPhone) ->
  $log.info "in a phone? #{agIsPhone()}"
)

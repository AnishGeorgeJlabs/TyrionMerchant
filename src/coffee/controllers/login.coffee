angular.module 'app.controllers', []
.controller 'loginCtrl', ($scope, tyUserCreds, $log, $state) ->
  $scope.data =
    username: ''
    password: ''

  $scope.submit = () ->
    tyUserCreds.login(
      $scope.data.username,
      $scope.data.password
    ).then(
      (username) ->
        $log.info "Logged in as #{username}"
        $state.go 'tabs.new'
      , (reason) ->
        $log.info "Auth failed #{reason}"
    )



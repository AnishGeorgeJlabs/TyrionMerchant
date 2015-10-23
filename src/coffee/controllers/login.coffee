angular.module 'app.controllers', []
.controller 'loginCtrl', ($scope, tyUserCreds, $log, $state) ->
  $scope.data =
    username: ''
    password: ''

  $scope.loading = false

  $scope.submit = () ->
    $scope.loading = true
    tyUserCreds.login(
      $scope.data.username,
      $scope.data.password
    ).then(
      (username) ->
        $log.info "Logged in as #{username}"
        $state.go 'tabs.new'
        $scope.loading = false
      , (reason) ->
        $log.info "Auth failed #{reason}"
        $scope.loading = false
    )



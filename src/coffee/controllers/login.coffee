angular.module 'app.controllers', []
.controller 'loginCtrl', ($scope, tyUserCreds, $log, $state, tyNotify) ->
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
        $state.go 'tabs.new'
        $scope.loading = false
        tyNotify("Logged in as #{username}")
      , (reason) ->
        tyNotify("Loggin failed")
        $scope.loading = false
    )



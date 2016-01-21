angular.module 'app.controllers'
.controller('LoginCtrl', [ '$scope', '$state', 'tyUserCreds', 'tyNotify',
  ($scope, $state, tyUserCreds, tyNotify) ->
    ###
    # It's a no brainer, this one about the login page
    ###
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
          if reason
            tyNotify("Login failed: "+reason, "error")
          $scope.loading = false
      )
])


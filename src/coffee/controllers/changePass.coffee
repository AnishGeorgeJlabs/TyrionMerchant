angular.module 'app.controllers'
.controller('ChangePassCtrl', ['$scope', '$state', 'tyUserCreds', 'tyNotify',
  ($scope, $state, tyUserCreds, tyNotify) ->
    ###
    # As expected, this controller handles the password change page
    ###
    if not tyUserCreds.isLoggedIn()
      $state.go('login')
    $scope.data =
      username: tyUserCreds.username()
      old_pass: ''
      new_pass: ''
      new_pass_r: ''

    $scope.loading = false

    $scope.submit = () ->
      if $scope.data.new_pass == $scope.data.new_pass_r
        if $scope.data.new_pass == $scope.data.old_pass
          tyNotify("The old and new passwords appear to be the same", "warning")
          $state.go "tabs.new"
        else
          $scope.loading = true
          tyUserCreds.change_pass($scope.data.username, $scope.data.old_pass, $scope.data.new_pass)
          .then((result) ->
            if result
              tyNotify("The password was changed successfully", "success")
              $state.go 'tabs.new'
            else
              tyNotify("Authentication error", "error")
              $state.go("login")
          )
      else
        tyNotify("The passwords do not match", "error")

    $scope.cancel = () ->
      $state.go 'tabs.new'
])

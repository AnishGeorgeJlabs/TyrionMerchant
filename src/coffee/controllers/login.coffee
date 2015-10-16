angular.module 'app.controllers', []
.controller 'loginCtrl', ($scope, tyUserCreds) ->
  $scope.data =
    username: ''
    password: ''


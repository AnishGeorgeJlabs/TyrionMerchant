angular.module 'app', ['ionic', 'app.controllers', 'app.config', 'app.services']
.run(($ionicPlatform) ->
  $ionicPlatform.ready( () ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault();
  )
)

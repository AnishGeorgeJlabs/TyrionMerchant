window.isPhone = _.contains(['android', 'ios', 'windowsphone'], ionic.Platform.platform())
window.template_dir = if window.isPhone then "templates_phone/" else "templates_desk/"

angular.module 'app', ['ionic', 'app.controllers', 'app.config', 'app.services', 'app.directives']
.run(($ionicPlatform) ->
  $ionicPlatform.ready( () ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault();
  )
)

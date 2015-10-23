window.isPhone = _.contains(['android', 'ios', 'windowsphone'], ionic.Platform.platform())
window.template_dir = if window.isPhone then "templates_phone/" else "templates_desk/"

angular.module 'app', ['ionic', 'app.controllers', 'app.config', 'app.services', 'app.directives']
.run(($ionicPlatform, $ionicPopup, $state, $log) ->
  $ionicPlatform.ready( () ->
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault();
  )

  $ionicPlatform.registerBackButtonAction( () ->
    if $state.is('tabs.new') || $state.is('login')
      $ionicPopup.confirm(
        title: "exit application?"
        content: "Are you sure you want to exit the application?"
        okType: 'button-clear button-small button-assertive'
        okText: 'exit'
        cancelType: 'button-clear button-small'
      ).then(
        (res) ->
          if res
            navigator.app.exitApp()
      )
    else
      $state.go 'tabs.new'
  , 100)
)

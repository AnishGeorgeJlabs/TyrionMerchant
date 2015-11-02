# ------------------ platform  check -------------------------------------------------- #
if ionic.Platform.isIPad() or (ionic.Platform.platform() == 'android' and navigator.userAgent.indexOf('Mobile') == -1)
  # We have a tablet
  window.isPhone = false
  window.isTablet = true
else if ionic.Platform.platform() in ['android', 'ios', 'windowsphone']
  # we have a phone
  window.isPhone = true
  window.isTablet = false
else
  # we are using a desktop
  window.isPhone = false
  window.isTablet = false

window.template_dir = if window.isPhone then "templates_phone/" else "templates_desk/"

angular.module 'app', ['ionic', 'ngCordova', 'ngAudio',
                       'app.controllers', 'app.config', 'app.services']
.run([ '$ionicPlatform', '$ionicPopup', '$state', '$log', '$window', '$ionicHistory', 'tyAudioAlert',
  ($ionicPlatform, $ionicPopup, $state, $log, $window, $ionicHistory, tyAudioAlert) ->
    $ionicPlatform.ready(() ->
      if window.cordova and window.cordova.plugins.Keyboard
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
      if window.StatusBar
      # org.apache.cordova.statusbar required
        StatusBar.styleDefault();

      if window.cordova
        tyAudioAlert.change_to_cordova()

      $ionicPlatform.registerBackButtonAction(() ->
        if $state.is('tabs.new') || $state.is('login')
          $ionicPopup.confirm(
            title: "exit application?"
            content: "Are you sure you want to exit the application?"
            okType: 'button-clear button-small button-assertive'
            okText: 'exit'
            cancelType: 'button-clear button-small'
            cancelText: 'cancel'
          ).then(
            (res) ->
              if res
                navigator.app.exitApp()
          )
        else if $state.is('tabs.current') || $state.is('tabs.past')
          $state.go 'tabs.new'
        else
          $ionicHistory.goBack()
      , 100)

      if $window.toastr
        $window.toastr.options =
          closeButton: false
          debug: false
          newestOnTop: true
          progressBar: false
          positionClass: "toast-top-right"
          preventDuplicates: true
          showDuration: 300
          hideDuration: 1000
          timeOut: 1500
          showEasing: "swing"
          hideEasing: "linear"
          showMethod: "fadeIn"
          hideMethod: "fadeOut"
    )
])

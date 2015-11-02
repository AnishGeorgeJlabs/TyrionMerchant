angular.module 'app.services', []
.provider('tyApiEndpoints', () ->
  ###
    This service provides for all the api endpoints for tyrion,
    It is configurable to point to the actual amazon web service or the locally running development server
  ###
  externalHost = "http://lannister-api.elasticbeanstalk.com/tyrion/"
  localHost = "http://127.0.0.1:8000/tyrion/"

  host = externalHost

  useLocalHost: (b) ->
    if Boolean(b)
      host = localHost
    else
      host = externalHost

  $get: () ->
    return {
    echo: host
    login: host + "login"
    menu: host + "menu"
    order_list: host + "order_list"
    order_details: host + "order_data"
    status_update: host + "order_data/update_status"
    }
)

.factory('tyUserCreds', [ '$q', '$log', '$rootScope', 'tyApiEndpoints', 'agEncPass', 'agHttp',
  ($q, $log, $rootScope, tyApiEndpoints, agEncPass, agHttp) ->
    ###
      This service manages the user credentials and the login and logout process
      Mainly, it interfaces with the agHttp service to register the api_key and vendor_id once received
    ###
    username = ''
    return {
    username: () -> username
    isLoggedIn: () -> Boolean(username)
    logout: () ->
      username = ''
      agHttp.setApiCreds('', 0)
    login: (user, password) ->
      pass = agEncPass(password)

      agHttp.post(tyApiEndpoints.login,
        username: user
        password: pass
      ).then((data) ->
        username = user
        agHttp.setApiCreds(data.api_key, data.vendor_id)
        broad = {name: data.name, address: data.address}
        $rootScope.$emit("app:logged_in", broad)
        username
      )
    }
])
.factory('tyOrderOps', [ '$interval', '$rootScope', 'tyApiEndpoints', 'tyNotify', 'tyAudioAlert', 'agHttp', 'tyConfirm'
  ($interval, $rootScope, tyApiEndpoints, tyNotify, tyAudioAlert, agHttp, tyConfirm) ->
    ###
      All the necessary operation on orders
    ###

    # --------------- Private data ----------------- #
    data = {
      new: []
      current: []
      past: []
    }

    callbacks = {
      new: []
      current: []
      past: []
    }

    get_list = (tab) -> agHttp.get(tyApiEndpoints.order_list, {tab: tab}).then(
      (result) ->
        data[tab] = result
        fn(data[tab]) for fn in callbacks[tab]
        if tab == "new"
          if result.length > 0
            tyAudioAlert.play()
          else
            tyAudioAlert.stop()
    )

    # ----------- Periodic refresh of all the lists ---------------- #
    refresh = () ->
      get_list tab for tab in ['new', 'current', 'past']

    repetition = null
    $rootScope.$on("app:logged_in", (evt, creds) ->
      repetition = $interval(() ->
        get_list('new')
      , 5000)
      refresh()
    )

    $rootScope.$on("$destroy", () ->
      $interval.cancel(repetition)
    )
    stat_update = (order_number, status) ->
      agHttp.post(tyApiEndpoints.status_update, {status: status, order_number: order_number})
      .then(
        (result) ->
          if result
            refresh()
            tyNotify("order #{order_number} has been #{status}", "success")
          else
            tyNotify("failed to update status, please refresh", "warning")
      , (reason) ->
        if reason
          tyNotify("update failed: #{JSON.stringify(reason)}")
      )

    return {
    update_status: (order_number, status) ->
      if status == 'cancelled'
        tyConfirm("Are you sure you want to cancel the order #{order_number}").then(
          (res) ->
            if res
              stat_update(order_number, status)
        )
      else
        stat_update(order_number, status)

    order_details: (order_number) ->
      agHttp.get(tyApiEndpoints.order_details, {order_number: order_number})

    register_callback: (tab, fn) ->
      callbacks[tab].push(fn)
      if data[tab].length == 0
        get_list(tab)
      else
        fn(data[tab])

    refresh_now: (tab) ->
      get_list(tab)
    }
])

.factory('tyAudioAlert', ['ngAudio', '$cordovaMedia', (ngAudio, $cordovaMedia) ->
    cordova = false
    audio = ngAudio.load("sound/ringer.mp3")
    audio.loop = true
    playing = false
    return {
      play: () ->
        if not cordova and not playing
          playing = true
          audio.play()
        else if cordova
          audio.stop()
          audio.play()
      stop: () ->
        if not cordova and playing
          playing = false
          audio.pause()
        else if cordova
          audio.stop()
      change_to_cordova: () ->
        if playing
          audio.stop()
        audio = $cordovaMedia.newMedia(window.cordova.file.applicationDirectory + "www/sound/ringer.mp3")
        cordova = true
        if playing
          audio.play()
    }
])

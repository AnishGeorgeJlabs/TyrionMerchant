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
    change_pass: host + "change_pass"
    menu: host + "menu"
    order_list: host + "order_list"
    order_details: host + "order_data"
    status_update: host + "order_data/update_status"
    }
)

.factory('tyUserCreds', ['$q', '$log', '$rootScope', 'tyApiEndpoints', 'agEncPass', 'agHttp',
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
        $rootScope.$emit("app:log_out")
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
      change_pass: (user, old_pass, new_pass) ->
        real_old_pass = agEncPass(old_pass)
        real_new_pass = agEncPass(new_pass)

        agHttp.post(tyApiEndpoints.change_pass,
          username: user
          old_pass: real_old_pass
          new_pass: real_new_pass
        )
      }
  ])
.factory('tyOrderOps', ['$interval', '$rootScope', 'tyApiEndpoints', 'tyNotify', 'tyAudioAlert', 'agHttp', 'tyConfirm'
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
        get_list tab for tab in ['current', 'past']


      repetition = null
      $rootScope.$on("app:logged_in", (evt, creds) ->
        repetition = $interval(() ->
          get_list('new')
        , 5000)
        refresh()
      )

      $rootScope.$on("app:log_out", () ->
        clean_up()
      )

      $rootScope.$on("$destroy", () ->
        clean_up()
      )

      clean_up = () ->
        $interval.cancel(repetition)
        data.new = []
        data.current = []
        data.past = []

      stat_update = (order_number, status, isNew = false) ->
        agHttp.post(tyApiEndpoints.status_update, {status: status, order_number: order_number})
        .then(
          (result) ->
            if result
              refresh()
              if isNew
                console.log "New list, refreshing"
                get_list("new")
              else
                console.log "Not new order"
              tyNotify("order #{order_number} has been #{status}", "success")
            else
              tyNotify("failed to update status, please refresh", "warning")
        , (reason) ->
          if reason
            tyNotify("update failed: #{JSON.stringify(reason)}")
        )

      return {
      update_status: (order_number, status, isNew=false) ->
        if status == 'cancelled'
          tyConfirm("Are you sure you want to cancel the order #{order_number}").then(
            (res) ->
              if res
                stat_update(order_number, status, isNew)
          )
        else
          stat_update(order_number, status, isNew)

      order_details: (order_number) ->
        agHttp.get(tyApiEndpoints.order_details, {order_number: order_number})

      register_callback: (tab, fn) ->
        callbacks[tab].push(fn)
        if data[tab].length == 0 and callbacks[tab].length == 1
          get_list(tab)
        else
          fn(data[tab])
      }
  ])

.factory('tyAudioAlert', ['ngAudio', '$cordovaMedia', '$rootScope', (ngAudio, $cordovaMedia, $rootScope) ->
    cordova = false
    audio = ngAudio.load("sound/ringer.mp3")
    audio.loop = true
    playing = false
    mute = false # only required for cordova
    $rootScope.$on("app:log_out", () ->
      audio.stop()
      playing = false
      mute = false
    )
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
      mute = audio.muting
      if playing
        audio.stop()
      audio = $cordovaMedia.newMedia(window.cordova.file.applicationDirectory + "www/sound/ringer.mp3")
      cordova = true
      if playing
        audio.play()
      if mute
        audio.setVolume(0.0)

    toggle_mute: () ->
      if not cordova
        audio.muting = not audio.muting
      else if mute
        audio.setVolume(1.0)
        mute = false
      else
        audio.setVolume(0.0)
        mute = true
    is_mute: () ->
      if not cordova
        audio.muting
      else
        mute

    }
  ])

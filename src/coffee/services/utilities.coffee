angular.module 'app.services'
.factory('agEncPass', () ->
  # Simple service to encrypt password, we are using md5 as of now
  (password) ->
    CryptoJS.MD5(password).toString(CryptoJS.enc.Hex)
)
.factory('agHttp', ['$http', '$q', 'tyNotify',
  ($http, $q, tyNotify) ->
    ###
    # Wrapper over the $http service, will be used accross the application
    # This will be responsible for security, which arguably is quite poor right now
    # Receives and then injects the api_key and vendor_id into every request
    ###
    apiCreds = {
      api_key: ''
      vendor_id: 0
    }

    deferPromise = (httpPromise) ->
      return $q((resolve, reject) ->
        httpPromise.then(
          (d) ->
            if d.data.success
              resolve(d.data.data)
            else
              reject(d.data.reason || d.data.error)
        , (d) ->
          tyNotify("Could not connect to server, please check your internet connnection", "error") # Add a toast notification right here
          reject()
        )
      )
    return {
    setApiCreds: (api_key, vendor_id) ->
      apiCreds.api_key = api_key
      apiCreds.vendor_id = vendor_id

    get: (url, params) ->
      if apiCreds.api_key
        if params == undefined
          params = {}
        params.api_key = apiCreds.api_key
        params.vendor_id = apiCreds.vendor_id

      return deferPromise($http.get(url, {params: params}))

    post: (url, data) ->
      if apiCreds.api_key
        data.api_key = apiCreds.api_key
        data.vendor_id = apiCreds.vendor_id
      return deferPromise($http.post(url, data))
    }
])

.provider('tyNotify', () ->
  ###
  # Hybrid service for notification
  # If on web, uses the toastr plugin
  # Else if on phone, uses ionicPopup
  # Else if installed on phone, uses $cordovaToast
  ###
  if window.isPhone
    res = ['$cordovaToast', '$ionicPopup', '$timeout', ($cordovaToast, $ionicPopup, $timeout) ->
      (message, style) ->
        if window.cordova
          $cordovaToast.showShortBottom(message)
        else
          res = $ionicPopup.alert({
            template: message
            okType: 'button-clear button-small'
          })
          $timeout(() ->
            res.close()
          , 1500)
    ]
  else
    res = ['$log', ($log) ->
      (message, style='info') ->
        if window.toastr
          window.toastr[style](message)
        $log.info message
    ]

  $get: res
)

.provider('agColorCodes', () ->
  ###
  # Setup color codes for ionic or bootstrap
  ###
  if window.isPhone
    colors =
      primary: 'positive'
      warning: 'energized'
      success: 'balanced'
      danger: 'assertive'
  else
    colors =
      primary: 'primary'
      warning: 'warning'
      success: 'success'
      danger: 'danger'
  $get: () ->
    (type) ->
      colors[type]
)

.factory('tyColors', ['agColorCodes', (agColorCodes) ->
  # Setup color codes for the given order status
  (status) ->
    switch status
      when 'placed' then ''
      when 'accepted','ready' then agColorCodes('success')
      when 'cancelled' then agColorCodes('danger')
      when 'delayed' then agColorCodes('warning')
      when 'delivered' then agColorCodes('primary')
])

.factory('tyConfirm', ['$ionicPopup', '$window', '$q', ($ionicPopup, $window, $q) ->
  ###
  # Hybrid service to show correct style of confirmation box. You know the drill
  ###
  if $window.isPhone
    (message) ->
      $ionicPopup.confirm({
        title: "Confirm"
        template: message
        okType: 'button-clear button-small button-assertive'
        okText: 'Yes'
        cancelType: 'button-clear button-small'
        cancelText: 'No'
      })
  else
    (message) ->
      $q( (resolve, reject) ->
        resolve(confirm(message))
      )
])

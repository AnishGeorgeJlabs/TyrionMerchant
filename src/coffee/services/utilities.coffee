angular.module 'app.services'
.factory('agEncPass', () ->
  (password) ->
    CryptoJS.MD5(password).toString(CryptoJS.enc.Hex)
)
.factory('agHttp', ['$http', '$q', 'tyNotify',
  ($http, $q, tyNotify) ->
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
  (status) ->
    switch status
      when 'placed' then ''
      when 'accepted','ready' then agColorCodes('success')
      when 'cancelled' then agColorCodes('danger')
      when 'delayed' then agColorCodes('warning')
      when 'delivered' then agColorCodes('primary')
])

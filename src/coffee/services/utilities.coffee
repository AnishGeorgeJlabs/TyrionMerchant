angular.module 'app.services'
.factory('agEncPass', ($log) ->
  (password) ->
    CryptoJS.MD5(password).toString(CryptoJS.enc.Hex)
)
.factory('agHttp', ($http, $log) ->
  apiCreds = {
    api_key: ''
    vendor_id: 0
  }
  return {
  setApiCreds: (api_key, vendor_id) ->
    apiCreds.api_key = api_key
    apiCreds.vendor_id = vendor_id
    $log.debug "We have api creds: #{JSON.stringify(apiCreds)}"

  get: (url, params) ->
    if apiCreds.api_key
      if params == undefined
        params = {}
      params.api_key = apiCreds.api_key
      params.vendor_id = apiCreds.vendor_id

    $http.get url, { params: params } # Tested, work

  post: (url, data) ->
    if apiCreds.api_key
      data.api_key = apiCreds.api_key
      data.vendor_id = apiCreds.vendor_id
    $http.post url, data
  }
)
.value('agIsPhone', () ->
    _.contains(['android', 'ios', 'windowsphone'], ionic.Platform.platform())
)

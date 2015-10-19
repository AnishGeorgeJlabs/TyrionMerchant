angular.module 'app.services'
.factory('agEncPass', () ->
  (password) ->
    CryptoJS.MD5(password).toString(CryptoJS.enc.Hex)
)
.factory('agHttp', ($http) ->
  apiCreds = {
    api_key: ''
    vendor_id: 0
  }
  return {
  setApiCreds: (obj) ->
    apiCreds.api_key = obj.api_key
    apiCreds.vendor_id = obj.vendor_id

  get: (url) ->
    if apiCreds.api_key
      if '?' in url
        sep = '&'
      else
        sep = '?'
      url += sep + 'api_key=' + apiCreds.api_key + '&vendor_id=' + apiCreds.vendor_id
    $http.get url

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

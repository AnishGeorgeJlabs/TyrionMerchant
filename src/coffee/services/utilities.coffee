angular.module 'app.services'
.factory('agEncPass', ($log) ->
  (password) ->
    CryptoJS.MD5(password).toString(CryptoJS.enc.Hex)
)
.factory('agHttp', ($http, $log, $q) ->
  apiCreds = {
    api_key: '5620e86c2be5104ae1902dc0'   # TODO, only for testing purposes
    vendor_id: 1
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
        $log.debug "Service Error !!" # Add a toast notification right here
      )
    )
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

    return deferPromise($http.get(url, {params: params}))

  post: (url, data) ->
    if apiCreds.api_key
      data.api_key = apiCreds.api_key
      data.vendor_id = apiCreds.vendor_id
    return deferPromise($http.post(url, data))
  }
)

angular.module 'app.services', []
.provider('tyApiEndpoints', () ->
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
    }
)

.factory('tyUserCreds', (tyApiEndpoints, agEncPass, agHttp, $q) ->
  username = ''
  return {
    username: () -> username
    isLoggedIn: () -> Boolean(username)
    logout: () ->
      username = ''
      agHttp.setApiCreds({api_key: '', vendor_id: 0})
    login: (user, password) ->
      pass = agEncPass(password)
      result = $q.defer()

      agHttp.post(tyApiEndpoints.login,
        username: user
        password: pass
      ).success((d) ->
        if d.success
          username = user
          agHttp.setApiCreds(d.data)
          result.resolve(username)
        else
          result.reject(d.reason || d.error)
      )
      return result.promise
  }
)

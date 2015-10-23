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
    order_list: host + "order_list"
    order_details: host + "order_data"
    status_update: host + "order_data/update_status"
    }
)

.factory('tyUserCreds', (tyApiEndpoints, agEncPass, agHttp, $q, $log, $rootScope) ->
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
      $rootScope.$emit("app:logged_in", _.pick(data, 'name', 'address'))
      username
    )
  }
)
.factory('tyOrderOps', (tyApiEndpoints, agHttp) ->
  return {
  update_status: (order_number, status) ->
    agHttp.post(tyApiEndpoints.status_update, {status: status, order_number: order_number})
  order_list: (status) ->
    agHttp.get(tyApiEndpoints.order_list, {status: status})
  order_details: (order_number) ->
    agHttp.get(tyApiEndpoints.order_details, {order_number: order_number})
  }
)

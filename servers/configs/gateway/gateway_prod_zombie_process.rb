{
  active: true,
  name: 'gateway/prod/zombie_process',
  url: 'https://gateway.wealth-park.com/gateway/api/check_zombie_processes',
  custom_http_check: lambda {
    |response|
    json = JSON.parse(response.body, symbolize_names: true)
    if json[:err] == 990 && json[:err_msg] == 'Zombie process found: demo-api'
      nil
    else
      response.body
    end
  },
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}
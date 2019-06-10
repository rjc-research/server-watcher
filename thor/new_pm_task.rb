class NewPmTask
  include Utils

  NAME = 'new_pm'
  DESCRIPTION = 'Create config for new PM-Company'

  def do(pm_company)
    # create watcher for services
    folder = "servers/configs/#{pm_company}"
    FileUtils.mkdir_p(folder)
    new_file("#{folder}/api_prod.rb", $api_prod % { pm_company: pm_company })
    new_file("#{folder}/chat_admin_prod.rb", $chat_admin_prod % { pm_company: pm_company })
    new_file("#{folder}/chat_http_prod.rb", $chat_http_prod % { pm_company: pm_company })
    new_file("#{folder}/chat_ws_prod.rb", $chat_ws_prod % { pm_company: pm_company })
    new_file("#{folder}/potato_prod.rb", $potato_prod % { pm_company: pm_company })
    new_file("#{folder}/storage_prod.rb", $storage_prod % { pm_company: pm_company })
    
    # create watcher for gateway
    folder = "servers/configs/gateway/services/#{pm_company}"
    FileUtils.mkdir_p(folder)
    # new_file("#{folder}/api.rb", $gateway_api % { pm_company: pm_company })
    (0..1).each {
      |i|
      port = "801#{i}"
      new_file("#{folder}/chat-#{port}.rb", $gateway_chat % { pm_company: pm_company, port: port })
    }
    new_file("#{folder}/storage.rb", $gateway_storage % { pm_company: pm_company })
  end

  private

  def new_file(path, content)
    File.open(path, 'w') { |f|
      f.write(content)
    }
  end
end


$api_prod = %{{
  active: true,
  name: '%{pm_company}/api/prod',
  url: 'https://%{pm_company}.wealth-park.com/api/v4/check_alive',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}

$chat_admin_prod = %{{
  active: true,
  name: '%{pm_company}/chat/prod/admin',
  url: 'https://%{pm_company}.wealth-park.com/webchat',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}

$chat_http_prod = %{{
  active: true,
  name: '%{pm_company}/chat/prod/http',
  url: 'https://%{pm_company}.wealth-park.com/chat/api/check_alive',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}

$chat_ws_prod = %{{
  active: true,
  name: '%{pm_company}/chat/prod/ws2',
  url: 'wss://%{pm_company}.wealth-park.com/chat/ws',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}

$potato_prod = %{{
  active: true,
  name: '%{pm_company}/potato/production',
  url: [
    'https://%{pm_company}.wealth-park.com',
  ],
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}

$storage_prod = %{{
  active: true,
  name: '%{pm_company}/storage/prod',
  url: 'https://%{pm_company}.wealth-park.com/storage/api/v1/check_alive',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}


# $gateway_api = %{{
#   active: true,
#   name: 'gateway/services/%{pm_company}/api',
#   url: 'https://gateway.wealth-park.com/gateway/api/check_service_connecting/%{pm_company}-api',
#   interval: INTERVAL,
#   alert: ALERT_EMAIL_ADDRESSES,
# }}

$gateway_chat = %{{
  active: true,
  name: 'gateway/services/%{pm_company}/chat-%{port}',
  url: 'https://gateway.wealth-park.com/gateway/api/check_service_connecting/%{pm_company}-chat-%{port}',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}

$gateway_storage = %{{
  active: true,
  name: 'gateway/services/%{pm_company}/storage',
  url: 'https://gateway.wealth-park.com/gateway/api/check_service_connecting/%{pm_company}-storage',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
}}

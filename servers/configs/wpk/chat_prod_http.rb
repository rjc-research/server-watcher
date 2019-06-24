{
  active: true,
  name: 'chat/prod/http',
  url: 'https://chat.wealth-park.com/api/check_alive',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
  custom_http_check: CHAT_CUSTOM_HTTP_CHECK,
  # ssh: {
  #   user: 'ubuntu',
  #   server: 'chat.wealth-park.com',
  #   has_sudo_priviledge: true
  # },
  # log: {
  #   path: [
  #     '/home/ubuntu/wealthpark-chat/server/log/production.log',
  #     '/var/log/nginx/error.log',
  #     '/var/log/nginx/access.log'
  #   ],
  #   lines: 2000
  # },
  # start_script: "cd /home/ubuntu/wealthpark-chat/server && ./scripts/deploy/http.sh restart production"
}

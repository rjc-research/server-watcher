{
  active: true,
  name: 'gateway/prod/chat/http',
  url: 'https://gateway.wealth-park.com/gateway/chat/api/check_alive',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
  # ssh: {
  #   user: 'ubuntu',
  #   server: 'gateway.wealth-park.com',
  #   has_sudo_priviledge: true
  # },
  # log: {
  #   path: [
  #     '/home/ubuntu/wealthpark-gateway/server/chat/http/log/production.log',
  #     '/home/ubuntu/wealthpark-gateway/server/chat/http/log/forever.err',
  #     '/home/ubuntu/wealthpark-gateway/server/chat/http/log/forever.log',
  #     '/home/ubuntu/wealthpark-gateway/server/chat/http/log/forever.out',
  #     '/var/log/nginx/access.log',
  #     '/var/log/nginx/error.log',
  #   ],
  #   lines: 2000
  # },
  # start_script: "
  #   cd /home/ubuntu/wealthpark-gateway/server;
  #   scripts/deploy/gateway.sh restart production chat;
  # "
}

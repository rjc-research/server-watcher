{
  active: true,
  name: 'gateway/prod/chat/ws',
  url: 'wss://gateway.wealth-park.com/gateway/chat/ws',
  interval: 1,
  alert: ALERT_EMAIL_ADDRESSES,
  ssh: {
    user: 'ubuntu',
    server: 'gateway.wealth-park.com',
    has_sudo_priviledge: true
  },
  log: {
    path: [
      '/home/ubuntu/wealthpark-gateway/server/chat/ws/log/production.log',
      '/home/ubuntu/wealthpark-gateway/server/chat/ws/log/forever.err',
      '/home/ubuntu/wealthpark-gateway/server/chat/ws/log/forever.log',
      '/home/ubuntu/wealthpark-gateway/server/chat/ws/log/forever.out',
      '/var/log/nginx/access.log',
      '/var/log/nginx/error.log',
    ],
    lines: 2000
  },
  start_script: "
    cd /home/ubuntu/wealthpark-gateway/server;
    scripts/deploy/gateway.sh restart production chat;
  "
}

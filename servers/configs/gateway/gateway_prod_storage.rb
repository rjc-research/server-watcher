{
  active: true,
  name: 'gateway/prod/chat/storage',
  url: 'https://gateway.wealth-park.com/gateway/storage/api/check_alive',
  interval: 1,
  alert: ALERT_EMAIL_ADDRESSES,
  ssh: {
    user: 'ubuntu',
    server: 'gateway.wealth-park.com',
    has_sudo_priviledge: true
  },
  log: {
    path: [
      '/home/ubuntu/wealthpark-gateway/server/storage/log/production.log',
      '/home/ubuntu/wealthpark-gateway/server/storage/log/forever.err',
      '/home/ubuntu/wealthpark-gateway/server/storage/log/forever.log',
      '/home/ubuntu/wealthpark-gateway/server/storage/log/forever.out',
      '/var/log/nginx/access.log',
      '/var/log/nginx/error.log',
    ],
    lines: 2000
  },
  start_script: "
    cd /home/ubuntu/wealthpark-gateway/server;
    scripts/deploy/gateway.sh restart production storage;
  "
}

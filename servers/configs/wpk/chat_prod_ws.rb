{
  active: true,
  name: 'chat/prod/ws',
  url: 'wss://chat.wealth-park.com/chat/ws',
  interval: 1,
  alert: ALERT_EMAIL_ADDRESSES,
  ssh: {
    user: 'ubuntu',
    server: 'chat.wealth-park.com',
    has_sudo_priviledge: true
  },
  log: {
    path: [
      '/home/ubuntu/wealthpark-chat/server/chat/log/production.log',
      '/home/ubuntu/wealthpark-chat/server/chat/log/forever.err',
      '/home/ubuntu/wealthpark-chat/server/chat/log/forever.log',
      '/home/ubuntu/wealthpark-chat/server/chat/log/forever.out',
      '/var/log/nginx/error.log',
      '/var/log/nginx/access.log'
    ],
    lines: 2000
  },
  start_script: "cd /home/ubuntu/wealthpark-chat/server && ./scripts/deploy/ws.sh restart production"
}

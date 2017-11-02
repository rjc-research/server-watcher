{
  active: true,
  name: 'hothouse/chat/prod/ws2',
  url: 'wss://hothouse-chat.wealth-park.com/chat/c14eef71-c03f-4ef5-a3ad-8dfe741c7fe1',
  interval: 1,
  alert: ['butterfly.dev@rjc.co.jp'],
=begin
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
  #start_script: "cd /home/ubuntu/wealthpark-chat/server && ./scripts/deploy/ws.sh restart production"
=end
}

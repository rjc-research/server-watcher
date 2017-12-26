{
  active: true,
  name: 'redhorse/chat/prod/http',
  url: 'https://redhorse.wealth-park.com/chat/api/check_alive',
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
      '/home/ubuntu/wealthpark-chat/server/log/production.log',
      '/var/log/nginx/error.log',
      '/var/log/nginx/access.log'
    ],
    lines: 2000
  },
  #start_script: "cd /home/ubuntu/wealthpark-chat/server && ./scripts/deploy/http.sh restart production"
=end
}

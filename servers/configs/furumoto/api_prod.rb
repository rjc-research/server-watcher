{
  active: true,
  name: 'furumoto/api/prod',
  url: 'https://furumoto.wealth-park.com/api/v4/check_alive',
  interval: 1,
  alert: ALERT_EMAIL_ADDRESSES,
=begin
  ssh: {
    user: 'ubuntu',
    server: 'api.wealth-park.com',
    has_sudo_priviledge: true
  },
  log: {
    path: [
      '/home/ubuntu/wealthpark-api/server/log/production.log',
      '/home/ubuntu/wealthpark-api/server/rpc/log/forever.err',
      '/home/ubuntu/wealthpark-api/server/rpc/log/forever.log',
      '/home/ubuntu/wealthpark-api/server/rpc/log/forever.out',
      '/var/log/nginx/error.log',
      '/var/log/nginx/access.log'
    ],
    lines: 2000
  },
  start_script: "
    cd /home/ubuntu/wealthpark-api/server;
    scripts/deploy/api.sh restart production;
    scripts/deploy/rpc.sh restart production;
    sudo service nginx restart;
  "
=end
}

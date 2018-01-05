{
  active: true,
  name: 'furumoto/potato/production',
  url: 'https://furumoto.wealth-park.com',
  interval: 1,
  alert: ALERT_EMAIL_ADDRESSES,
=begin
  ssh: {
    user: 'ubuntu',
    server: 'live.wealth-park.com',
    has_sudo_priviledge: true
  },
  log: {
    path: ['/var/log/apache2/error_wealth-park.log', '/var/www/butterfly/app/logs/prod.log'],
    lines: 2000
  },
  start_script: 'sudo /etc/init.d/apache2 restart'
=end
}

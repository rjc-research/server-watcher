{
  active: true,
  name: 'jbn_billing_listener',
  url: 'http://prod.wealth-park.com/billing/alive',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
  ssh: {
    user: 'ubuntu',
    server: 'prod.wealth-park.com',
    has_sudo_priviledge: true
  },
  log: {
    path: ['/var/log/apache2/error_wealth-park.log'],
    lines: 2000
  },
  start_script: '/etc/init.d/apache2 restart'
}

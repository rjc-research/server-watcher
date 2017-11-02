{
  active: true,
  name: 'rjcweb',
  url: 'https://www.rjc.co.jp',
  interval: 1,
  alert: ['butterfly.dev@rjc.co.jp'],
  ssh: {
    user: 'bitnami',
    server: 'rjc.co.jp',
    has_sudo_priviledge: true
  },
  start_script: 'sudo /opt/bitnami/ctlscript.sh restart'
}

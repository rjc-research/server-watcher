{
  active: true,
  name: 'storage/prod',
  url: 'https://storage.wealth-park.com/api/v1/check_alive',
  interval: 1,
  alert: ALERT_EMAIL_ADDRESSES,
  # ssh: {
  #   user: 'ubuntu',
  #   server: 'storage.wealth-park.com',
  #   has_sudo_priviledge: true
  # },
  # start_script: "
  #   cd /var/www/filestorage/current/server;
  #   sudo scripts/deploy/storage.sh start production;
  #   sudo scripts/deploy/rpc.sh start production;
  #   sudo service nginx restart;
  # "
}

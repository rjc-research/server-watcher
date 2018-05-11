{
  active: true,
  name: 'chat/prod/admin',
  url: 'https://chat.wealth-park.com/admin/index.html',
  interval: 1,
  alert: ALERT_EMAIL_ADDRESSES,
  # ssh: {
  #   user: 'ubuntu',
  #   server: 'chat.wealth-park.com',
  #   has_sudo_priviledge: true
  # },
  # log: {
  #   path: [
  #     '/home/ubuntu/.forever/chat_admin_8030.log',
  #     '/home/ubuntu/.forever/chat_admin_8031.log',
  #     '/home/ubuntu/.forever/chat_admin_8032.log',
  #     '/var/log/nginx/error.log',
  #     '/var/log/nginx/access.log'
  #   ],
  #   lines: 2000
  # },
  # start_script: "cd /home/ubuntu/wealthpark-chat/server && ./scripts/deploy/chat-admin.sh restart production",
}

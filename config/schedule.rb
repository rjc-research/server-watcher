every 1.minute do
  command "cd #{`pwd`.strip} && #{`which bundle`.strip} exec thor sw:start"
end

# remove watcher.log
every(1.day, at: '3am') {
  command "cd #{`pwd`.strip} && rm log/watcher.log.*"
}

# remove /var/mail/ubuntu
every(1.month, at: '3am') {
  command 'rm /var/mail/ubuntu'
}

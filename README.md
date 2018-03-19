# SERVER-WATCHER

Server Watcher is a lightweight tool that watches for your server shutdown.

# Features
- Simple configuration
- Check HTTP and Websocket connections
- Pull log from remote server
- Send alert email
- Automatically restart server

# System requirements
- Ruby 2.2.1
- Gem bundler
- Postfix
- Node & npm (for Websocket check)
- Crontab

# How to use
```sh
cd server-watcher

# install project dependencies
bundle

# install node dependencies
cd websocket
npm install
cd ..

# create boilerplate for new server configuration
# this will create new file: ./servers/configs/your_server_name.rb 
thor sw:new your_server_name

# configure your server
# ...

# run for the first time
thor sw:start

# put it to crontab
whenever --update-crontab

# remove it from crontab
whenever -c
```

# Configuration example
```ruby
{
  active: false,
  name: 'my_cool_server',
  url: 'http://mysite.com' || 'ws://mywebsocket.com',
  custom_http_check: lambda { |response| nil },
  interval: 1,
  alert: ['email@example.com', 'other@example.com'],
  ssh: {
    pem: '/path/to/your/mysite.pem',
    user: 'ubuntu',
    server: 'mysite.com' || '50.60.70.80',
    has_sudo_priviledge: true
  },
  log: {
    path: ['/home/ubuntu/mysite/log/production.log', '/home/ubuntu/mysite/log/other.log'],
    lines: 2000
  },
  start_script: 'your script to start server comes here'
}
```

- `active` whether this configuration is ready to be executed
- `name` name of you server
- `url` url to check your server. For `http/https`, if it returns status code 200, server is alive, otherwise server is down. For `ws`, if client can open connection with server, server is alive, otherwise server is down. Supported protocols: `http/https/ws/wss`.
- `custom_http_check` customization for checking result of http/https request. Returning any thing other than `false` or `nil` means request is invalid. 
- `interval` number of **minutes** between server checkings
- `alert` list of email address to receive notification email when one server is down
- `ssh` configuration for ssh connection to remote server if you want to pull the logs or restart server automatically. The ssh command will be like this:
```
ssh [-i [ssh.pem]] [ssh.user]@[ssh.server] <your command here>
```
- If you don't set `ssh` configuration, all scripts to get log, start server, etc... will be executed on local.
- `ssh.has_sudo_priviledge` whether this user has sudo priviledge. This is used when creating tailed log files from original log files which are sometimes only accessible by using sudo
- `log` configuration to pulling log files from remote server. `path` is location of the remote log files, and `lines` is number of last lines you want to get
- `start_script` script to automatically restart server when it is down

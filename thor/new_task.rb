class NewTask
  include Utils

  NAME = 'new'
  DESCRIPTION = 'Add new server config in ./servers/configs'

  def do(name)
    path = "#{root}/servers/configs/#{filenamize(name)}.rb"
    File.open(path, 'w') do |f|
      f.write([
        "{",
        "  active: false,",
        "  name: '#{name}',",
        "  url: 'http://mysite.com' || 'ws://mywebsocket.com',",
        "  custom_http_check: lambda { |response| nil },",
        "  interval: 1,",
        "  alert: ['email@example.com', 'other@example.com'],",
        "  ssh: {",
        "    pem: '/path/to/your/mysite.pem',",
        "    user: 'ubuntu',",
        "    server: 'mysite.com' || '50.60.70.80',",
        "    has_sudo_priviledge: true",
        "  },",
        "  log: {",
        "    path: ['/home/ubuntu/mysite/log/production.log', '/home/ubuntu/mysite/log/other.log'],",
        "    lines: 2000",
        "  },",
        "  start_script: 'your script to start server comes here'",
        "}"
      ].join("\n"))
    end
    puts("New configuration file is created at: #{path}".colorize(:green))
  end
end

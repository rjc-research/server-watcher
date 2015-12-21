require 'logger'
require 'uri'
require 'net/http'
require 'open-uri'
require 'json'
require 'mail'
require 'colorize'

require 'byebug'

class Sw < Thor

  desc 'new', 'Add new server config in ./servers/configs'
  def new(name)
    File.open("#{root}/servers/configs/#{filenamize(name)}.rb", 'w') do |f|
      f.write([
        "{",
        "  name: '#{name}',",
        "  url: 'http://mysite.com' || 'ws://mywebsocket.com',",
        "  interval: 1,",
        "  alert: ['email@example.com', 'other@example.com'],",
        "  ssh: {",
        "    pem: '/path/to/your/mysite.pem',",
        "    user: 'ubuntu',",
        "    server: 'mysite.com' || '50.60.70.80',",
        "    use_sudo: true",
        "  },",
        "  log: {",
        "    path: ['/home/ubuntu/mysite/log/production.log', '/home/ubuntu/mysite/log/other.log'],",
        "    lines: 2000",
        "  },",
        "  start_script: 'your script to start server comes here'",
        "}"
      ].join("\n"))
    end
  end

  desc 'start', 'Run Server-Watcher server'
  def start

    # load server configs
    configs = []
    SwLog.info(':::LOAD SERVER CONFIGS')
    Dir["#{root}/servers/configs/*.rb"].each do |file|
      begin
        SwLog.info(" - #{file}")
        configs << eval(File.read(file))
      rescue Exception => e
        SwLog.error("Failed to load server config file: #{file}")
        SwLog.error(e)
        return
      end
    end
    SwLog.info('DONE')

    # check servers
    configs.each do |c|
      begin
        check(c)
      rescue Exception => e
        SwLog.error('Failed to check server')
        SwLog.error(JSON.pretty_generate(c))
        SwLog.error(e)
      end
    end
  end

  private 

  def filenamize(name)
    name.gsub(/[^a-zA-Z0-9_\-\.\[\]\{\}\+]+/, '_')
  end

  def root
    File.dirname(__FILE__)
  end

  def check(config)
    # check if config has mandatory fields
    [:name, :url, :interval, :alert].each do |field|
      if empty?(config[field])
        raise "Error: '#{field}' is missing"
      end
    end
    name          = config[:name]
    url           = config[:url].gsub(/^https:\/\//, 'http://').gsub(/^wss:\/\//, 'ws://')
    interval      = config[:interval]
    alert         = config[:alert]
    ssh           = config[:ssh]
    log           = config[:log]
    start_script  = config[:start_script]

    # check config fields
    if !(url =~ URI::regexp)
      raise "'#{url}' is not an URL"
    end

    # check if we should check server at this time
    if Time.now.min % interval != 0
      return
    end

    # check if server is alive
    SwLog.info(":::CHECK SERVER '#{name}'")
    if url.start_with?('http')
      code = check_http(url)
      is_on = code == '200'
      if !is_on
        err_msg = "HTTP #{code}"
      end
    elsif url.start_with?('ws')
      is_on = check_ws(url)
      if !is_on
        err_msg = "Failed to connect Websocket"
      end
    else
      raise 'Protocol of url must be \'http\' or \'ws\''
    end

    # if server is on, do nothing
    if is_on
      SwLog.info('OK')
      return
    end

    SwLog.info('SERVER DOWN!!!!!')
    SwLog.info("Error: #{err_msg}")
    now = Time.now

    # pull log
    log_files = []
    if !empty?(log)
      SwLog.info(' - Pull logs files')
      if empty?(ssh)
        raise "'log' config depends on 'ssh' config"
      end
      time_string = filenamize(now.to_s)
      log[:path].each do |lp|
        tailed_file = "#{File.dirname(lp)}/[#{filenamize(name)}]_[#{time_string}]_#{File.basename(lp)}"
        execute_remote(ssh, "tail -#{log[:lines]} #{lp} > #{tailed_file}")
        system "#{ssh[:use_sudo] ? 'sudo ' : ''}scp -i #{ssh[:pem]} #{ssh[:user]}@#{ssh[:server]}:#{tailed_file} #{root}/servers/logs/"
        execute_remote(ssh, "rm #{tailed_file}")
        log_files << "#{root}/servers/logs/#{File.basename(tailed_file)}"
      end
      SwLog.info('   DONE')
    end

    # send mail
    if !empty?(alert)
      SwLog.info(' - Send alert email')
      content = [
        "Name: #{name}",
        "Url: #{url}",
        "Error: #{err_msg}",
        "At: #{Time.now.to_s}",
        "Logs:\n  #{log_files.join("\n  ")}"
      ].join("\n")
      send_mail(
        alert,
        "Server '#{name}' is DOWN",
        content,
        log_files
      )
      SwLog.info('   DONE')
    end

    # restart server
    if !empty?(start_script)
      SwLog.info(' - Restart server')
      if empty?(ssh)
        raise "'start_script' config depends on 'ssh' config"
      end
      execute_remote(ssh, start_script.strip)
      SwLog.info('   DONE')
    end
  end

  def check_http(url)
    SwLog.info(" - GET #{url}")
    uri = URI.parse(URI.encode(url))
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.get(uri.request_uri)
    response.code
  end

  def check_ws(url)
    begin
      SwLog.info(" - Connect Websocket: #{url}")
      result = system("node websocket/check.js #{url}")
      return result
    rescue
      return false
    end
  end

  def send_mail(_to, _subject, _body, _logs)
    Mail.defaults do
      delivery_method :sendmail, {
        openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
      }
    end
    Mail.deliver do
      from('noreply@server-watch.com')
      to(_to)
      subject(_subject)
      body(_body)
      _logs.each do |file|
        add_file(file)
      end
    end
  end

  def execute_remote(ssh, script)
    system "#{ssh[:use_sudo] ? 'sudo ' : ''}ssh -i #{ssh[:pem]} #{ssh[:user]}@#{ssh[:server]} \"#{script}\""
  end

  def empty?(v)
    !v || (v.methods.include?(:empty?) && v.empty?)
  end

  class SwLog

    def self.error(content)
      if content.methods.include?(:message) && content.methods.include?(:backtrace)
        if content.message
          self.logger.error(content.message.colorize(:red))
          puts content.message.colorize(:red)
        end
        if content.backtrace
          content.backtrace.each do |line|
            self.logger.error(line.colorize(:red))
            puts line.colorize(:red)
          end
        end
      else
        self.logger.error(content.to_s.colorize(:red))
        puts content.to_s.colorize(:red)
      end
    end

    def self.info(content)
      self.logger.info(content.to_s.colorize(:green))
      puts content.to_s.colorize(:green)
    end

    private

    def self.logger
      @logger ||= Logger.new("#{File.dirname(__FILE__)}/log/watcher.log")
      @logger
    end
  end

end
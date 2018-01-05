require 'logger'
require 'uri'
require 'net/http'
require 'open-uri'
require 'json'
require 'mail'
require 'colorize'
require 'byebug'
require 'yaml'
require 'action_mailer'
require 'require_all'

require_all 'initializers'

class Sw < Thor

  desc 'new', 'Add new server config in ./servers/configs'
  def new(name)
    path = "#{root}/servers/configs/#{filenamize(name)}.rb"
    File.open(path, 'w') do |f|
      f.write([
        "{",
        "  active: false,",
        "  name: '#{name}',",
        "  url: 'http://mysite.com' || 'ws://mywebsocket.com',",
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

  desc 'start', 'Run Server-Watcher server'
  def start

    # load server configs
    configs = []
    SwLog.info(':::LOAD SERVER CONFIGS')
    Dir["#{root}/servers/configs/**/*.rb"].each do |file|
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
    url           = config[:url].gsub(/^wss:\/\//, 'ws://')
    interval      = config[:interval]
    alert         = config[:alert]
    ssh           = config[:ssh]
    log           = config[:log]
    start_script  = config[:start_script]

    # check config fields
    if !(url =~ URI::regexp)
      raise "'#{url}' is not an URL"
    end

    # check if config is active
    if !config[:active]
      return
    end

    # check if we should check server at this time
    if Time.now.min % interval != 0
      return
    end

    # check if server is alive
    SwLog.info(":::CHECK SERVER '#{name}'")
    if url.start_with?('http')
      is_on, err_msg, err_backtrace = check_http(url)
    elsif url.start_with?('ws')
      is_on, err_msg, err_backtrace = check_ws(url)
    else
      raise 'Protocol of url must be \'http/https\' or \'ws/wss\''
    end

    # if server is on, do nothing
    if is_on
      SwLog.info('OK')
      return
    end

    SwLog.error('SERVER DOWN!!!!!')
    SwLog.error("Error: #{err_msg}")
    SwLog.error("  #{err_backtrace.join("\n  ")}")
    now = Time.now

    # pull log
    log_files = []
    if !empty?(log)
      SwLog.info(' - Pull logs files')
      time_string = filenamize(now.to_s)
      if !empty?(ssh)
        log[:path].each do |lp|
          sudo_part = ssh[:has_sudo_priviledge] ? 'sudo' : ''
          tailed_file = "~/[#{filenamize(name)}]_[#{time_string}]_#{File.basename(lp)}"
          execute_remote(ssh, "#{sudo_part} tail -#{log[:lines]} #{lp} > #{tailed_file}")
          pem_part = ssh[:pem] ? "-i #{ssh[:pem]}" : ''
          system "scp #{pem_part} #{ssh[:user]}@#{ssh[:server]}:#{tailed_file} #{root}/servers/logs/"
          execute_remote(ssh, "#{sudo_part} rm #{tailed_file}")
          local_log_file = "#{root}/servers/logs/#{File.basename(tailed_file)}"
          if File.exists?(local_log_file)
            log_files << local_log_file
          end
        end
      else
        log[:path].each do |lp|
          log_file = "#{root}/servers/logs/[#{filenamize(name)}]_[#{time_string}]_#{File.basename(lp)}"
          system "sudo tail -#{log[:lines]} #{lp} > #{log_file}"
          if File.exists?(log_file)
            log_files << log_file
          end
        end
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
        "Backtrace:\n  #{err_backtrace.join("\n  ")}",
        "At: #{now.to_s}",
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
      if !empty?(ssh)
        execute_remote(ssh, start_script.strip)
      else
        system(start_script.strip)
      end
      SwLog.info('   DONE')
    end
  end

  def check_http(url)
    begin
      SwLog.info(" - GET #{url}")
      uri = URI.parse(URI.encode(url))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = url.start_with?('https')
      http.verify_mode = 0
      response = http.get(uri.request_uri)
      if response.code =~ /^30[0-9]$/
        new_location = response.header && response.header['location']
        if new_location && new_location != ''
          SwLog.warn("Redirect to: #{new_location}")
          return check_http(new_location)
        end
      end
      is_success = response.code == '200'
      return [is_success, !is_success ? "HTTP #{response.code}" : '', []]
    rescue Exception => e
      return [false, e.message, e.backtrace]
    end
  end

  def check_ws(url)
    begin
      SwLog.info(" - Connect Websocket: #{url}")
      is_success = system("node websocket/check.js #{url}")
      return [is_success, !is_success ? 'Failed to connect Websocket' : '', []]
    rescue Exception => e
      return [false, e.message, e.backtrace]
    end
  end

  def send_mail(_to, _subject, _body, _logs)
    send_mail_config = YAML.load_file(File.join(File.dirname(__FILE__), 'config/send_mail.yml'))

    # using `mail` gem
    if send_mail_config['using_gem'] == 'mail'
      Mail.defaults do
        delivery_method :sendmail, {
          openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
        }
      end
      Mail.deliver do
        from(send_mail_config['from'])
        to(_to)
        subject(_subject)
        body(_body)
        _logs.each do |file|
          add_file(file)
        end
      end
    end

    # using `actionmailer` gem
    if send_mail_config['using_gem'] == 'actionmailer'
      ActionMailer::Base.perform_deliveries     = send_mail_config['actionmailer']['perform_deliveries']
      ActionMailer::Base.raise_delivery_errors  = send_mail_config['actionmailer']['raise_delivery_errors']
      ActionMailer::Base.delivery_method        = send_mail_config['actionmailer']['delivery_method']
      ActionMailer::Base.smtp_settings = {
        address:              send_mail_config['actionmailer']['smtp_settings']['address'],
        port:                 send_mail_config['actionmailer']['smtp_settings']['port'],
        domain:               send_mail_config['actionmailer']['smtp_settings']['domain'],
        user_name:            send_mail_config['actionmailer']['smtp_settings']['user_name'],
        password:             send_mail_config['actionmailer']['smtp_settings']['password'],
        authentication:       send_mail_config['actionmailer']['smtp_settings']['authentication'],
        enable_starttls_auto: send_mail_config['actionmailer']['smtp_settings']['enable_starttls_auto'],
      }
      require_relative './server_watcher_mailer.rb'
      ServerWatcherMailer.notify_server_down(send_mail_config['from'], _to, _subject, _body, _logs)
                         .deliver_now
    end
  end

  def execute_remote(ssh, script)
    pem_part = ssh[:pem] ? "-i #{ssh[:pem]}" : ''
    system "ssh #{pem_part} #{ssh[:user]}@#{ssh[:server]} \"#{script}\""
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

    def self.warn(content)
      self.logger.warn(content.to_s.colorize(:yellow))
      puts content.to_s.colorize(:yellow)
    end

    private

    def self.logger
      @logger ||= Logger.new("#{File.dirname(__FILE__)}/log/watcher.log")
      @logger
    end
  end

end
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
    @logger ||= Logger.new("log/watcher.log")
    @logger
  end
end

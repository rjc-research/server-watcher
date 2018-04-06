class EMThreadSafeLogger < Logger
  def initialize(*args)
    super(*args)
    @log_store = {}
  end

  def info(content)
    content = content.to_s.colorize(:green)
    unless store_content_for_thread?(content, :info)
      super(content)
      puts content
    end
  end

  def warn(content)
    content = content.to_s.colorize(:yellow)
    unless store_content_for_thread?(content, :warn)
      super(content)
      puts content
    end
  end

  def error(content)
    if content.methods.include?(:message) && content.methods.include?(:backtrace)
      if content.message
        error(content.message)
      end
      if content.backtrace
        content.backtrace.each {
          |line|
          error(line)
        }
      end
    else
      content = content.colorize(:red)
      unless store_content_for_thread?(content, :error)
        super(content)
        puts content
      end
    end
  end

  def flush_thread_logs
    unless main_thread?
      logs = @log_store[thread_id] || []
      @log_store.delete(thread_id)
      _thread_id = thread_id
      _self = self
      EM.next_tick {
        logs.each {
          |l|
          content = "[#{_thread_id}][#{l[:time].strftime('%Y-%m-%d %H:%M:%S.%6N %z')}] #{l[:content]}"
          Logger.instance_method(l[:method])
                .bind(_self)
                .call(content)
          puts content
        }
      }
    end
  end

  private

  def thread_id
    Thread.current.object_id
  end

  def main_thread?
    !EM::reactor_running? || Thread.current == EM.reactor_thread
  end

  def store_content_for_thread?(content, method)
    unless main_thread?
      @log_store[thread_id] ||= []
      @log_store[thread_id] << {
          content: content,
          method: method,
          time: Time.now,
        }
      return true
    end
    false
  end
end

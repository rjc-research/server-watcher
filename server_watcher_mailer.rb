class ServerWatcherMailer < ActionMailer::Base
  def notify_server_down(from, to, subject, body, logs)
    logs.each {
      |path|
      file_name = File.basename(path)
      attachments[file_name] = File.read(path)
    }
    mail(from: from, to: to, subject: subject, body: body)
  end

end

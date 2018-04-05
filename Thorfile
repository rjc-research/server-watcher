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
require_all 'thor'

class Sw < Thor
  desc(NewTask::NAME, NewTask::DESCRIPTION)
  def new(name)
    NewTask.new.do(name)
  end

  desc(StartTask::NAME, StartTask::DESCRIPTION)
  def start
    StartTask.new.do()
  end
end
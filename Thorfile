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
require 'fileutils'

require_all 'initializers'
require_all 'thor'

class Sw < Thor
  desc(NewTask::NAME, NewTask::DESCRIPTION)
  def new(name)
    NewTask.new.do(name)
  end

  desc(NewPmTask::NAME, NewPmTask::DESCRIPTION)
  def new_pm(pm_company)
    NewPmTask.new.do(pm_company)
  end

  desc(RemovePmTask::NAME, RemovePmTask::DESCRIPTION)
  def remove_pm(pm_company)
    RemovePmTask.new.do(pm_company)
  end

  desc(StartTask::NAME, StartTask::DESCRIPTION)
  def start
    StartTask.new.do()
  end
end
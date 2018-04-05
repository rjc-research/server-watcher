class RemovePmTask
  NAME = 'remove_pm'
  DESCRIPTION = 'Remove config for one PM-Company'

  def do(pm_company)
    FileUtils.remove_dir("servers/configs/#{pm_company}")
    FileUtils.remove_dir("servers/configs/gateway/services/#{pm_company}")
  end
end
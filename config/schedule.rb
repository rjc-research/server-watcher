every 1.minute do
  command "cd #{`pwd`.strip} && #{`which thor`.strip} sw:start"
end

every 1.minute do
  command "cd #{`pwd`.strip} && #{`which bundle`.strip} exec thor sw:start"
end

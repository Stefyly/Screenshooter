require_relative './utils/deps.rb'
# TO DO
# IMPLEMENT REPLACE BUTTON TO LINK
# button click
# add to the end of the list /// copy to begin of list
# add styles
task default: %w[full]

task :states do
  browser = browser_factory('Chrome')
  scr = Screenshooter.new(browser)
  scr.executor = Executor.new(browser)  
  scr.folder_manager = StateFolderTree.new
  scr.screenshot_states
  browser.close
end

task :full do
  browser = browser_factory('Chrome')
  scr = Screenshooter.new(browser)
  scr.folder_manager = FullFolderTree.new
  scr.screenshot_full
  browser.close
end

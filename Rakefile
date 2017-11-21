require_relative './src/utils/deps.rb'
# TO DO
# IMPLEMENT REPLACE BUTTON TO LINK
# button click
# add to the end of the list /// copy to begin of list
# add styles
task default: %w[full]

#:br -> browser_name
task :states, [:br] do |t, args|
  browser_name = args[:br].nil? ? 'chrome' : args[:br]
  browser = browser_factory(browser_name)
  scr = Screenshooter.new(browser)
  scr.executor = Executor.new(browser)  
  scr.folder_manager = StateFolderTree.new
  scr.screenshot_states
  browser.close
end

task :full do
  browser = browser_factory('chrome')
  scr = Screenshooter.new(browser)
  scr.folder_manager = FullFolderTree.new
  scr.screenshot_full
  browser.close
end

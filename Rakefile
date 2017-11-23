require_relative './src/utils/deps.rb'
# TO DO
# button click
#extra cases for mobile
task default: %w[full]

#:br -> browser_name
task :states, [:file, :br] do |_t, args|
  browser_name = args[:br].nil? ? 'chrome' : args[:br]
  browser = browser_factory(browser_name)
  scr = Screenshooter.new(browser)
  scr.executor = Executor.new(browser)
  ff = StateFolderTree.new
  ff.single_file = args[:file]
  scr.folder_manager = ff
  scr.screenshot_states
end

task :states_parallel, [:processes] do |_t, args|
  browser = browser_factory('chrome')
  scr = Screenshooter.new(browser)
  scr.executor = Executor.new(browser)
  scr.folder_manager = StateFolderTree.new
  scr.screenshot_parallel(args[:processes])
end

task :full do
  browser = browser_factory('chrome')
  scr = Screenshooter.new(browser)
  scr.folder_manager = FullFolderTree.new
  scr.screenshot_full
end

require_relative './utils/deps.rb'
header_1 = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), "/states/header_1.yml")))

# TO DO!!!
# ADD Logic for several block state
# ADD add state counter instead of 9.times do |i|
# Fix - get_pict_path doesn't work in screenshot_states 
# REFACTOR Folder tree - its rabish!!!!
# REFACTOR Screenshooter separate logic for scr_all and state
# CHECK how to improve state config type
# DOCK for this shit

browser = browser_factory('Firefox')
#browser = Watir::Browser.new :firefox
ex = Executor.new(browser, header_1['states'])
scr = Screenshooter.new(browser, 'state', ex)
scr.screenshot_states
browser.close

require_relative './utils/deps.rb'

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
ex = Executor.new(browser)
scr = Screenshooter.new(browser, 'state', ex)
scr.screenshot_states
browser.close

require_relative './utils/deps.rb'
# TO DO
# IMPLEMENT REPLACE BUTTON TO LINK

browser = browser_factory('Chrome')
ex = Executor.new(browser)
scr = Screenshooter.new(browser, ex)
scr.folder_manager = StateFolderTree.new
scr.screenshot_states
browser.close

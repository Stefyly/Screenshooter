require_relative './utils/deps.rb'
# TO DO
# IMPLEMENT REPLACE BUTTON TO LINK
# button click
# add to the end of the list /// copy to begin of list

browser = browser_factory('Chrome')
ex = Executor.new(browser)
scr = Screenshooter.new(browser, ex)
# scr.folder_manager = FullFolderTree.new
# scr.screenshot_full
scr.folder_manager = StateFolderTree.new
scr.screenshot_states
browser.close

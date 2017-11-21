require_relative '.src/utils/deps.rb'

browser = browser_factory('Chrome')
ex = Executor.new(browser)
scr = Screenshooter.new(browser, ex)
# scr.folder_manager = FullFolderTree.new
# scr.screenshot_full
scr.folder_manager = StateFolderTree.new
scr.screenshot_states
browser.close

require_relative './utils/deps.rb'

browser = browser_factory('Firefox')
scr = Screenshooter.new(browser)
scr.generate_local_screenshots
browser.close

def browser_factory(browser_name)
  case browser_name
  when 'Chrome'
    Watir::Browser.new :chrome, switches: %w[
      --headless
      --allow-running-insecure-content
      --disable-popup-blocking
      --disable-translate
      --ignore-certificate-errors
      --disable-gpu
    ]
  when 'Firefox'
    Watir::Browser.new :firefox, headless: true
  when 'Safari'
    Watir::Browser.new :safari
  end
end

def get_page_height(browser)
  browser.execute_script(" return document.body.scrollHeight")
end

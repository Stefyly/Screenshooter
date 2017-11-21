def browser_factory(browser_name)
  case browser_name
  when 'chrome'
    Watir::Browser.new :chrome, switches: %w[
      --headless
      --allow-running-insecure-content
      --disable-popup-blocking
      --disable-translate
      --ignore-certificate-errors
      --disable-gpu
      --hide-scrollbars
    ]
  when 'firefox'
    Watir::Browser.new :firefox, headless: true
  when 'safari'
    Watir::Browser.new :safari
  end
end

def get_page_height(browser)
  browser.execute_script('return document.body.scrollHeight')
end

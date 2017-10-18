def browser_factory(browser_name)
    case browser_name 
      when "Chrome"
        return Watir::Browser.new :chrome, :switches => %w[
                --headless
                --allow-running-insecure-content
                --disable-popup-blocking 
                --disable-translate
                --ignore-certificate-errors 
                --disable-gpu]
      when "Firefox"
        return Watir::Browser.new :firefox
      when "Safari"
        return Watir::Browser.new :safari
    end
end

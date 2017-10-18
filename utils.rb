CONFIG = JSON.load(File.read(File.join(File.dirname(__FILE__), "/config/config.json")))

def get_directories()
    return  Dir.entries(CONFIG['mockup_path']).map {
        |dir|  dir = CONFIG['mockup_path'] + directory
    }
end

def browser_factory(browser_name)
    case browser_name 
      when "Chrome"
        return Watir::Browser.new :chrome, :switches => %w[
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

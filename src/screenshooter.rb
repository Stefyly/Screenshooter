class Screenshooter
  def initialize(browser)
    @browser = browser
    # HACK: for firefox screenshoots
    browser_configure()
    @widths = CONFIG['widths']
    @folder_tree = FolderTree.new
  end

  def browser_configure
    if @browser.driver.is_a?(Selenium::WebDriver::Firefox::Marionette::Driver)
      @vertical_offset = 100
      @browser_name = 'Firefox'
    elsif @browser.driver.is_a?(Selenium::WebDriver::Chrome::Driver)
      @vertical_offset = 0
      @browser_name = 'Chrome'
    end
  end

  def generate_local_screenshots
    progressbar = ProgressBar.new(@folder_tree.component_paths.length * @widths.length)
    @folder_tree.generate_folder_tree(@browser_name)

    @widths.each do |width|
      @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots
      @folder_tree.component_paths.each do |component_name, path|
        @browser.goto('file://' + path)
        @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
        @browser.driver.save_screenshot(@folder_tree.get_pict_path(component_name, width))
        progressbar.increment!
      end
    end
  end
  private :browser_configure
end

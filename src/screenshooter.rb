class Screenshooter
  def initialize(browser, ex = nil)
    @ex = ex
    @browser = browser
    # HACK: for firefox screenshoots
    browser_configure
    @widths = CONFIG['widths']
  end
    attr_writer :folder_manager

  def browser_configure
    if @browser.driver.is_a?(Selenium::WebDriver::Firefox::Marionette::Driver)
      @vertical_offset = 100
      @browser_name = 'Firefox'
    elsif @browser.driver.is_a?(Selenium::WebDriver::Chrome::Driver)
      @vertical_offset = 0
      @browser_name = 'Chrome'
    end
  end

  def screenshot_full
    progressbar = ProgressBar.new(@folder_manager.block_paths.length * @widths.length)
    @folder_manager.init_folder_tree
      @folder_manager.block_paths.each do |component_name, path|
        @browser.goto('file://' + path)
        @widths.each do |width|
          @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots  
          @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
          @browser.driver.save_screenshot(@folder_manager.pict_name(component_name, width))
        progressbar.increment!
      end
    end
  end

  def screenshot_states
    @folder_manager.init_folder_tree
    progressbar = ProgressBar.new(@folder_manager.block_paths.length)
    @folder_manager.block_paths.each do |component_name, path|
      @ex.commands_from_file(component_name)
      @browser.goto('file://' + path)
      @ex.state_count.times do |i|
        @ex.next_command
        @widths.each do |width|
          @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots
          @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
          @browser.driver.save_screenshot(@folder_manager.pict_name(component_name, i, width))
        end
      end
      progressbar.increment!
    end
  end

  private :browser_configure
end

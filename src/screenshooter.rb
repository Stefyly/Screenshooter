class Screenshooter
  # mode
  # full - screenshoot all blocks for adaptivity check
  # state - screenshoot blocks with states config
  def initialize(browser, mode = 'full', ex = nil)
    @ex = ex
    @run_mode = mode
    @browser = browser
    # HACK: for firefox screenshoots
    browser_configure
    @widths = CONFIG['widths']
    @folder_tree = StateFolderTree.new
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

  def screenshot_all
    progressbar = ProgressBar.new(@folder_tree.block_paths.length * @widths.length)
    @folder_tree.full_folder_tree(@browser_name)

    @widths.each do |width|
      @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots
      @folder_tree.block_paths.each do |component_name, path|
        @browser.goto('file://' + path)
        @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
        @browser.driver.save_screenshot(@folder_tree.get_pict_path(component_name, width))
        progressbar.increment!
      end
    end
  end

  def screenshot_states
    @folder_tree.init_folder_tree
    progressbar = ProgressBar.new(@folder_tree.blocks_path_in_library.length)
    @folder_tree.blocks_path_in_library.each do |component_name, path|
      @ex.commands_from_file(component_name)
      @browser.goto('file://' + path)
      @ex.state_count.times do |i|
        @ex.next_command
        @widths.each do |width|
          @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots
          @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
          @browser.driver.save_screenshot(@folder_tree.pict_name(component_name,i,width))
        end
      end
      progressbar.increment!             
    end
  end

  private :browser_configure
end

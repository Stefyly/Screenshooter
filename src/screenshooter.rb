class Screenshooter
  attr_writer :folder_manager, :executor
  def initialize(browser)
    @browser = browser
    # HACK: for firefox screenshoots
    browser_configure
    @widths = CONFIG['widths']
  end
  private :browser_configure

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
    @folder_manager.init_folder_tree
    progressbar = ProgressBar.new(@folder_manager.block_paths.length * @widths.length)
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
      @executor.commands_from_file(component_name)
      @browser.goto('file://' + path)
      @executor.state_count.times do |i|
        @executor.next_command
        @widths.each do |width|
          @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots
          @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
          @browser.driver.save_screenshot(@folder_manager.pict_name(component_name, i, width))
        end
      end
      progressbar.increment!
    end
  end

  def screenshot_parallel(n = 2)
    @folder_manager.init_folder_tree
    pb = ProgressBar.new(@folder_manager.block_paths.length)
    arr = @folder_manager.block_paths.to_a
    pb_incr = ->(_item, _i, _result) { pb.increment! }
    Parallel.map(arr, finish: pb_incr, in_processes: n) do |cmp|
      @browser = browser_factory('chrome')
      @executor = Executor.new(@browser)
      @executor.commands_from_file(cmp[0])
      @browser.goto('file://' + cmp[1])
      @executor.state_count.times do |b|
        @executor.next_command
        @widths.each do |width|
          @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots
          @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
          @browser.driver.save_screenshot(@folder_manager.pict_name(cmp[0], b, width))
        end
      end
    end
  end
end

class Screenshooter
  attr_writer :folder_tree, :executor

  def initialize(browser)
    @browser = browser
    # HACK: for firefox screenshoots
    browser_configure
    @widths = CONFIG['widths']
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

  def screenshot_full
    @folder_tree.init_folder_tree
    progressbar = ProgressBar.new(@folder_tree.blocks.length * @widths.length)
    @folder_tree.blocks.each do |block_name, path|
      @browser.goto('file://' + path)
      @widths.each do |width|
        make_screenshot(width, @folder_tree.pict_name(block_name, width))
        progressbar.increment!
      end
    end
  end

  def screenshot_states
    @folder_tree.init_folder_tree
    progressbar = ProgressBar.new(@folder_tree.blocks.length)
    @folder_tree.blocks.each do |block_name, path|
      @executor.commands_from_file(@folder_tree.path_for_executor(block_name))
      @browser.goto('file://' + path)
      @executor.state_count.times do |i|
        @executor.next_command
        @widths.each do |width|
          make_screenshot(width, @folder_tree.pict_name(block_name, i, width))
        end
      end
      progressbar.increment!
    end
  end

  def screenshot_parallel(n = 1)
    @folder_tree.init_folder_tree
    pb = ProgressBar.new(@folder_tree.blocks.length)
    arr = @folder_tree.blocks.to_a
    pb_incr = ->(_item, _i, _result) { pb.increment! }
    Parallel.map(arr, finish: pb_incr, in_processes: n.to_i) do |cmp|
      @browser = browser_factory('chrome')
      @executor = Executor.new(@browser)
      @executor.commands_from_file(@folder_tree.path_for_executor(cmp[0]))
      @browser.goto('file://' + cmp[1])
      @executor.state_count.times do |i|
        @executor.next_command
        @widths.each do |width|
          make_screenshot(width, @folder_tree.pict_name(cmp[0], i, width))
        end
      end
    end
  end

  def make_screenshot(width, pict_name)
    @browser.window.resize_to(width, 0) # HACK: for firefox screenshoots
    @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
    @browser.driver.save_screenshot(pict_name)
  end

  private :browser_configure
end

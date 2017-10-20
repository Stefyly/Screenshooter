class Screenshooter
  def initialize(browser)
    @browser = browser
    #hack for firefox screenshoots
    @vertical_offset = @browser.driver
                               .is_a?(Selenium::WebDriver::Firefox::Marionette::Driver) ? 100 : 0
    @widths = CONFIG['widths']
    @folder_tree = FolderTree.new
  end

  def generate_local_screenshots
    progressbar = ProgressBar.new(@folder_tree.component_paths.length * @widths.length)
    @folder_tree.generate_folder_tree

    @widths.each do |width|
      @browser.window.resize_to(width, 0)     #hack for firefox screenshoots
      @folder_tree.component_paths.each do |component_name, path|
        @browser.goto('file://' + path + '/index.html')
        @browser.window.resize_to(width, get_page_height(@browser) + @vertical_offset)
        pict_path = './screenshots/' + component_name + '/' + width.to_s + '.png'
        @browser.driver.save_screenshot(pict_path)
        progressbar.increment!
      end
    end
  end
end

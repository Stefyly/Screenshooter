class Screenshooter
  def initialize(browser_name, height = 2000)
    @height = height
    @browser = browser_factory(browser_name)
    @widths = CONFIG['widths']
  end

  def generate_local_screenshots
    folder_tree = FolderTree.new
    folder_tree.generate_folder_tree
    progressbar = ProgressBar.new(folder_tree.component_paths.length * @widths.length)
    
    @widths.each do |width| 
    folder_tree.component_paths.each do |component_name, path|
      @browser.goto('file://' + path + '/index.html')
        @browser.window.resize_to(width, get_page_height(@browser))
        pict_path = './screenshots/' + component_name + '/' + width.to_s + '.png'
        @browser.driver.save_screenshot(pict_path)
        progressbar.increment!
      end
    end
  end
end

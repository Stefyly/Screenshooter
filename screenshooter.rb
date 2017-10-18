CONFIG = JSON.load(File.read(File.join(File.dirname(__FILE__), '/config/config.json')))

class Screenshooter
  def initialize(browser_name)
    @height = 2000
    @browser = browser_factory(browser_name)
    @widths = CONFIG['widths']
    @directories = Dir.entries(CONFIG['mockup_path']).reject { |dir| dir.include?('.') }
    @mockup_paths = @directories.map { |dir| dir = CONFIG['mockup_path'] + dir }
  end

  def generate_folder_tree
    Dir.mkdir('screenshots') unless File.directory?('screenshots')
    @mockup_paths.each do |dir|
      component_name = dir.split('/').last
      unless File.directory?('screenshots/' + component_name)
        Dir.mkdir('screenshots/' + component_name)
      end
    end
    self
  end

  def generate_screenshoots
    progressbar = ProgressBar.new(@mockup_paths.length * @widths.length)
    @mockup_paths.each do |dir|
      @browser.goto('file://' + dir + '/index.html')
      @widths.each do |width|
        @browser.window.resize_to(width, @height)
        component_name = dir.split('/').last
        pict_path = './screenshots/' + component_name + '/' + width.to_s + '.png'
        @browser.driver.save_screenshot(pict_path)
        progressbar.increment!
      end
    end
  end
end

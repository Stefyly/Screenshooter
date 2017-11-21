class FullFolderTree < FolderTree
  def initialize
    FileUtils.mkpath('./screenshots/') unless File.directory?('./screenshots/')
    @current_folder = './screenshots/'
    @blocks = block_paths
  end
  
  # output [component name header/header_1 => full path to component]
  def block_paths
    p 
    full_path = Dir.glob(CONFIG['mockup_path'] + '/wireframes/**/**/dist/index.html')
    names = full_path.map do |name|
      name = /(?<=wireframes\/)\w+-[0-9]\/\w+\//.match(name).to_s
    end
    Hash[names.zip(full_path)]
  end

end

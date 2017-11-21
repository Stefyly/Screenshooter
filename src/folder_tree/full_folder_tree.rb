class FullFolderTree < FolderTree
  def initialize
    FileUtils.mkpath('./screenshots/') unless File.directory?('./screenshots/')
    @current_folder = './screenshots/'
    @blocks = block_paths
  end
  
  # output [component name header/header_1 => full path to component]
  def block_paths(filter_list = nil)
    full_path = Dir.glob(CONFIG['mockup_path'] + '/**/**/wireframe/dist/index.html')
    names = full_path.map do |name|
        name = /(?<=blocks-library\/)\w+\/\w+/.match(name).to_s
    end
    Hash[names.zip(full_path)]
  end

end

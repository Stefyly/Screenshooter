class FullFolderTree
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

  def init_folder_tree
    @blocks.each_key do |block|
      unless File.directory?(@current_folder + '/' + block)
        FileUtils.mkpath(@current_folder + block)
      end
    end
    self
  end
  def pict_name(folder, *information)
    [@current_folder, folder,     information.join('_')].join('/') << '.png'
  end
end

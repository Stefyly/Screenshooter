require_relative '../utils/deps.rb'
class FolderTree
  def initialize(mode)
    Dir.mkdir('screenshots') unless File.directory?('screenshots')
    @current_folder = './screenshots'    
    if mode == 'full'
      @block_paths = get_block_paths
    elsif mode == 'state'
      @block_paths = get_block_paths(block_path_names)
    end

  end

  def get_pict_path(component, width)
    [@current_folder, component, width.to_s + '.png'].join('/')
  end

  # output [component name header/header_1 => full path to component]
  def get_block_paths(filter_list = nil)
    if filter_list.nil?
      full_path = Dir.glob(CONFIG['mockup_path'] + '/**/**/wireframe/dist/index.html')
    else
      full_path = []
      filter_list.each do |block_name|
        full_path << (CONFIG['mockup_path'] + '/' + block_name + '/wireframe/dist/index.html')
      end
    end

    names = full_path.map do |name|
      name = /(?<=blocks-library\/)\w+\/\w+/.match(name).to_s
    end
    Hash[names.zip(full_path)]
  end

  def create_folder(new_folder)
    dirPath = [@current_folder, new_folder].join('/') << '/'
    Dir.mkdir(dirPath) unless File.directory?(dirPath)
  end

  def set_current_folder(path)
    @current_folder = [@current_folder, path].join('/') << '/'
  end

  def full_folder_tree(root_folder = './', _pattern = '')
    create_folder(root_folder)
    set_current_folder(root_folder)

    @block_paths.each_key do |_components|
      unless File.directory?(@current_folder + _components)
        FileUtils.mkpath(@current_folder + _components)
      end
    end
    self
  end

  #generate blockpaths from existed state
  #header_1.yaml - > header/header_1 
  def block_path_names
    names = Dir.entries('./states/').reject { |name| name[0] == '.' }
    names.map do |name|
      block_category = /[a-z]*[^_yml]/.match(name).to_s
      block_version = /\w+[^_.yml]/.match(name).to_s
      name = [block_category, block_version].join('/')
    end
  end
  private :get_block_paths
  attr_reader :block_paths, :current_folder
end

require_relative '../utils/deps.rb'
class FolderTree
  def initialize
    Dir.mkdir('screenshots') unless File.directory?('screenshots')
    @component_paths = get_component_paths
    @current_folder = './screenshots'
  end

  def get_pict_path(component, width)
    [@current_folder, component, width.to_s + '.png'].join('/')
  end

  # output [component name => full path to component]
  def get_component_paths
    full_path = Dir.glob(CONFIG['mockup_path'] + '/**/**/wireframe/dist/index.html')
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

  def generate_folder_tree(root_folder = './')
    create_folder(root_folder)
    set_current_folder(root_folder)

    @component_paths.each_key do |_components|
      unless File.directory?(@current_folder + _components)
        FileUtils.mkpath(@current_folder + _components)
      end
    end
    self
  end
  private :get_component_paths
  attr_reader :component_paths, :current_folder
end

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
    names = Dir.entries(CONFIG['mockup_path']).reject { |dir| dir.include?('.') }
    full_path = names.map { |dir| dir = CONFIG['mockup_path'] + dir }
    return Hash[names.zip(full_path)]
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
        Dir.mkdir(@current_folder + _components)
      end
    end
    self
  end
  private :get_component_paths
  attr_reader :component_paths, :current_folder
end

require_relative '../utils/deps.rb'
class FolderTree
  def initialize
    Dir.mkdir('screenshots') unless File.directory?('screenshots')
    @component_paths = get_component_paths
  end

  # output [component name => full path to component]
  def get_component_paths
    names = Dir.entries(CONFIG['mockup_path']).reject { |dir| dir.include?('.') }
    full_path = names.map { |dir| dir = CONFIG['mockup_path'] + dir }
    return Hash[names.zip(full_path)]
  end

  def generate_folder_tree
    @component_paths.each_key do |_components|
      unless File.directory?('screenshots/' + _components)
        Dir.mkdir('screenshots/' + _components)
      end
    end
    self
  end
  private :get_component_paths
  attr_reader :component_paths
end

class StateFolderTree
  def initialize
    FileUtils.mkpath('./screenshots/states') unless File.directory?('./screenshots/states')
    @current_folder = './screenshots/states'
    @states = existed_states
  end

  # generate folder and subfolder names form ./states in format folder/subfolder
  # header_1.yml - > header/header_1
  def existed_states
    folders = Dir.entries('./states/').reject { |name| name[0] == '.' }
    folders.map do |name|
      block_category = /[a-z]*[^_yml]/.match(name).to_s
      block_version = /\w+[^_.yml]/.match(name).to_s
      folders = [block_category, block_version].join('/')
    end
  end

  def init_folder_tree
    @states.each do |state|
      unless File.directory?(@current_folder + '/' + state)
        FileUtils.mkpath(@current_folder + '/' + state)
      end
    end
  end

  # get hash of blocks names and its full path which have configs in /states folder
  # in format 
    # key - folder/subfolder
    # value - full path 
    # blocks-library/<block-category>/<block-verson>/wireframe/dist/index.html
    # "header/header_1"=>"/Users/bohdan/Documents/blocks-library/header/header_1/wireframe/dist/index.html"
  def blocks_path_in_library
    full_path = []
    @states.each do |state|
      full_path << (CONFIG['mockup_path'] + '/' + state + '/wireframe/dist/index.html')
    end
    Hash[@states.zip(full_path)]
  end
end

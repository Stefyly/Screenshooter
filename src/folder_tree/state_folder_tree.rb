class StateFolderTree < FolderTree
  def initialize
    FileUtils.mkpath('./screenshots/states') unless File.directory?('./screenshots/states')
    @current_folder = './screenshots/states'
    @blocks = block_paths
  end

  # generate list of folder and subfolder names form ./states in format folder/subfolder
  # input  -> header_1.yml
  # output -> d-1/header
  def existed_states
    folders = Dir.entries('./states/').reject { |name| name[0] == '.' }
    folders.map do |name|
      block_version = /[0-9]/.match(name).to_s
      block_category = /[a-z]+[^_.yml]/.match(name).to_s
      folders = ['d-'+block_version, block_category].join('/')
    end
  end

  # get hash of blocks names and its full path which have configs in /states folder
  # in format
  # key - folder/subfolder
  #   value - full path
  #   blocks-library/<block-category>/<block-verson>/wireframe/dist/index.html
  #   example = "header/header_1" => "PATH/header_1/wireframe/dist/index.html"
  def block_paths
    blocks = existed_states
    full_path = []
    blocks.each do |block|
      full_path << (CONFIG['mockup_path'] + '/wireframes/' + block + '/dist/index.html')
    end
    Hash[blocks.zip(full_path)]
  end

  # get picture path for saving

end

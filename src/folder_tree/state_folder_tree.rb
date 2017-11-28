class StateFolderTree < FolderTree
  # Set filename in format [name_[0-9] - if u need to run states only for 1 block
  def initialize(args = nil)
    FileUtils.mkpath('./screenshots/states') unless File.directory?('./screenshots/states')
    @args = args
    @current_folder = './screenshots/states'
    #@blocks = block_paths
  end

  # generate list of folder and subfolder names form ./states in format folder/subfolder
  # input  -> header_1.yml
  # output -> d-1/header

  def existed_states
    mode = if @args.mode.nil?
             'wireframes'
           else
             @args.mode
           end

      if @args.folder.nil? && @args.file.nil?
        folders = Dir.glob("**/#{mode}/**/*.yml")
        p folders        
        folders.map { |a| a.gsub!("states/#{mode}/", '').gsub!('.yml', '') }
        p 'run full'
        folders       
      elsif !@args.folder.nil?
        p 'run only one folder'        
        folders = Dir.glob("**/#{mode}/#{@args[:folder]}/*.yml")
        folders.map { |a| a.gsub!("states/#{mode}/", '').gsub!('.yml', '') }
      else
      p 'run single file'
        [@args.file]
      end
  end

  def blocks_from_folder
      if !@args.folder.nil?
        folder_name = @args.folder
        mode = mode_from_name(folder_name)
      elsif 
        folder_name = '**'
        mode = mode_from_name(@args.mode)
      end
      folders = Dir.glob("**/#{mode}/#{folder_name}/*.yml")
      folders.map { |a| a.gsub!("states/#{mode}/", '').gsub!('.yml', '') }
  end

  def mode_from_name(name)
    if name[0] == 'w'
      'wireframes'
    elsif name[0] == 'd'
      'designs'
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
end

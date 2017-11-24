class FolderTree
  attr_accessor :blocks

  def initialize
    @current_folder = nil
  end

  def init_folder_tree
    if @blocks.nil? || @current_folder.nil?
      raise NotImplementedError, 'Set variable in a child class'
    end
    @blocks.each_key do |block|
      unless File.directory?(@current_folder + '/' + block)
        FileUtils.mkpath(@current_folder + '/' + block)
      end
    end
  end

  def pict_name(folder, *information)
    raise NotImplementedError, 'Set variable in a child class' if @current_folder.nil?

    [@current_folder, folder, information.join('_')].join('/') << '.png'
  end

  # get hash of blocks names and its full path which have configs in /states folder
  # in format
  # key - folder/subfolder
  #   value - full path
  #   blocks-library/<block-category>/<block-verson>/wireframe/dist/index.html
  #   example = "header/header_1" => "PATH/header_1/wireframe/dist/index.html"
  def block_paths
    raise NotImplementedError, 'Implement this method in a child class'
  end
end

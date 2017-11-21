class FolderTree
  def initialize
    @current_folder = nil
    @blocks = nil
  end

  def init_folder_tree
    @blocks.each_key do |block|
      unless File.directory?(@current_folder + '/' + block)
        FileUtils.mkpath(@current_folder + '/' + block)
      end
    end
  end

  def pict_name(folder, *information)
    [@current_folder, folder, information.join('_')].join('/') << '.png'
  end
end

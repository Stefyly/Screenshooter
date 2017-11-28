require_relative './src/utils/deps.rb'

task default: %w[full]

namespace :state do
  desc 'main task for states'
  task :main do |_, args|
    browser = browser_factory('chrome')
    scr = Screenshooter.new(browser)
    scr.executor = Executor.new(browser)
    scr.folder_tree = StateFolderTree.new(args)
    scr.screenshot_states
  end

  desc 'execute only one file [w-1/header]'
  task :file, [:file] => :main

  desc 'execute selected folder [w-1]'
  task :folder, [:folder] => :main

  desc 'execute all designs[d] or wireframes[w]'
  task :mode, [:mode] => :main

  desc 'excute all files from ./states folder'
  task all: :main
end

namespace :parallel do
  task :main do |_t, args|
    browser = browser_factory('chrome')
    scr = Screenshooter.new(browser)
    scr.executor = Executor.new(browser)
    scr.folder_tree = StateFolderTree.new(args)
    scr.screenshot_parallel(args.processes)
  end

  desc 'execute only one file [w-1/header]'
  task :file, [:file] => :main

  desc 'execute selected folder [w-1] in several processes[2]'
  task :folder, %i[folder processes] => :main

  desc 'execute all designs[d] or wireframes[w] in several processes[2]'
  task :mode, %i[mode processes] => :main

  desc 'excute all files from ./states folder in several processes[2]'
  task :all, [:processes] => :main
end

desc 'make screenshoots for all blocks without states for adaptivity check'
task :adaptivity do
  browser = browser_factory('chrome')
  scr = Screenshooter.new(browser)
  scr.folder_tree = FullFolderTree.new
  scr.screenshot_full
end

namespace :utils do
  task :rm, [:folder_name] do |_t, args|
    `rm -rf #{args.folder_name}`
  end
end

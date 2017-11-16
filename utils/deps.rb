require 'watir'
require 'phashion'
require 'progress_bar'
require 'fileutils'
require_relative '../src/screenshooter.rb'
require_relative '../src/folder_tree.rb'
require_relative './utils.rb'
CONFIG = JSON.load(File.read(File.join(File.dirname(__FILE__), '../config/config.json')))



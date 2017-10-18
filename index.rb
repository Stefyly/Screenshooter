require_relative './deps.rb'

scr = Screenshooter.new('Chrome')
scr.generate_folder_tree().generate_screenshoots()


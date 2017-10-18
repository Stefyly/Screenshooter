CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "/config/config.yml")))

def getDirectories()
    puts Dir.entries(CONFIG['mockup_path'])
end
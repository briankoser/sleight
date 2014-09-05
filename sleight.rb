require 'fileutils'
require 'find'
require 'json'
require 'kramdown'
require 'mustache'

def create_html(jsonFile, destination, htmlFileName)
    data = JSON.parse(File.read(jsonFile))
    File.open(File.join(destination, htmlFileName), 'w') {|f| f.write(Mustache.render(data)) }
end

def output_resources(output, extension)
  src = File.join('.', 'site', '_resources')
  dest = File.join(output, extension)

  Find.find(src) do |file|
    next if File.directory?(file)
    next if File.extname(file) != '.' + extension
    
    # puts file
    # file.split(File::Separator).each {|token| puts token}
    
    # todo
    # 1. move to temp folder
    # 2. rename
    # 3. move to final destination
    FileUtils.mkdir_p dest
    FileUtils.cp file, dest
  end
end

# Set directory locations
site_dir = File.join '.', 'site'
output_dir = File.join site_dir, '_output'
img_dir_src = File.join site_dir, 'img'
img_dir_dest = File.join output_dir, 'img'
recipes_dir_dest = File.join output_dir, 'recipes'
recipes_template_path = File.join site_dir, '_templates', 'recipes', '_default.mustache'
recipes_json_path = site_dir, '_data', 'recipes'

# Remove existing output so we can create the site from scratch
FileUtils.rm_r output_dir if File.exists?(output_dir)
FileUtils.mkdir_p output_dir

# Move images to output
FileUtils.cp_r img_dir_src, img_dir_dest

# Move CSS and JS to output
# output_resources(output_dir, 'css')
# output_resources(output_dir, 'js')

# Move recipes to output
FileUtils.mkdir_p recipes_dir_dest
Mustache.template_file = recipes_template_path
create_html File.join(recipes_json_path, 'boxed-mac-and-cheese-that-doesnt-suck.json'), recipes_dir_dest, 'mac.html'
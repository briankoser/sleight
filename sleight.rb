require 'fileutils'
require 'find'
require 'json'
require 'kramdown'
require 'mustache'

def create_html(jsonFile, destination, htmlFileName)
    data = JSON.parse(File.read(jsonFile))
    File.open(File.join(destination, htmlFileName), 'w') {|f| f.write(Mustache.render(data)) }
end

def create_recipes(template, src, dest)
    Mustache.template_file = template
    
    Dir.foreach(src) do |item|
      next if item == '.' or item == '..'
      recipe_name = File.basename(item, '.json')
      recipe_dest = File.join(dest, recipe_name)
      FileUtils.mkdir_p recipe_dest
      create_html File.join(src, item), recipe_dest, 'index.html'
    end
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
site_dir              = File.join '.', 'site'
output_dir            = File.join site_dir, '_output'
img_dir_src           = File.join site_dir, 'img'
img_dir_dest          = File.join output_dir, 'img'
recipes_dir_dest      = File.join output_dir, 'recipes'
recipes_template_path = File.join site_dir, '_templates', 'recipes', '_default.mustache'
recipes_json_path     = File.join site_dir, '_data', 'recipes'

# Remove existing output so we can create the site from scratch
FileUtils.rm_r output_dir if File.exists?(output_dir)
FileUtils.mkdir_p output_dir

# Move images to output
FileUtils.cp_r img_dir_src, img_dir_dest

# Move CSS and JS to output
# output_resources(output_dir, 'css')
# output_resources(output_dir, 'js')

# Move recipes to output
create_recipes(recipes_template_path, recipes_json_path, recipes_dir_dest)
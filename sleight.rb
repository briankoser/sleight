require 'fileutils'
require 'find'
require 'json'
require 'kramdown'
require 'mustache'

def create_html(jsonFile, destination, htmlFileName)
    data = JSON.parse(File.read(jsonFile))
    File.open(File.join(destination, htmlFileName), 'w') {|f| f.write(Mustache.render(data)) }
end

def create_recipe_list(file_template_dir, recipes)
    Mustache.template_file = file_template_dir
    
    list_template_found = false
    list_template = ''
    
    file_template = IO.readlines(file_template_dir)
    file_template.each do |line|
        if line.include? '{{/recipes}}'
            list_template_found = false
            line.gsub!(/.*/, '')

            list_template.strip!
            recipe_links = ''
            Dir.foreach(recipes) do |item|
                next if item == '.' or item == '..'
                json_file = JSON.parse(File.read(File.join(recipes, item)))
                recipe = list_template.gsub '{{name}}', json_file['name']
                recipe.gsub! '{{url}}', json_file['urlname'] + '/'
                recipe_links = recipe_links + recipe + "\n"
            end
            
            line.insert 0, recipe_links
        end
        
        if list_template_found
            list_template = list_template + line + "\n"
            line.gsub!(/.*/, '')
        end
    
        if line.include? '{{#recipes}}'
            list_template_found = true
            line.gsub!(/.*/, '')
        end
    end
    
    File.open(file_template_dir, 'w') {|f| f.write(file_template.join) }
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
    search = File.join(src, '**', '*.' + extension)
    dest = File.join(output, extension)
    
    Dir.glob(search) do |file|
        next if File.directory?(file)
        
        file_name = file.gsub(src, '').split(File::Separator).join('.').sub('.', '')
        FileUtils.mkdir_p dest
        FileUtils.cp file, File.join(dest, file_name)
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
recipe_list_src       = File.join site_dir, '_templates', 'recipes', 'index.mustache'
recipe_list_dest      = File.join recipes_dir_dest, 'index.html'

# Remove existing output so we can create the site from scratch
FileUtils.rm_r output_dir if File.exists?(output_dir)
FileUtils.mkdir_p output_dir

# Move images to output
FileUtils.cp_r img_dir_src, img_dir_dest

# Move CSS and JS to output
output_resources(output_dir, 'css')
output_resources(output_dir, 'js')

# Move recipes to output
create_recipes(recipes_template_path, recipes_json_path, recipes_dir_dest)

# Create recipe list
FileUtils.cp_r recipe_list_src, recipe_list_dest
create_recipe_list(recipe_list_dest, recipes_json_path)
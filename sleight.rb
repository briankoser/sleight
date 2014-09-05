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

# Remove existing output so we can create the site from scratch
output = File.join('.', 'site', '_output')
FileUtils.rm_r output if File.exists?(output)
FileUtils.mkdir_p output

# # Move templates to output
# src = File.join('.', 'site', '_templates')
# FileUtils.cp_r src, output

# Move images to output
img_src = File.join('.', 'site', 'img')
img_dest = File.join(output, 'img')
FileUtils.cp_r img_src, img_dest

# output_resources(output, 'css')
# output_resources(output, 'js')


recipes_dest = File.join(output, 'recipes')
FileUtils.mkdir_p recipes_dest

Mustache.template_file = File.join('.', 'site', '_templates', 'recipes', '_default.mustache')
create_html File.join('.', 'site', '_data', 'recipes', 'boxed-mac-and-cheese-that-doesnt-suck.json'), recipes_dest, 'mac.html'
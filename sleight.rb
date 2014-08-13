require 'fileutils'
require 'find'

def output_resources(output, extension)
  src = File.join('.', 'site', '_resources')
  dest = File.join(output, extension)

  Find.find(src) do |file|
    # check for directory
    
    next if File.directory?(file)
    next if File.extname(file) != '.' + extension
    
    puts file
    
    FileUtils.mkdir_p dest
    FileUtils.cp file, dest
  end
end

# Remove existing output
output = File.join('.', 'site', '_output')
FileUtils.rm_r output if File.exists?(output)

# Move templates to output
src = File.join('.', 'site', '_templates')
FileUtils.cp_r src, output

# Move images to output
img_src = File.join('.', 'site', 'img')
img_dest = File.join(output, 'img')
FileUtils.cp_r img_src, img_dest

output_resources(output, 'css')
# output_resources('js')
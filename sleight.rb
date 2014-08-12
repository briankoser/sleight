require 'fileutils'
require 'find'

# Remove existing output
FileUtils.rm_r './site/_output/'

resourcesSource = './site/_resources/'

# Find.find(src) do |path|
    # unless path == src
        # puts path
    # end
# end

# Move templates to output
src = './site/_templates/.'
dest = './site/_output'
FileUtils.cp_r src, dest

# Move images to output
imgSource = './site/img/'
imgDestination = './site/_output/img/'
FileUtils.cp_r imgSource, imgDestination

# Move css to output
cssDestination = './site/_output/css/'
Find.find(resourcesSource) do |file|
    # check for directory
    
    next if File.extname(file) != '.css'
    
    FileUtils.mkdir_p cssDestination
    FileUtils.cp file, cssDestination
end

# Move js to output
jsDestination = './site/_output/js/'
Find.find(resourcesSource) do |file|
    # check for directory
    
    next if File.extname(file) != '.js'
    
    FileUtils.mkdir_p jsDestination
    FileUtils.cp file, jsDestination
end
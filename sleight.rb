require 'fileutils'

src = './site/_templates/.'
# Find.find(src) do |path|
    # unless path == src
        # puts path
    # end
# end
dest = './site/_output'

FileUtils.cp_r src, dest

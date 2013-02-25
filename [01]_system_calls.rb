require 'open3'

output = Open3.capture2('ipconfig')
puts output.

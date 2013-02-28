require 'open3'

output, status = Open3.capture2('ipconfig')

if status.success?
  output.split("\n").select do |line|
    puts line if line.include? 'IPv4'
  end
else
  puts status
end

output, status = Open3.capture2('ping google.fr')

if status.success?
  puts 'Connectivity OK'
else
  puts 'No internet connection'
end


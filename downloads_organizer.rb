# Allez voir ce qu'il y a dans ENV, c'est très utile!
# require 'pp' # pp = "pretty print"
# pp ENV
target_path = ARGV.first || File.expand_path('Downloads', ENV['USERPROFILE'])
large_path = File.join(target_path, '/Large files/')

# Pow encapsulates the functionality of several ruby libraries (FileUtils, Files, Pathname and Dir)
# by creating objects out of path strings
require 'pow'

class Pow::File
  def size
    (File.size(self.path) / 1024000.0).round(2)
  end
end

puts "now cleaning #{target_path}..."
path = Pow(target_path)

path.files.each do |child|
  child.move_to!(Pow(File.join(large_path, child.name))) if child.size > 10
end

# Pow::Base
# Pow::File
# Pow::Directory

##


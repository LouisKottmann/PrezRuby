# Check out what's inside the ENV variable, it's very useful!
# require 'pp' # pp = "pretty print"
# pp ENV

require 'FileUtils'
require 'optparse'

$options = {}
OptionParser.new do |opts|
   opts.banner = 'Usage: serials_organizer.rb [options]'

   opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
   end

   opts.on('-t', '--target [FOLDER]', String, 'Define the target directory to organize (it\'s USERPROFILE/Downloads by default)') do |t|
      $options[:target_dir] = t
   end

   opts.on('-s', '--serials [FOLDER]', String, 'Define the serials directory if different from the target dir') do |s|
      $options[:serials_dir] = s
   end
end.parse!

$target_dir = $options[:target_dir] || File.expand_path('Downloads', ENV['USERPROFILE'])
$serials_dir = $options[:serials_dir] || $target_dir
$serial_regex = /(:print:)[S ](\d+)[EX](\d+)/i

def move_to_serials_subfolder(file, subfolder)
   target_folder = File.join($serials_dir, subfolder)
   FileUtils.mkdir_p target_folder unless File.directory? target_folder
   FileUtils.move file, File.join(target_folder, File.basename(file))
end

puts "now organizing serials from #{$target_dir}..."

Dir["#{$target_dir.gsub(/\\/, '/')}/*"].each do |entry| # can be a file or a folder
   puts entry
   entry_name = File.basename(entry, '.*').gsub(/\./, ' ')
   if $serial_regex.match entry_name
      puts "#{$1.strip}: Season #{$2.to_i} Episode #{$3.to_i}"
      move_to_serials_subfolder entry, "#{$1.strip}/Season #{$2.to_i}"
   end
end
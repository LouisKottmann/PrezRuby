# Check out what's inside the ENV variable, it's very useful!
# require 'pp' # pp = "pretty print"
# pp ENV

require 'FileUtils'
require 'optparse'

$options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: serials_oganizer.rb [options]'

  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end

  $options[:target_dir] = File.expand_path('Downloads', ENV['USERPROFILE'])
  opts.on('-t', '--target', 'Define the target directory to organize (it\'s USERPROFILE/Downloads by default)') do |t|
    $options[:target_dir] = t
  end

  $options[:serials_dir] = $options[:target_dir]
  opts.on('-s', '--serials', 'Define the serials directory if different from the target dir') do |s|
    $options[:serials_dir] = s
  end
end.parse!

$target_dir = $options[:target_dir]
$serials_dir = $options[:serials_dir]
$serial_regexes = [/(.*)S(\d{2})E(\d{2})/i, /(.*)(\d{1,2})x(\d{1,2})/i]

def size_mb(file)
  (File.size(file) / 1024000.0).round(2)
end

def move_to_serials_subfolder(file, subfolder)
  target_folder = File.join($serials_dir, subfolder)
  FileUtils.mkdir_p target_folder unless File.directory? target_folder
  FileUtils.move file, File.join(target_folder, File.basename(file))
end

puts "now organizing serials from #{$target_dir}..."

Dir["#{$target_dir}/*"].each do |entry| # can be a file or a folder
  entry_name = File.basename entry
  if $serial_regexes.any? { |regex| regex.match(entry_name) }
    puts "#{$1.strip}: Season #{$2.to_i} Episode #{$3.to_i}"
    move_to_serials_subfolder entry, "#{$1.strip}/Season #{$2.to_i}"
  end
end
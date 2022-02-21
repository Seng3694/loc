require 'optparse'

FileEntry = Struct.new(:name, :lines)

def count_lines_in_file(fileName)
  File.foreach(fileName).inject(0) do |count, line|
    if not line.strip.empty?
      count + 1
    else
      count
    end
  end
end

options = {
  :filter => '',
  :exclude => ''
}
OptionParser.new do |opt|
  opt.banner = 'Usage: loc.rb [options] root_directory'

  opt.on('-f', '--filter FILEFILTER', 'eg. "cpp hpp lua"') do |o| 
    options[:filter] = o 
  end
  opt.on('-e', '--exclude EXCLUDEDDIRS', 'eg. "ext .vs .git"') do |o| 
    options[:exclude] = o 
  end
end.parse!

if ARGV.length == 1
  rootDirectory = ARGV[0]
else
  rootDirectory = Dir.pwd
end

Dir.chdir(rootDirectory)

if options[:filter].empty?
  fileFilter = '.*'
else
  fileFilter = '.{' << options[:filter].gsub(/[^0-9a-zA-Z ]/, '').split(' ').join(',') << '}'
end

excludedDirectories = options[:exclude].gsub('\\', '/').split(' ')

globFilter = '**/*' << fileFilter

fileNames = Dir.glob(globFilter)

fileEntries = []

for fileName in fileNames
  isValid = true
  for excludedDir in excludedDirectories
    if fileName.start_with?(excludedDir)
      isValid = false
      break
    end
  end

  if isValid
    fileEntries << FileEntry.new(fileName, count_lines_in_file(fileName))
  end
end

if fileEntries.length == 0
  puts 'No files found'
  exit 0
end

fileEntries = fileEntries.sort_by(&:lines).reverse

maxFileNameLength = 0
maxLineCount = fileEntries[0].lines.to_s.length
totalLinesOfCode = 0

fileEntries.each do |entry|
  if entry.name.length > maxFileNameLength
    maxFileNameLength = entry.name.length
  end
  totalLinesOfCode += entry.lines
end

fileEntries.each do |entry|
  puts "#{entry.name.ljust(maxFileNameLength)} #{entry.lines.to_s.rjust(maxLineCount)}"
end

puts '_' * (maxFileNameLength + maxLineCount + 1)
puts "total #{totalLinesOfCode.to_s.rjust(maxLineCount + maxFileNameLength - 5)}"

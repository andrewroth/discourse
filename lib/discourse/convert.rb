files = Dir.glob("*")
files.each do |f|
  unless File.directory?(f) || f == "convert.rb"
    contents = File.read(f)
    puts f
    new_contents = "module Discourse\n#{contents.split("\n").collect{ |s| "  #{s}" }.join("\n")}\nend"
    puts new_contents
    File.open(f, "w") do |out|
      out.write(new_contents)
    end
  end
end

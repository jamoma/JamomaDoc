#!/usr/bin/ruby -wKU
# TAP: changed the above so that on the Mac it always uses the version of ruby installed by the OS
# this is because version 1.8.7 works, but 1.9.1 does not
#/usr/bin/env ruby -wKU

require "FileUtils"

libdir = "."
Dir.chdir libdir
libdir = Dir.pwd

# we search all refpages categories (Foundation, Modular, DSP, etc.)
refsCat = Dir.entries("./Max/refpages/")
refsCat.delete_if {|nonFolder| nonFolder =~ /^\./} # we remove "." and ".." entries

puts "=========================\n"
puts "WRITING LIST OF MODULES FILE"
puts "=========================\n"

puts refsCat

f = File.new("./Max/refpages/jdoc_ref_modules.xml", "a+")
f.write("<?xml version='1.0' encoding='UTF-8' standalone='yes'?>\n<root>\n")
refsCat.each do |m|
  f.write("<module>\n")
  f.write("#{m}\n")
  f.write("</module>\n")
end
f.write("</root>")
f.close

puts "DONE\n=========================\n"


# search = `find . -name *maxref.yml` # Does this only work on OSX ?
# 
# puts search
# 
# maxrefs = Array::new
# maxrefs = search.split("\n")
# # Create refpages folder and copy XLS file for Max 5  - comment this out if you don't want it
# FileUtils.mkdir_p("/Applications/Max5/patches/docs/refpages/jamoma-ref") unless File.exist?("/Applications/Max5/patches/docs/refpages/jamoma-ref")
# `cp "#{libdir}/max/support/refpages/jamoma/_jdoc_ref.xsl" /Applications/Max5/patches/docs/refpages/jamoma-ref`
# # Create refpages folder and copy XLS file for Max 6  - comment this out if you don't want it
# FileUtils.mkdir_p("/Applications/Max6/patches/docs/refpages/jamoma-ref") unless File.exist?("/Applications/Max6/patches/docs/refpages/jamoma-ref")
# `cp "#{libdir}/max/support/refpages/jamoma/_jdoc_ref.xsl" /Applications/Max6/patches/docs/refpages/jamoma-ref`
# 
# maxrefs.each do |ref|
#  dest = ref.sub(/\.(.*jcom.*maxref)\.yml/,"#{libdir}"'\1.xml')
#  ref = ref.sub(/\.(.*jcom.*maxref.yml)/,"#{libdir}"'\1')
# `ruby #{libdir}/yaml-to-maxref.rb #{ref} #{dest}`
# # Copy refpages into Max 5  - comment this out if you don't want it
# `cp #{dest} /Applications/Max5/patches/docs/refpages/jamoma-ref`
# # Copy refpages into Max 6  - comment this out if you don't want it
# `cp #{dest} /Applications/Max6/patches/docs/refpages/jamoma-ref`
# 
# end

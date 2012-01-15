#!/usr/bin/ruby -wKU
# TAP: changed the above so that on the Mac it always uses the version of ruby installed by the OS
# this is because version 1.8.7 works, but 1.9.1 does not
#/usr/bin/env ruby -wKU

require "FileUtils"

libdir = "."
Dir.chdir libdir
libdir = Dir.pwd

# JamomaDocLib contains xml IO and specific doc methods (refpages, tutorials, etc. parsers)
require "#{libdir}/Tools/JamomaDocLib"

# =================================
# SETUP
# =================================

# create the folder structure we need
FileUtils.mkdir_p("#{libdir}/Jamoma-doc/refpages")


# =================================
# PROCESS REFPAGES
# =================================

# build a table of content of all categories (Foundation, Modular, DSP, etc.)
projects = Dir.entries("#{libdir}/Max/refpages/")

refDir = YamlToMaxDoc.new
refDir.moduleTOC(projects)
refDir.write("#{libdir}/Jamoma-doc/refpages/_jdoc_ref_modules.xml")

puts "****** building Table of content for: ******\n"
puts projects
puts "\n-> #{libdir}/Jamoma-doc/refpages/_jdoc_ref_modules.xml"
puts "\nDONE\n"

# build table of content of refpages
projects.each do |project|
  refs = Dir.entries("#{libdir}/Max/refpages/#{project}/")
  
  puts "BUILDING TABLE OF CONTENT OF ALL REFPAGES IN #{project}"
  toc = YamlToMaxDoc.new
  toc.refpagesTOC(refs)
  toc.write("#{libdir}/Jamoma-doc/refpages/#{project}/_jdoc_contents.xml")

# write refpage  
  refs.each do |jcom|
    puts "WRITING REFERENCE PAGE FOR #{jcom}"
    dest = jcom.sub(/(.*maxref).yml/,'\1.xml')
    ref = YamlToMaxDoc.new
    ref.makeRefpage("#{libdir}/Max/refpages/#{project}/#{jcom}")
    ref.write("#{libdir}/Jamoma-doc/refpages/#{project}/#{dest}")
  end
end

  
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

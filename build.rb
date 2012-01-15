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
src = "#{libdir}/Max"
dst = "#{libdir}/Jamoma-doc"

# create the folder structure we need
FileUtils.remove_entry("#{dst}") if File.exist?("#{dst}")
FileUtils.mkdir_p("#{dst}/refpages")
#FileUtils.mkdir_p("#{dst}/refpages/jamomaAudioGraph-ref")
#FileUtils.mkdir_p("#{dst}/refpages/jamomaDSP-ref")
FileUtils.mkdir_p("#{dst}/refpages/jamomaFoundation-ref")
FileUtils.mkdir_p("#{dst}/refpages/jamomaGraph-ref")
#FileUtils.mkdir_p("#{dst}/refpages/jamomaGraphics-ref")
FileUtils.mkdir_p("#{dst}/refpages/jamomaModular-ref")
FileUtils.mkdir_p("#{dst}/refpages/jamomaPlugtastic-ref")


# =================================
# PROCESS REFPAGES
# =================================

# build a table of content of all categories (Foundation, Modular, DSP, etc.)
projects = Dir.entries("#{src}/refpages/")

refDir = YamlToMaxDoc.new
refDir.moduleTOC(projects)
refDir.write("#{dst}/refpages/_jdoc_ref_modules.xml")

puts "\nBUILDING TABLE OF CONTENT OF JAMOMA PROJECTS\n"
puts projects
puts "\n-> #{dst}/refpages/_jdoc_ref_modules.xml\n"

# build table of content of refpages
projects.each do |project|
  refs = Dir.entries("#{src}/refpages/#{project}/")
  
  puts "\nBUILDING TABLE OF CONTENT OF ALL REFPAGES IN #{project}"
  toc = YamlToMaxDoc.new
  toc.refpagesTOC(refs)
  toc.write("#{dst}/refpages/jamoma#{project}-ref/_jdoc_contents.xml")
  
  puts "\n-> #{dst}/refpages/jamoma#{project}-ref/_jdoc_contents.xml\n\n"

# write refpage  
  refs.each do |jcom|
    puts "WRITING REFERENCE PAGE FOR #{jcom}"
    dest = jcom.sub(/(.*maxref).yml/,'\1.xml')
    ref = YamlToMaxDoc.new
    ref.makeRefpage("#{src}/refpages/#{project}/#{jcom}")
    ref.write("#{dst}/refpages/jamoma#{project}-ref/#{dest}")
  end
end

puts "================== DONE =================="


# =================================
# COPYING XSL FILES AND STUFF
# =================================

projects.each do |project|
FileUtils.copy("#{src}/support/refpages/jamoma/_jdoc_ref.xsl", "#{dst}/refpages/jamoma#{project}-ref/_jdoc_ref.xsl")
end


# =================================
# INSTALLING
# =================================
maxVersion = ["Max5", "Max6"]

maxVersion.each do |v|
  FileUtils.copy_entry("#{dst}/refpages", "/Applications/#{v}/patches/docs/refpages")
end
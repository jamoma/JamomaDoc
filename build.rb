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


puts" "
puts"Building Jamoma Documentation"
puts"==================================================="

# =================================
# SETUP
# =================================
dst = "#{libdir}/Builds/Jamoma-doc"

# create the folder structure we need
FileUtils.remove_entry("#{dst}") if File.exist?("#{dst}")


Dir.chdir("../.")
# removing useless stuff
projects = Dir.entries(".")
projects.delete_if {|nonFolder| nonFolder =~ /^\./} # we remove entries starting with a dot
projects.delete("Support")
projects.delete("Documentation")

projectsTOC = Array::new

projects.each do |project|
  Dir.chdir("#{project}")

  search = `find . -name jcom*maxref.yml`
  refs = search.split("\n")

# =================================
# PROCESS REFPAGES
# =================================
  unless refs.empty?
    puts "\n-------- #{project} --------\n"
    FileUtils.mkdir_p("#{dst}/refpages/Jamoma#{project}")

    projectsTOC.push("#{project}") #if there are some refpages, we add the Jamoma Module to the table of content array
    puts "WRITING REFPAGES\n"
    refs.each do |jcom|

      refName = jcom.sub(/.*(jcom.*maxref).yml/,'\1.xml')
      imagePath = jcom.sub(/(.*jcom.*).maxref.yml/,'\1.maxref.png')
      imageName = imagePath.sub(/.*(jcom.*maxref.png)/, '\1')

      puts "Writing reference page for #{refName}..."
      ref = YamlToMaxDoc.new
      ref.makeRefpage("#{jcom}")
      ref.write("#{libdir}/Builds/Jamoma-doc/refpages/Jamoma#{project}/#{refName}")
        if File.exist?(imagePath) then
          FileUtils.mkdir("#{dst}/refpages/Jamoma#{project}/images") unless File.exist?("#{dst}/refpages/Jamoma#{project}/images")
          FileUtils.copy_entry("#{imagePath}", "#{dst}/refpages/Jamoma#{project}/images/#{imageName}")
        end

    end
# =================================
# PROCESS REFPAGES TABLE OF CONTENT
# =================================

    puts "\n"
    puts "BUILDING TABLE OF CONTENT OF ALL REFPAGES IN JAMOMA#{project.upcase}"
    puts "\n"
    toc = YamlToMaxDoc.new
    toc.refpagesTOC(refs)
    toc.write("#{dst}/refpages/Jamoma#{project}/_jdoc_contents.xml")

    FileUtils.copy("#{libdir}/Max/support/refpages/jamoma/_jdoc_ref.xsl", "#{dst}/refpages/Jamoma#{project}/_jdoc_ref.xsl")

  end

  Dir.chdir("../.")

end

# =================================
# PROCESS JAMOMA MODULES TABLE OF CONTENT
# =================================

refDir = YamlToMaxDoc.new
refDir.moduleTOC(projectsTOC)
refDir.write("#{dst}/refpages/_jdoc_ref_modules.xml")

# =================================
# COPYING CSS AND XSL STUFF
# =================================
FileUtils.copy("#{libdir}/Max/support/refpages/_jdoc_ref_common.xsl", "#{dst}/refpages")
FileUtils.copy("#{libdir}/Max/support/_jdoc_common.css", dst)
FileUtils.copy("#{libdir}/Max/support/_jdoc_common.xml", dst)
FileUtils.copy("#{libdir}/Max/support/_jdoc_common.xsl", dst)
FileUtils.copy("#{libdir}/Max/support/_jdoc_compat.html", dst)
FileUtils.copy("#{libdir}/Max/support/_jdoc_platform.xsl", dst)

# =================================
# INSTALLING
# =================================

puts "--------\nCOPYING REFPAGES IN MAX FOLDER\n"
maxVersion = ["Max5", "Max6"]

maxVersion.each do |v|
  FileUtils.copy_entry("#{libdir}/Builds", "/Applications/#{v}/patches")
end

puts "\n=================DONE===================="
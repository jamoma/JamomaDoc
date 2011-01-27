#!/usr/bin/ruby -wKU
# TAP: changed the above so that on the Mac it always uses the version of ruby installed by the OS
# this is because version 1.8.7 works, but 1.9.1 does not
#/usr/bin/env ruby -wKU

#TODO redirect nanoc output to Terminal
glibdir = "."
Dir.chdir glibdir
glibdir = Dir.pwd

puts "\n\ncleaning...\n\n"
`rm -rd #{glibdir}/Tools/nanoc/content`
`rm -rd #{glibdir}/build`

puts "Copying Jamoma Documentation"
puts "==================================================="
`cp -R #{glibdir}/Modular/Text/ #{glibdir}/Tools/nanoc/content`
`cp -R #{glibdir}/Tools/htmlLib/css #{glibdir}/Tools/nanoc/content`
`cp -R #{glibdir}/Tools/htmlLib/js #{glibdir}/Tools/nanoc/content`

puts "\n\nCompiling Jamoma Documentation using nanoc"
puts "==================================================="

Dir.chdir "#{glibdir}/Tools/nanoc"

nanocOutput = `nanoc compile`
puts nanocOutput
puts "=================DONE===================="

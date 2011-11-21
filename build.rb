#!/usr/bin/ruby -wKU
# TAP: changed the above so that on the Mac it always uses the version of ruby installed by the OS
# this is because version 1.8.7 works, but 1.9.1 does not
#/usr/bin/env ruby -wKU

glibdir = "."
Dir.chdir glibdir
glibdir = Dir.pwd

search = `find . -name *maxref.yml` #Does this only work on OSX ?

puts search

maxrefs = Array::new
maxrefs = search.split("\n")

maxrefs.each do |ref|
 dest = ref.sub(/\.(.*jcom.*maxref)\.yml/,"#{glibdir}"'\1.xml')
 ref = ref.sub(/\.(.*jcom.*maxref.yml)/,"#{glibdir}"'\1')
`ruby #{glibdir}/yaml-to-maxref.rb #{ref} #{dest}`

end
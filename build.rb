#!/usr/bin/env ruby -wKU

#TODO redirect nanoc output to Terminal
glibdir = "."
Dir.chdir glibdir
glibdir = Dir.pwd

`cp -R #{glibdir}/Modular/Text/ #{glibdir}/Tools/nanoc/content`
`cp -R #{glibdir}/Tools/htmlLib/css #{glibdir}/Tools/nanoc/content`
`cp -R #{glibdir}/Tools/htmlLib/js #{glibdir}/Tools/nanoc/content`

Dir.chdir "#{glibdir}/Tools/nanoc"

`nanoc co`


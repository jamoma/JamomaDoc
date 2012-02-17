glibdir = "."
Dir.chdir glibdir             # change to libdir so that requires work
glibdir = Dir.pwd
puts glibdir

require "FileUtils"

def makePatch (myModule)
  # if File.exist?("#{clippingsPath}/#{moduleCategory}")
  if File.exist?("./te st")
    f = File.open("./test/#{myModule}.maxpat", "w+")
    f.write("{
       \"patcher\" :   {
         \"fileversion\" : 1,
         \"rect\" : [ 84.0, 59.0, 640.0, 480.0 ],
         \"bglocked\" : 0,
         \"defrect\" : [ 84.0, 59.0, 640.0, 480.0 ],
         \"openrect\" : [ 0.0, 0.0, 0.0, 0.0 ],
         \"openinpresentation\" : 0,
         \"default_fontsize\" : 12.0,
         \"default_fontface\" : 0,
         \"default_fontname\" : \"Arial\",
         \"gridonopen\" : 0,
         \"gridsize\" : [ 15.0, 15.0 ],
         \"gridsnaponopen\" : 0,
         \"toolbarvisible\" : 1,
         \"boxanimatetime\" : 200,
         \"imprint\" : 0,
         \"enablehscroll\" : 1,
         \"enablevscroll\" : 1,
         \"devicewidth\" : 0.0,
         \"boxes\" : [       {
             \"box\" :         {
               \"args\" : [  ],
               \"bgmode\" : 1,
               \"id\" : \"obj-1\",
               \"maxclass\" : \"bpatcher\",
               \"name\" : \"#{myModule}\",
               \"numinlets\" : 10,
               \"numoutlets\" : 10,
               \"outlettype\" : [ \"\", \"\", \"\" ],
               \"patching_rect\" : [ 5.0, 3.0, 300.0, 70.0 ],
               \"presentation_rect\" : [ 0.0, 0.0, 300.0, 70.0 ]
             }

           }
      ],
         \"lines\" : [  ]
       }
    }")
    f.close
  else
    # FileUtils.makedir("#{clippingsPath}/#{moduleCategory}")
    FileUtils.mkdir("./te st/")
    # puts "Creating #{moduleCategory} directory"
    f = File.open("./te st/#{myModule}.maxpat", "w+")
    f.write("{
       \"patcher\" :   {
         \"fileversion\" : 1,
         \"rect\" : [ 84.0, 59.0, 640.0, 480.0 ],
         \"bglocked\" : 0,
         \"defrect\" : [ 84.0, 59.0, 640.0, 480.0 ],
         \"openrect\" : [ 0.0, 0.0, 0.0, 0.0 ],
         \"openinpresentation\" : 0,
         \"default_fontsize\" : 12.0,
         \"default_fontface\" : 0,
         \"default_fontname\" : \"Arial\",
         \"gridonopen\" : 0,
         \"gridsize\" : [ 15.0, 15.0 ],
         \"gridsnaponopen\" : 0,
         \"toolbarvisible\" : 1,
         \"boxanimatetime\" : 200,
         \"imprint\" : 0,
         \"enablehscroll\" : 1,
         \"enablevscroll\" : 1,
         \"devicewidth\" : 0.0,
         \"boxes\" : [       {
             \"box\" :         {
               \"args\" : [  ],
               \"bgmode\" : 1,
               \"id\" : \"obj-1\",
               \"maxclass\" : \"bpatcher\",
               \"name\" : \"#{myModule}\",
               \"numinlets\" : 10,
               \"numoutlets\" : 10,
               \"outlettype\" : [ \"\", \"\", \"\" ],
               \"patching_rect\" : [ 5.0, 3.0, 300.0, 70.0 ],
               \"presentation_rect\" : [ 0.0, 0.0, 300.0, 70.0 ]
             }

           }
      ],
         \"lines\" : [  ]
       }
    }")
    f.close
  end
end

makePatch("jmod.degrade~")
makePatch("jmod.echo~")
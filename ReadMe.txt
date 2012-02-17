--------------------------------------------------
JAMOMA DOCUMENTATION REPOSITORY
--------------------------------------------------

This is the repository for everything documentation-related. Here are hosted various pieces of reference files, tutorials, etc. for Max implementation as well as some documentation on Jamoma API



--------------------------------------------------
BUILDING THE DOCUMENTATION
--------------------------------------------------

* BUILDING THE DOCUMENTATION

A Ruby script is provided in the repository to automatically compile the documentation.From a Terminal window, type the following command to build the documentation:

ruby build.rb


--------------------------------------------------
WRITING DOCUMENTATION
--------------------------------------------------
* PREFERRED FORMAT

Max's refpages are written as in yaml. There are automatically converted as xml files by the build.rb script. Use the provided template (./Tools/jcom.object-template.maxref.yml) to get you started.

Max's tutorials and vignette are written as Textile format as much as possible since it proves to be light, easy to maintain and can be exported in various format. A template is also provided (./Tools/TextileTemplate.textile).


* REGARDING THE USE OF BRANCHES

The 'master' branch is where all documents ready to be published are to reside. Note that all materials in the master branch are automatically converted from textile to html when building the Jamoma installer. 

Thus, when starting to work on a tutorial or documentation bit, it is advised to work on the "unpublished" branch or create a specific branch if needed. Once you are done with writing the documentation part, merge the branch into 'master' or use Git 'cherry-pick' command.
--------------------------------------------------

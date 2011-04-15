--------------------------------------------------
JAMOMADOC REPOSITORY
--------------------------------------------------

This is the repository for everything documentation-related. Here are hosted various pieces of reference files, tutorials, etc.



--------------------------------------------------
BUILDING THE DOCUMENTATION
--------------------------------------------------
* DEPENDENCIES

The documentation can be compiled as HTML files. Compilation is done using Ruby and two Ruby gems:

- A static web site generator: nanoc (http://nanoc.stoneship.org/)
- A set of utilities for nanoc: nutils (https://github.com/arnau/Nutils)

All other dependencies are taken care of by these two gems.


* INSTALLATION OF NANOC & NUTILS

If you use a Ruby version < 1.9, first make sure the package manager called Rubygems is installed. Visit the url below and follow the instructions.

http://rubygems.org/pages/download

If you use a Ruby version > 1.9, Rubygems is installed by default.

Then you can install nanoc and nutils by running these two commands from a terminal window:

sudo gem install nanoc
sudo gem install nutils

Note that you can find some additionnal informations on nanoc website: http://nanoc.stoneship.org/docs/2-installation/#installing-nanoc


* BUILDING THE DOCUMENTATION

A Ruby script is provided in the repository to automatically compile the documentation.From a Terminal window, type the following command to build the documentation:

ruby build.rb


--------------------------------------------------
WRITING DOCUMENTATION
--------------------------------------------------
* PREFERRED FORMAT

We chose to write documentation as Textile format as much as possible since it proves to be light, easy to maintain and can be exported in various format. 

For people not familiar with Textile, there are some templates to get you started.

* REGARDING THE USE OF BRANCHES

The 'master' branch is where all documents ready to be published are to reside. Note that all materials in the master branch are automatically converted from textile to html when building the Jamoma installer. 

Thus, when starting to work on a tutorial or documentation bit, it is advised to work on the "unpublished" branch or create a specific branch if needed. Once you are done with writing the documentation part, merge the branch into 'master' or use Git 'cherry-pick' command.
--------------------------------------------------

DateStarted: 2014-01-04  
Title:	'Build & Test in the Jamoma Core'	
Author:	Nathan Wolek	  

---

#Build & Test in the Jamoma Core

Note: written in response to [Core Issue \#166](https://github.com/jamoma/JamomaCore/issues/166)

##Opening remarks

* [The Pragmatic Programmer](http://pragprog.com/the-pragmatic-programmer): Hunt & Thomas emphasize "ruthless testing"
* Recap benefits of integrated testing 
* [SMC 2012 paper](http://jamoma.org/publications/attachments/smc2012-testing.pdf)

##Comparison

###The old way with Ruby

1. write a test method 
2. build C++ library 
3. build [Ruby language bindings](https://github.com/jamoma/JamomaRuby) 
4. run Ruby script to call “test” message 
5. read results and figure out where your code went wrong

Alternatively: you could also send the "test" message to an object in the Max. This however adds the extra step of compiling the Max Implementation, opening Max, instantiating the object, etc.

###Issues

* too many steps 
* remembering to re-build Ruby each time 
* potentially switching between development tools (IDE & command line)

###The new way in IDE

1. write a test method 
2. build C++ library 
3. if test assertion fails, IDE will stop build and point you to line in code

###Benefits

* immediate feedback during build whenever something breaks 
* easier to code via [test driven development](http://en.wikipedia.org/wiki/Test-driven_development) or [red-green-refactor](http://www.jamesshore.com/Blog/Red-Green-Refactor.html) approach 
* should encourage development of more unit tests

##How it works

###Basis in these design features

* **Objects derive from a single superclass.** This superclass contains a template for a [test method](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L120) and it also registers [the test message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/source/TTDataObjectBase.cpp#L38).
* **Tags are used by each object.** In general, tags allow us to group objects based on common features and make them searchable. Here, it allows us to target only the objects we are interested in testing for the given project and avoid any dependencies. These largely mirrored the "ingroup" tags that were already in place for Doxygen. For example: in the DSP library we look for [this tag](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/source/TTDataObjectBase.cpp#L38), but in the FilterLib extension, we look for [this tag](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/test.cpp#L25). Tags should be defined near the head of each cpp file via [\#define like this](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/source/TTHalfband9.cpp#L13). 
> @tap - We do define the tags with a preprocessor #define in 99% of cases, but this is relies on using the macro system throughout (e.g. [TT_AUDIO_CONSTRUCTOR](https://github.com/jamoma/JamomaCore/blob/master/DSP/library/includes/TTDSP.h#L49) for the the constructor instead of e.g. "TTAllpass1a::TTAllpass1a").  It's subtle but for a paper it should be specific.  I guess for a blog post it can be glossed over. 

###The steps

1. makefile now looks for test.cpp file in a [given project](https://github.com/jamoma/JamomaCore/blob/dev/Shared/jamomalib.rb#L1708) - if present, it runs 
2. test.cpp in each project searches for classes registered with a specified tag. 
3. Once a list is generated, the test.cpp program runs through the list of classes and calls the “test” message for each one. If no customized test method is specified, we get a [harmless message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L126) suggesting that we should create one. If it has been customized, the test method runs. 
4. IDE is now aware of the various test assertions. If one fails, the build will stop and IDE will highlight the line where an assertion failed. 
5. Since you know your test failed and what code lead to the failure, you can easily refactor until it works.


###What our C++ developers need to know

* Every existing library and extension is now setup to take advantage of the build & test system on the “dev” branch. [See Issue \#131](https://github.com/jamoma/JamomaCore/issues/131). 
* If an assertion in your test fails, the project that contains it will not build. You should either solve the problem OR comment out the assertion and log an issue on GitHub.

###What our C++ developers need to do

1. Write a customized test method for each object class. 
2. Make sure any new object classes you create include the tag for that existing project. This is easily found in the test.cpp file of the relevant directory. 
3. If you are creating a new library or extension, the work is more involved. Since this is unlikely to happen without consulting other developers, I will leave it for another time.

##Shortcomings & Future Work

Notes from @tap:

* For a paper we should also list the shortcomings -- In Xcode for example, the number of messages from the invocation to Make is truncated at 200 lines (maybe there is a way to change that?) -- which means you might not see all of the results or you might not see *any* results if your code generates too many warnings (including deprecation warnings).

* We should always strive for warning-free code, but at some points in the development cycle (e.g. migrating to newer APIs) having a lot of warnings is just part of the process and this trips it up a bit.

* Additionally, for a paper, we should list future work.  One place we try to expand is in the syntax for writing tests to make it more expressive and less tedious.  We could initially try this with some fancy macros or templates.  The idea being that our tests currently look like an over-decorated Christmas tree with too much tinsel which detracts from our examination of the tree itself.

* Finally, for a paper, we should talk about how this system currently uses the actual Foundation code -- which is presumably minimal.  This is as opposed to using "mocks" (classes which are like stubs for the real thing, but maybe do something minimal).  We could also create mock classes for some testing scenarios -- the NodeLib for example where maybe we don't want a test to actually require unbounded network access -- but for most of what we are doing the basic classes are already minimal.

* As hinted at earlier, maybe we could also do something in the testing context to improve logging.  Maybe set a flag in Foundation that redirects most messages to a separate log file that we can examine?

##Conclusion

* If you notice an odd behavior, create a test that demonstrates the problem and fails each time you build. You can then work on a fix and know when immediately when you have a solution. 
* If you are adding features, make sure you build tests at the same time.

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

###The old way

1. write a test method 
2. build C++ library 
3. build [Ruby language bindings](https://github.com/jamoma/JamomaRuby) 
4. run Ruby script to call “test” message 
5. read results and figure out where your code went wrong

###Issues

* too many steps 
* remembering to re-build Ruby each time 
* potentially switching between development environments (Xcode & command line)

###The new way

1. write a test method 
2. build C++ library 
3. if test assertion fails, Xcode will stop build and point you to line in code

###Benefits

* immediate feedback during build whenever something breaks 
* easier to code via [test driven development](http://en.wikipedia.org/wiki/Test-driven_development) or [red-green-refactor](http://www.jamesshore.com/Blog/Red-Green-Refactor.html) approach 
* should encourage development of more unit tests

##How it works

Before "how" it is important to understand "why": objects derive from a single superclass with template for a [test method](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L120) and it also registers [the test message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/source/TTDataObjectBase.cpp#L38).

1. makefile now looks for test.cpp file in a [given project](https://github.com/jamoma/JamomaCore/blob/dev/Shared/jamomalib.rb#L1708) - if present, it runs 
2. test.cpp in each project searches for registered classes with a specified tag. For example: in the DSP library we look for [this tag](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/source/TTDataObjectBase.cpp#L38), but in the FilterLib extension, we look for [this tag](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/test.cpp#L25). Tags should be defined near the head of each cpp file via [\#define like us](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/source/TTHalfband9.cpp#L13).
3. Once a list is generated, the test.cpp program runs through the list of classes and calls the “test” message for each one. If no customized test method is specified, we get a [harmless message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L126) suggesting that we should create one. If it has been customized, the test method runs. 
4. Xcode is now aware of the various test assertions. If one fails, the build will stop and Xcode will highlight the line where an assertion failed. 
5. Since you know your test failed and what code lead to the failure, you can easily refactor until it works.


###What our C++ developers need to know

* Every existing library and extension is now setup to take advantage of the build & test system on the “dev” branch. [See Issue \#131](https://github.com/jamoma/JamomaCore/issues/131). 
* If an assertion in your test fails, the project that contains it will not build. You should either solve the problem OR comment out the assertion and log an issue on GitHub.

###What our C++ developers need to do

1. Write a customized test method for each object class. 
2. Make sure any new object classes you create include the tag for that existing project. This is easily found in the test.cpp file of the relevant directory. 
3. If you are creating a new library or extension, the work is more involved. Since this is unlikely to happen without consulting other developers, I will leave it for another time.

##Conclusion

* If you notice an odd behavior, create a test that demonstrates the problem and fails each time you build. You can then work on a fix and know when immediately when you have a solution. 
* If you are adding features

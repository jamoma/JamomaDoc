DateStarted: 2014-01-20  
Title:	'Build & Test in the Jamoma Core'	
Author:	Nathan Wolek	  

---

#Build & Test in the Jamoma Core

In their book [The Pragmatic Programmer](http://pragprog.com/the-pragmatic-programmer), Hunt & Thomas encourage readers to engage in "ruthless testing". Their ideas are summarized by a three-part message: "Test Early. Test Often. Test Automatically." 

On the Jamoma team, we couldn't agree more. We have worked hard for several years to develop automatic tests at both the unit and integration levels, something that was first written about in an [SMC 2012 paper](http://jamoma.org/publications/attachments/smc2012-testing.pdf). 

Last summer during our [workshop in Albi](http://www.gmea.net/activite/recherche/colloques/jamoma.htm), several developers started a conversation about improvements to our unit testing practices. In particular, we wanted a system that was *more* automatic and required fewer manual steps to be performed by the programmer.

In the months that followed, we collaborated on a solution that we now call **Build & Test**.

##Comparison

###The old way using Ruby

Prior to Build & Test, myself and other C++ developers on Jamoma would follow a multi-step process for unit testing that went something like this:

1. [write a test method](http://api.jamoma.org/chapter_unittesting.html#chapter_unittesting_writingtests) 
2. build the C++ library that contained the test
3. build the [Ruby language bindings](https://github.com/jamoma/JamomaRuby) 
4. run Ruby script to call the “test” message for an object
5. read results posted in the Terminal and figure out where your code went wrong

The Terminal output from Ruby would look something like this:

	Test checkout of first SampleMatrix...
		PASS -- checkOutMatrix returns a valid pointer
		PASS -- numChannels is set properly
		PASS -- userCount reports proper value
		PASS -- bufferPoolStage reports proper value
		
	Test second checkout of first SampleMatrix...
		PASS -- checkOutMatrix returns the same pointer
		PASS -- userCount reports proper value after second checkout
		
	Test if changing lengthInSamples attribute spawns new SampleMatrix...
		PASS -- checkOutMatrix returns pointer to different SampleMatrix
		PASS -- userCount reports proper value
		
	Repeat with numChannels attribute...
		PASS -- checkOutMatrix returns pointer to different SampleMatrix
		PASS -- userCount reports proper value
		
	At this point, 3 SampleMatrix objects are checked out via 4 pointers:
			myFirstCheckOut: userCount 2, Active 0, Becoming Idle 1
			myFirstCheckOut2: userCount 2, Active 0, Becoming Idle 1
			mySecondCheckOut: userCount 1, Active 0, Becoming Idle 1
			myThirdCheckOut: userCount 1, Active 1, Becoming Idle 0
		
	Testing check in process...
		PASS -- checkInMatrix(myFirstCheckOut) resets pointer to NULL
		PASS -- myFirstCheckOut2 is still a valid pointer
		PASS -- poke/peek sample value still works
		PASS -- checkInMatrix(myFirstCheckOut2) resets pointer to NULL
		PASS -- checkInMatrix(mySecondCheckOut) resets pointer to NULL
		PASS -- checkInMatrix(myThirdCheckOut) resets pointer to NULL
		

			Number of assertions: 16
			Number of failed assertions: 0


Alternatively: you could also send the "test" message to an object in the Max. However, this adds more manual steps like building the [Max Implementation](https://github.com/jamoma/JamomaMax), opening Max, instantiating the object, etc.

###Issues

If the goal is to "test automatically", then frankly the old way didn't acheive it. It's certainly better than no testing at all, but having too many manual steps often lead to missteps by the developer. Personally, I would often lose time because I forgot to rebuild the Ruby language bindings, which results in testing old code without the corrections I was working on. It was also a mildly frustrating that I was constantly  compiling a library in Xcode, then switching to the Terminal to run my test in Ruby via the command line. 

So the questions we started asking in Albi were:

* Can this be more automatic?
* Could we automate the Ruby steps somehow so we don't forget something?
* Or do we need to rely on Ruby to run tests at all?
* Wouldn't it be better if we could stay in one place (the IDE)?

###The new way using the IDE

In the months that followed, the Build & Test solution provided some satisfying answers to these questions. Now the steps for testing your code look something like this:

1. [write a test method](http://api.jamoma.org/chapter_unittesting.html#chapter_unittesting_writingtests) 
2. build the C++ library that contained the test
3. if test assertion fails, IDE will stop build and point you to line in code

###Benefits

* immediate feedback during build whenever something breaks 
* easier to code via [test driven development](http://en.wikipedia.org/wiki/Test-driven_development) or [red-green-refactor](http://www.jamesshore.com/Blog/Red-Green-Refactor.html) approach 
* should encourage development of more unit tests

##How it works

###Basis in these design features

* **Objects derive from a single superclass.** This superclass contains a template for a [test method](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L120) and it also registers [the test message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/source/TTDataObjectBase.cpp#L38).
* **Tags are used by each object.** In general, tags allow us to group objects based on common features and make them searchable. Here, it allows us to target only the objects we are interested in testing for the given project and avoid any dependencies. For example: in the DSP library we look for [this tag](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/source/TTDataObjectBase.cpp#L38), but in the FilterLib extension, we look for [this tag](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/test.cpp#L25). Tags should be defined near the head of each cpp file via [\#define like this](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/source/TTHalfband9.cpp#L13). 
> @tap - We do define the tags with a preprocessor #define in 99% of cases, but this is relies on using the macro system throughout (e.g. [TT_AUDIO_CONSTRUCTOR](https://github.com/jamoma/JamomaCore/blob/master/DSP/library/includes/TTDSP.h#L49) for the the constructor instead of e.g. "TTAllpass1a::TTAllpass1a").  It's subtle but for a paper it should be specific.  I guess for a blog post it can be glossed over. 

###The steps

1. makefile now looks for test.cpp file in a [given project](https://github.com/jamoma/JamomaCore/blob/dev/Shared/jamomalib.rb#L1708) - if present, it runs 
2. test.cpp in each project searches for classes registered with a specified tag. 
3. Once a list is generated, the test.cpp program runs through the list of classes and calls the “test” message for each one. If no customized test method is specified, we get a [harmless message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L126) suggesting that we should create one. If it has been customized, the test method runs. 
4. IDE is now aware of the various test assertions. If one fails, the build will stop and IDE will highlight the line where an assertion failed. 
5. Since you know your test failed and what code lead to the failure, you can easily refactor until it works.

##Conclusion

###What our C++ developers need to know

* Every existing library and extension is now setup to take advantage of the build & test system on the “dev” branch. [See Issue \#131](https://github.com/jamoma/JamomaCore/issues/131). 
* If an assertion in your test fails, the project that contains it will not build. You should either solve the problem OR comment out the assertion and log an issue on GitHub.

###What our C++ developers need to do

1. Write a customized test method for each object class. 
2. Make sure any new object classes you create include the tag for that existing project. This is easily found in the test.cpp file of the relevant directory. 
3. If you are creating a new library or extension, the work is more involved. Since this is unlikely to happen without consulting other developers, I will leave it for another time.





* If you notice an odd behavior, create a test that demonstrates the problem and fails each time you build. You can then work on a fix and know when immediately when you have a solution. 
* If you are adding features, make sure you build tests at the same time.

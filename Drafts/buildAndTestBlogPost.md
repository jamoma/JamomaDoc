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

###The old way: using Ruby

Prior to Build & Test, myself and other C++ developers on Jamoma would follow a multi-step process for unit testing that went something like this:

1. [write a `test` method](http://api.jamoma.org/chapter_unittesting.html#chapter_unittesting_writingtests) 
2. build the C++ library that contained the test
3. build the [Ruby language bindings](https://github.com/jamoma/JamomaRuby) 
4. run the Ruby script to call the “test” message for an object
5. read the results posted in the Terminal and figure out where your code went wrong

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

If the goal is to "test automatically", then frankly the old way didn't achieve it. It's certainly better than no testing at all, but having too many manual steps often lead to missteps by the developer. Personally, I would often lose time because I forgot to rebuild the Ruby language bindings, which results in testing old code without the corrections I was working on. It was also a mildly frustrating that I was constantly  compiling a library in Xcode, then switching to the Terminal to run my test in Ruby via the command line. 

So the questions we started asking in Albi were:

* Can this be more automatic?
* Could we automate the Ruby steps somehow so we don't forget something?
* Or do we need to rely on Ruby to run tests at all?
* Wouldn't it be better if we could stay in one place (the IDE)?

###The new way: using the IDE

In the months that followed, the Build & Test solution provided some satisfying answers to these questions. Now the steps for testing your code look something like this:

1. [write a `test` method](http://api.jamoma.org/chapter_unittesting.html#chapter_unittesting_writingtests) 
2. build the C++ library that contained the test
3. if a test assertion fails, the IDE will stop its build and point you to a line in code

In Xcode, the error looks something like this:
![Xcode says my userCount didn't match expectations](images/TTBufferXcodeAssertionFail.png)

###Benefits

The biggest benefit is the ability to receive immediate feedback when something breaks. If a test exists and your changes to the code cause that test to fail, you get feedback from the IDE as soon as you try to build. This makes it much easier to code via [test driven development](http://en.wikipedia.org/wiki/Test-driven_development) or [red-green-refactor](http://www.jamesshore.com/Blog/Red-Green-Refactor.html) approach. Even if you don't take the extreme path and establish your tests first, the immediate feedback should  encourage our developers to spend more time making unit tests.

##How it works

###Design features

There were several key design decisions made earlier in the development of Jamoma that made our Build & Test solution relatively easy to implement:

1. **All objects derive from a single parent class.** The `TTDataObjectBase` class contains a template for a [`test` method](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L120) and it also registers [the "test" message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/source/TTDataObjectBase.cpp#L38). Inheritance then ensures that unit testing is built into every Jamoma object by default. 
* **Tags are used by each object.** In general, tags allow us to group objects and enable searching based on common features. Tags are typically defined near the head of each cpp file via preprocessor [`#define` statements](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/source/TTHalfband9.cpp#L13) and our [macros for class definition](https://github.com/jamoma/JamomaCore/blob/master/DSP/library/includes/TTDSP.h#L49) take care of the rest. 
* **Tags are searchable at runtime.** Jamoma provides the static method [`GetRegisteredClassNamesForTags`](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTObject.h#L74), which produces an array of all registered classes with a given tag. 

###Implementation

For Build & Test, we first defined a tag that was specific to each library or extension in the Jamoma Core and added it to existing classes. For example: in the DSP library we used [`dspLibrary`](https://github.com/jamoma/JamomaCore/blob/dev/DSP/library/test.cpp#L21), but in the FilterLib extension, we used [`dspFilterLib`](https://github.com/jamoma/JamomaCore/blob/dev/DSP/extensions/FilterLib/test.cpp#L25). 

The makefile for each project now looks for `test.cpp` file in a [given project](https://github.com/jamoma/JamomaCore/blob/dev/Shared/jamomalib.rb#L1708). If it is present, the build process will run it. The `test.cpp` file for each project contains a simple [`main` function](https://github.com/jamoma/JamomaCore/blob/dev/DSP/library/test.cpp) that runs at the end of the build. That `main` function essentially breaks down into 2 steps:

1. search for objects registered with a specified project tag
2. for each object, send it a "test" message

If no customized `test` method is specified for given object, we get a [harmless message](https://github.com/jamoma/JamomaCore/blob/dev/Foundation/library/includes/TTDataObjectBase.h#L126) suggesting that we should create one. If it has been customized, the test method runs. If an assertion fails, the build will stop and IDE will highlight the line where an assertion failed. 

##Conclusion

###What our C++ developers need to know

* Every existing library and extension is now setup to take advantage of the build & test system on the “dev” branch. [See Issue \#131](https://github.com/jamoma/JamomaCore/issues/131). 
* If an assertion in your test fails, the project that contains it will not build. You should either solve the problem OR comment out the assertion and log an issue on [our GitHub repository](https://github.com/jamoma/JamomaCore/issues?state=open).

###What our C++ developers need to do

1. Write a customized test method for each object class. 
2. Make sure any new object classes you create include the tag for that existing project. This is easily found in the test.cpp file of the relevant directory. 
3. If you are creating a new library or extension, the work is more involved. Since this is unlikely to happen without consulting other developers, I will leave it for another time.





* If you notice an odd behavior, create a test that demonstrates the problem and fails each time you build. You can then work on a fix and know when immediately when you have a solution. 
* If you are adding features, make sure you build tests at the same time.

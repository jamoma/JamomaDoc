/** @file
 *
 * @ingroup audioGraphLibrary
 *
 * @brief A simple C++ application that use Jamoma DSP and AudioGraph to generate an audio sweep
 *
 * @details In order to test this example, first compile it from Terminal using the "make" command.
 * Once compiled, run the application with the command "./sweepy" from terminal (on OSX).
 *
 * @authors Timothy Place, Trond Lossius
 *
 * @copyright Copyright © 2014, Timothy Place @n
 * This code is licensed under the terms of the "New BSD License" @n
 * http://creativecommons.org/licenses/BSD/
 */


#include <iostream>
#include "TTAudioGraphAPI.h"

// Tim: Can you add a comment here explaining what this does and why it is needed?
extern "C" TTErr TTLoadJamomaExtension_AudioGraphUtilityLib(void);
extern "C" TTErr TTLoadJamomaExtension_AudioEngine(void);
extern "C" TTErr TTLoadJamomaExtension_FilterLib(void);
extern "C" TTErr TTLoadJamomaExtension_GeneratorLib(void);

int main(int argc, const char * argv[])
{
	// 1: Initiate the AudioGraph
	TTAudioGraphInit();
	
	
	// 2: Load required extentions
	TTLoadJamomaExtension_AudioGraphUtilityLib();	// Load the Jamoma AudioGraph UtilityLib
	TTLoadJamomaExtension_AudioEngine();			// Load the Jamoma DSP #TTAudioEngine
	TTLoadJamomaExtension_FilterLib();				// Load the Jamoma DSP FilterLib extention
	TTLoadJamomaExtension_GeneratorLib();			// Load the Jamoma DSP GeneratorLib extention
	
	
	// 3: Create AudioGraph objects
	TTAudioGraphObject noise("noise");				// A noise generator
	TTAudioGraphObject filter("filter");			// An audio filter
	TTAudioGraphObject dac("dac");					// An audio output
	
	// 4. Set up the audio graph - this is done by connecting AudioGraph objects to their upstream neighboor
	//    The resulting graph will be noise - filter - dac
	filter.connectAudio(noise);						// Connect filter to noise, so that noise will be filtered
	dac.connectAudio(filter);						// Connect DAC to filter, so that we can listen to the filtered sound

	// 5. Set attributes of the various objects
	noise.set("maxNumChannels", 2);					// Generate stereo noise signal
	noise.set("outputNumChannels", 2);
	noise.set("numChannels", 2);
	filter.set("type", "lowpass.4");				// Use a lowpass filter...
	filter.set("frequency", 400.0);					// ...with a frequency of 400 Hz...
	filter.set("q", 38.0);							// .. and q = 38
	
	// Start audio...
	dac.send("start");
	
	// ...and keep processing audio until the user quit the application
	std::cout << "Press ctrl-c to quit.\n";
	while (true)
		;
    return 0;
}


//
//  main.cpp
//  sweepy
//
//  Created by Timothy Place on 1/28/14.
//  Copyright (c) 2014 Cycling '74. All rights reserved.
//

#include <iostream>
#include "TTAudioGraphAPI.h"

extern "C" TTErr TTLoadJamomaExtension_AudioGraphUtilityLib(void);
extern "C" TTErr TTLoadJamomaExtension_AudioEngine(void);
extern "C" TTErr TTLoadJamomaExtension_FilterLib(void);
extern "C" TTErr TTLoadJamomaExtension_GeneratorLib(void);

int main(int argc, const char * argv[])
{
	TTAudioGraphInit();
	TTLoadJamomaExtension_AudioGraphUtilityLib();
	TTLoadJamomaExtension_AudioEngine();	
	TTLoadJamomaExtension_FilterLib();
	TTLoadJamomaExtension_GeneratorLib();
	
	TTAudioGraphObject noise("noise");
	TTAudioGraphObject filter("filter");
	TTAudioGraphObject dac("dac");
	
	filter.connectAudio(noise);
	dac.connectAudio(filter);

	noise.set("maxNumChannels", 2);
	filter.set("type", "lowpass.4");
	filter.set("frequency", 400.0);
	filter.set("q", 38.0);
	
	dac.send("start");
	
	std::cout << "Press ctrl-c to quit.\n";
	while (true)
		;
    return 0;
}


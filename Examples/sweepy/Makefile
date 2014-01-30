NAME = sweepy

CC = /usr/bin/clang++

#########################################

SRC = sweepy.cpp 

#########################################

INCLUDES = -I../../../Core/Foundation/library/includes
INCLUDES += -I../../../Core/DSP/library/includes
INCLUDES += -I../../../Core/Graph/library/includes
INCLUDES += -I../../../Core/AudioGraph/library/includes

#########################################

LIBS = ../../../Core/Foundation/library/build/libJamomaFoundation.a
LIBS += ../../../Core/DSP/library/build/libJamomaDSP.a
LIBS += ../../../Core/Graph/library/build/libJamomaGraph.a
LIBS += ../../../Core/AudioGraph/library/build/libJamomaAudioGraph.a

LIBS += ../../../Core/DSP/extensions/AudioEngine/build/libAudioEngine.a
LIBS += ../../../Core/DSP/extensions/AudioEngine/portaudio/libportaudio-jamoma.a
LIBS += ../../../Core/DSP/extensions/FilterLib/build/libFilterLib.a
LIBS += ../../../Core/DSP/extensions/GeneratorLib/build/libGeneratorLib.a
LIBS += ../../../Core/AudioGraph/extensions/AudioGraphUtilityLib/build/libAudioGraphUtilityLib.a

LIBS += /System/Library/Frameworks/Carbon.framework/Versions/A/Carbon
LIBS += /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio
LIBS += /System/Library/Frameworks/AudioUnit.framework/Versions/A/AudioUnit
LIBS += /System/Library/Frameworks/AudioToolbox.framework/Versions/A/AudioToolbox

#########################################

OPTIONS = -msse3 -mfpmath=sse -gdwarf-2 -fvisibility=hidden
OPTIONS += -std=c++11 
OPTIONS += -stdlib=libc++ # -U__STRICT_ANSI__ -D__STDC_FORMAT_MACROS
WARNINGS = -Wall -Wno-unknown-pragmas -Wno-trigraphs
DEFINES = -DTT_PLATFORM_MAC

#########################################

CFLAGS = $(OPTIONS) $(DEFINES) $(INCLUDES) $(WARNINGS)
LDFLAGS = -mfpmath=sse $(OPTIONS) $(DEFINES) $(LIBS) $(WARNINGS)

#########################################

debug: 
	$(CC) $(CFLAGS) $(LDFLAGS) -O0 $(SRC) -o $(NAME)
	
release:
	$(CC) $(CFLAGS) $(LDFLAGS) -O3 $(SRC) -o $(NAME)

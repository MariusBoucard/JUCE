/*
  ==============================================================================

    This file was auto-generated and contains the startup code for a PIP.

  ==============================================================================
*/

#include "juce_audio_processors_headless/juce_audio_processors_headless.h"
#include "PluginAudioProcessor.h"

    //==============================================================================
    juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
    {
        //return new FaustPlugInAudioProcessor();
       // return new WebViewPluginAudioProcessorWrapper();
        return new PluginAudioProcessor();
    }


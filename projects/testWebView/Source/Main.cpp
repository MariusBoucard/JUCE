/*
  ==============================================================================

    This file was auto-generated and contains the startup code for a PIP.

  ==============================================================================
*/

#include <JuceHeader.h>
namespace juce {
#include "FaustPlugin.h"

    //==============================================================================
    juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
    {
        //return new FaustPlugInAudioProcessor();
        return new WebViewPluginAudioProcessorWrapper();
        //return new PluginAudioProcessor();
    }
}
#include "PluginAudioProcessor.h"
#include "dsp/ParameterSetup.h"


PluginAudioProcessor::PluginAudioProcessor()
    : AudioProcessor(BusesProperties().withInput("Input", AudioChannelSet::stereo())
          .withOutput("Output", AudioChannelSet::stereo()))
      , mParameters(*this, nullptr, "PARAMETERS", createParameterLayout())
      , mParameterSetup(mParameters)
      , mSkeletonProcessor(mParameters, mParameterSetup)
{
    for (auto* param : mParameters.processor.getParameters())
    {
        mParameters.addParameterListener(param->getName(152), this);
    }
}

PluginAudioProcessor::~PluginAudioProcessor() {
    for (auto* param : getParameters())
    {
        mParameters.removeParameterListener(param->getName(152), this);
    }
}

void PluginAudioProcessor::processBlock(AudioBuffer<float> &buffer, MidiBuffer &a) {
    mSkeletonProcessor.processBlock(buffer, a);
}

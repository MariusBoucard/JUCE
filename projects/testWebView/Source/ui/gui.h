#pragma once
#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_gui_extra/juce_gui_extra.h>

class RootViewComponent : public juce::AudioProcessorEditor
{
public:
    static int ROOT_WIDTH;
    static int ROOT_HEIGHT;

    RootViewComponent(juce::AudioProcessor& processor);
    ~RootViewComponent() override;

    void paint(juce::Graphics& g) override;
    void resized() override;

private:
    juce::AudioProcessor& mProcessor;

    std::unique_ptr<juce::WebBrowserComponent> mWebView;

    std::optional<juce::WebBrowserComponent::Resource>
    getResource(const juce::String& url);
    // Helper function to load the webapp
    void loadWebApp();

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(RootViewComponent)
};

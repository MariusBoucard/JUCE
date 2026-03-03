#include "gui.h"
#include <juce_gui_extra/juce_gui_extra.h>
#include "BinaryData.h"
#include "../dsp/Processor.h"

int RootViewComponent::ROOT_WIDTH = 900;
int RootViewComponent::ROOT_HEIGHT = 550;

RootViewComponent::RootViewComponent(juce::AudioProcessor& processor)
    : AudioProcessorEditor(processor)
    , mProcessor(processor)
{
    setSize(900, 550);
    mWebView = std::make_unique<juce::WebBrowserComponent>(
        juce::WebBrowserComponent::Options{}
            .withBackend(juce::WebBrowserComponent::Options::Backend::webview2)
    );

    addAndMakeVisible(mWebView.get());

    mWebView->goToURL("https://example.com");
   /* mWebView = std::make_unique<juce::WebBrowserComponent>(
        juce::WebBrowserComponent::Options{}
            .withBackend(juce::WebBrowserComponent::Options::Backend::webview2)
            .withWinWebView2Options(
                juce::WebBrowserComponent::Options::WinWebView2{}
                    .withUserDataFolder(
                        juce::File::getSpecialLocation(
                            juce::File::tempDirectory)))
            .withResourceProvider(
                [this](const juce::String& url)
                {
                    return getResource(url);
                },
                "app://local")
    );
    DBG("JUCE_USE_WIN_WEBVIEW2: " + juce::String(JUCE_USE_WIN_WEBVIEW2));
    addAndMakeVisible(mWebView.get());
    jassert(mWebView != nullptr);
   mWebView->goToURL("data:text/html,<h1>Hello</h1>");*/
}
std::optional<juce::WebBrowserComponent::Resource>
RootViewComponent::getResource(const juce::String& url)
{
    auto path = url == "/" ? "index.html"
                           : url.fromFirstOccurrenceOf("/", false, false);

    if (path == "index.html")
    {
        std::vector<std::byte> data;

        data.resize(BinaryData::index_htmlSize);

        std::memcpy(data.data(),
                    BinaryData::index_html,
                    BinaryData::index_htmlSize);

        return juce::WebBrowserComponent::Resource{
            std::move(data),
            "text/html"
        };
    }

    return std::nullopt;
}
RootViewComponent::~RootViewComponent()
{
    mWebView.reset();
}





void RootViewComponent::paint(juce::Graphics& g)
{
    // Background color (only visible if WebView doesn't cover entire area)
  //  g.fillAll(juce::Colours::black);
}

void RootViewComponent::resized()
{
    // Make the WebView fill the entire component
    if (mWebView != nullptr)
    {
        mWebView->setBounds(getLocalBounds());
    }
}
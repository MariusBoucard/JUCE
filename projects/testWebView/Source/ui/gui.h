#include "BinaryData.h"

// RootViewComponent.h
class RootViewComponent : public juce::AudioProcessorEditor
{
public:

    RootViewComponent(juce::AudioProcessor& p) : AudioProcessorEditor(p)
    {
        // 1. Configure Options
        auto options = juce::WebBrowserComponent::Options{}
        .withBackend(juce::WebBrowserComponent::Options::Backend::webview2)
        .withResourceProvider([this](const auto& url) {
            return getResource(url);
        });

        // 2. Initialize WebView
        mWebView = std::make_unique<juce::WebBrowserComponent>(options);
        addAndMakeVisible(mWebView.get());

        // 3. IMPORTANT: Go to the Resource Provider Root
        mWebView->goToURL(juce::WebBrowserComponent::getResourceProviderRoot());

        setSize(900, 550);
    }

    void resized() override { mWebView->setBounds(getLocalBounds()); }
    std::optional<juce::WebBrowserComponent::Resource> RootViewComponent::getResource(const juce::String& url)
    {
        // 1. Normalize the path logic
        auto path = (url == "/" || url.isEmpty()) ? "index.html" : url.fromFirstOccurrenceOf("/", false, false);

        if (path == "index.html")
        {
            // 2. Create the vector using the (iterator, iterator) constructor
            // BinaryData::index_html is a const char*, so we cast to std::byte*
            std::vector<std::byte> data (
                reinterpret_cast<const std::byte*>(BinaryData::index_html),
                reinterpret_cast<const std::byte*>(BinaryData::index_html) + BinaryData::index_htmlSize
            );

            return juce::WebBrowserComponent::Resource {
                std::move(data),
                "text/html"
            };
        }

        return std::nullopt;
    }
private:
    std::unique_ptr<juce::WebBrowserComponent> mWebView;
};
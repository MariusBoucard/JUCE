cmake_minimum_required(VERSION 3.15)

project(testWebView VERSION 1.0.0)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Add JUCE as a subdirectory (adjust the path to where your JUCE folder is located)
# Option 1: If JUCE is in a subdirectory relative to this CMakeLists.txt
# add_subdirectory(path/to/JUCE)

# Option 2: If JUCE is installed elsewhere
# For this example, assuming JUCE is at C:/Users/Marius/Documents/JUCE/JUCE
# add_subdirectory("C:/Users/Marius/Documents/JUCE/JUCE" JUCE)

message(STATUS "BUILDING textWebView")

# Define the plugin
juce_add_plugin(testWebView
        COMPANY_NAME "Ballzzy"
        COMPANY_WEBSITE "http://juce.com"
        COMPANY_EMAIL ""
        PLUGIN_MANUFACTURER_CODE Ball
        PLUGIN_CODE WVkf
        FORMATS VST3 Standalone
        PRODUCT_NAME "testWebView"
        BUNDLE_ID "com.JUCE.testWebView"
        NEEDS_WEB_BROWSER TRUE
        NEEDS_WEBVIEW2 TRUE

        # VST3 specific settings
        VST3_CATEGORIES Fx

        # Plugin characteristics
        IS_SYNTH FALSE
        NEEDS_MIDI_INPUT FALSE
        NEEDS_MIDI_OUTPUT FALSE
        IS_MIDI_EFFECT FALSE
        EDITOR_WANTS_KEYBOARD_FOCUS FALSE

        # Other settings
        COPY_PLUGIN_AFTER_BUILD FALSE
        PLUGIN_NAME "testWebView"
        PLUGIN_DESCRIPTION "testWebView"
        VST3_AUTO_MANIFEST FALSE
)

# Link binary data and JUCE modules to the plugin
target_link_libraries(testWebView
        PRIVATE
        testWebViewData
        juce::juce_audio_basics
        juce::juce_audio_devices
        juce::juce_audio_formats
        juce::juce_audio_plugin_client
        juce::juce_audio_processors
        juce::juce_audio_utils
        juce::juce_core
        juce::juce_data_structures
        juce::juce_dsp
        juce::juce_events
        juce::juce_graphics
        juce::juce_gui_basics
        juce::juce_gui_extra
        PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags
)

# Add source files
target_sources(testWebView
        PRIVATE
        # Main source files
       # Source/FaustPlugin.h
     #   Source/DemoUtilities.h
        Source/Main.cpp
        Source/PluginAudioProcessor.cpp
        Source/PluginAudioProcessor.h
        Source/PluginAudioProcessor.hpp

        # DSP files
        Source/dsp/Mappers.cpp
        Source/dsp/Mappers.h
        Source/dsp/ParameterSetup.h
        Source/dsp/ParameterSetup.cpp
        Source/dsp/Processor.cpp
        Source/dsp/Processor.h
        Source/dsp/Processor.hpp

        # DSP Bones
        Source/dsp/Bones/FaustMultiheadFeedback.h

        # Look and Feel
        Source/looknfeel/StripKnob_look_n_feel.h
        Source/looknfeel/ToogleButtonLookAndFeel.h

        # UI
        Source/ui/gui.cpp
        Source/ui/gui.h
        Source/ui/gui.hpp

        # UI Components
        Source/ui/components/TopBarComponent.cpp
        Source/ui/components/TopBarComponent.h
)

# Add binary resources (images)
juce_add_binary_data(testWebViewData
        SOURCES
        # Knobs
        Source/ressources/knob/g1.png
        Source/ressources/index.html
        # Plate
        Source/ressources/plate/plate.png
)

# Preprocessor definitions
target_compile_definitions(testWebView
        PUBLIC
        JUCE_WEB_BROWSER=1
        JUCE_USE_WIN_WEBVIEW2_WITH_STATIC_LINKING=1

      #  JUCE_USE_WIN_WEBVIEW2=1
       # JUCE_WEB_BROWSER_RESOURCE_PROVIDER_AVAILABLE=1
        JUCE_USE_CURL=0
       # NEEDS_WEBVIEW2=1
        JUCE_VST3_CAN_REPLACE_VST2=0
        #JUCE_USE_WIN_WEBVIEW2_WITH_STATIC_LINKING=1
        JUCE_DISPLAY_SPLASH_SCREEN=1
        JUCE_STRICT_REFCOUNTEDPOINTER=1
        PRIVATE
)
# Sets the include directories of the plugin project.
target_include_directories(${PROJECT_NAME}
        PUBLIC
        "C:/Users/Marius/.nuget/packages/microsoft.web.webview2/1.0.3485.44/build/native/include/"  # Add this line
)

# Platform-specific settings
if(MSVC)
    target_compile_options(testWebView PRIVATE /bigobj)
endif()

# Custom post-build command to copy VST3 to specific location
if(WIN32)
    set(VST3_DESTINATION_PATH "D:/vstcreation/testWebView.vst3/Contents/x86_64-win")

    add_custom_command(TARGET testWebView_VST3 POST_BUILD
            # Create the necessary internal folder structure
            COMMAND ${CMAKE_COMMAND} -E make_directory "${VST3_DESTINATION_PATH}"

            # Copy the VST3 file
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "$<TARGET_FILE:testWebView_VST3>"
            "${VST3_DESTINATION_PATH}/$<TARGET_FILE_NAME:testWebView_VST3>"
            COMMENT "Creating VST3 Bundle structure in D:/vstcreation"
    )
endif()
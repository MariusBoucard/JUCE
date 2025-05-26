
macro(jucer_setup_project_header PROJECT_JUCER_FILE PROJECT_ID PROJECT_NAME PROJECT_VERSION COMPANY_NAME COMPANY_WEBSITE PREPROCESSOR_DEFINITIONS HEADER_SEARCH_PATHS PLUGIN_FORMATS PLUGIN_NAME_SPECIFIC)
    jucer_project_begin(
            JUCER_FORMAT_VERSION "1"
            PROJECT_FILE "${PROJECT_JUCER_FILE}"
            PROJECT_ID "${PROJECT_ID}"
    )

    jucer_project_settings(
            PROJECT_NAME "${PROJECT_NAME}"
            PROJECT_VERSION "${PROJECT_VERSION}"
            COMPANY_NAME "${COMPANY_NAME}"
            COMPANY_WEBSITE "${COMPANY_WEBSITE}"
            USE_GLOBAL_APPCONFIG_HEADER OFF
            ADD_USING_NAMESPACE_JUCE_TO_JUCE_HEADER ON
            DISPLAY_THE_JUCE_SPLASH_SCREEN ON # Required for closed source applications without an Indie or Pro JUCE license
            PROJECT_TYPE "Audio Plug-in"
            BUNDLE_IDENTIFIER "com.${COMPANY_NAME}.${PROJECT_NAME}" # Exemple de bundle identifier généré
            CXX_LANGUAGE_STANDARD "C++17"
            PREPROCESSOR_DEFINITIONS
            "${PREPROCESSOR_DEFINITIONS}"
            HEADER_SEARCH_PATHS
            "${HEADER_SEARCH_PATHS}"
            # NOTES
            #   ${PLUGIN_NAME_SPECIFIC} audio plugin.
    )

    jucer_audio_plugin_settings(
            PLUGIN_FORMATS
            "${PLUGIN_FORMATS}"
            # PLUGIN_CHARACTERISTICS
            PLUGIN_NAME "${PLUGIN_NAME_SPECIFIC}"
            PLUGIN_DESCRIPTION "Plugin ${PLUGIN_NAME_SPECIFIC} made by ${COMPANY_NAME}" # Exemple
            PLUGIN_MANUFACTURER "${COMPANY_NAME}"
            PLUGIN_MANUFACTURER_CODE "Manu" # Peut être un argument si besoin
            PLUGIN_CODE "${PROJECT_ID}"    # Peut être un argument si besoin, ici réutilisation de PROJECT_ID
            # PLUGIN_CHANNEL_CONFIGURATIONS
            PLUGIN_AAX_IDENTIFIER "com.${COMPANY_NAME}.${PROJECT_NAME}"
            PLUGIN_AU_EXPORT_PREFIX "${PROJECT_NAME}AU"
            PLUGIN_AU_MAIN_TYPE "kAudioUnitType_Effect"
            PLUGIN_AU_IS_SANDBOX_SAFE ON
            PLUGIN_VST3_CATEGORY "Fx"
            PLUGIN_RTAS_CATEGORY "ePlugInCategory_None"
            PLUGIN_AAX_CATEGORY "AAX_ePlugInCategory_None"
            PLUGIN_VST_LEGACY_CATEGORY "kPlugCategEffect"
    )
endmacro()

macro(jucer_setup_project_footer PROJECT_NAME JUCE_MODULES_GLOBAL_PATH)

    jucer_project_module(
            juce_audio_basics
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_audio_devices
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_audio_formats
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_audio_plugin_client
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
            JUCE_VST3_CAN_REPLACE_VST2 OFF
    )
    jucer_project_module(
            juce_audio_processors
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_audio_utils
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_core
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
            JUCE_STRICT_REFCOUNTEDPOINTER ON
    )
    jucer_project_module(
            juce_data_structures
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_events
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_graphics
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_gui_basics
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )
    jucer_project_module(
            juce_gui_extra
            PATH "${JUCE_MODULES_GLOBAL_PATH}"
    )

    # Cibles d'exportation
    jucer_export_target(
            "Xcode (macOS)"
            TARGET_PROJECT_FOLDER "Builds/MacOSX"
    )
    jucer_export_target_configuration(
            "Xcode (macOS)"
            NAME "Debug"
            DEBUG_MODE ON
            BINARY_NAME "${PROJECT_NAME}"
            OPTIMISATION "-O0 (no optimisation)"
    )
    jucer_export_target_configuration(
            "Xcode (macOS)"
            NAME "Release"
            DEBUG_MODE OFF
            BINARY_NAME "${PROJECT_NAME}"
            OPTIMISATION "-O3 (fastest with safe optimisations)"
    )

    jucer_export_target(
            "Visual Studio 2022"
            TARGET_PROJECT_FOLDER "Builds/VisualStudio2022"
    )
    jucer_export_target_configuration(
            "Visual Studio 2022"
            NAME "Debug"
            DEBUG_MODE ON
            BINARY_NAME "${PROJECT_NAME}"
            OPTIMISATION "No optimisation"
    )
    jucer_export_target_configuration(
            "Visual Studio 2022"
            NAME "Release"
            DEBUG_MODE OFF
            BINARY_NAME "${PROJECT_NAME}"
            OPTIMISATION "Maximise speed"
    )

    jucer_project_end()
endmacro()

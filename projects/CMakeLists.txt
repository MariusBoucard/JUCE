option(BUILD_BITCRUSHER "Build the BitCrusher plugin" ON)
option(BUILD_GAINPLUGIN "Build the GainPlugin plugin" ON)
option(BUILD_TEMPLATE "Build the template plugin" ON)

if(BUILD_BITCRUSHER)
    add_subdirectory(BitCrusher)
endif()

if(BUILD_GAINPLUGIN)
    add_subdirectory(GainPlugin)
endif()

if(BUILD_TEMPLATE)
    add_subdirectory(template)
endif()
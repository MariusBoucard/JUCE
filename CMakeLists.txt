cmake_minimum_required(VERSION 3.22)

project(JUCE VERSION 7.0.8 LANGUAGES C CXX)
## add_compile_options(-Ob2 -GR)
if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL" CACHE STRING "MSVC Runtime Library" FORCE)
endif()

set(JUCE_MODULES_DIR "${JUCE_SOURCE_DIR}/modules" CACHE INTERNAL
    "The path to JUCE modules")

option(JUCE_MODULES_ONLY "Only configure the JUCE modules" OFF)

add_definitions(-DJUCE_MODAL_LOOPS_PERMITTED=1)

if(JUCE_MODULES_ONLY)
    return()
endif()

#set_directory_properties(PROPERTIES
#    JUCE_COMPANY_NAME       "JUCE"
#    JUCE_COMPANY_WEBSITE    "https://juce.com"
#    JUCE_COMPANY_EMAIL      "info@juce.com"
#    JUCE_COMPANY_COPYRIGHT  "Copyright (c) - Raw Material Software Limited")

#option(JUCE_COPY_PLUGIN_AFTER_BUILD
#    "Whether or not plugins should be installed to the system after building" OFF)
#set_property(GLOBAL PROPERTY JUCE_COPY_PLUGIN_AFTER_BUILD ${JUCE_COPY_PLUGIN_AFTER_BUILD})

#set(CMAKE_CXX_EXTENSIONS FALSE)
#
#juce_disable_default_flags()


if(JUCE_GLOBAL_AAX_SDK_PATH)
    juce_set_aax_sdk_path("${JUCE_GLOBAL_AAX_SDK_PATH}")
endif()

if(JUCE_GLOBAL_VST2_SDK_PATH)
    juce_set_vst2_sdk_path("${JUCE_GLOBAL_VST2_SDK_PATH}")
endif()

if(JUCE_GLOBAL_ARA_SDK_PATH)
    juce_set_ara_sdk_path("${JUCE_GLOBAL_ARA_SDK_PATH}")
endif()

add_subdirectory(libraries)

option(JUCE_BUILD_PROJECTS "Add build targets for the DemoRunner and PIPs" OFF)

if(JUCE_BUILD_PROJECTS)
    add_subdirectory(projects)
endif()


#  if(MSVC)
#     message("MSVC Flags")
#     set(CMAKE_CXX_FLAGS_RELEASE "/Ox /Ob2 /Gy /GR /DNDEBUG" CACHE STRING "" FORCE)
#  else()
#      set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -DNDEBUG" CACHE STRING "" FORCE)
#      set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -DNDEBUG" CACHE STRING "" FORCE)
#  endif()


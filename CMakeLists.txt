cmake_minimum_required(VERSION 3.22)
#set(CMAKE_CXX_STANDARD 20)

project(JUCE VERSION 8.0.7 LANGUAGES C CXX)
## add_compile_options(-Ob2 -GR)
if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL" CACHE STRING "MSVC Runtime Library" FORCE)
endif()
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()


set(JUCE_WEBVIEW2_PACKAGE_LOCATION
        "${CMAKE_BINARY_DIR}/_deps/Nuget"
)
option(JUCE_MODULES_ONLY "Only configure the JUCE modules" ON)
set(JUCE_MODULES_ONLY OFF)
add_definitions(-DJUCE_MODAL_LOOPS_PERMITTED=1)

set(JUCE_WEBVIEW2_PACKAGE_LOCATION "C:/Users/Marius/.nuget/packages")
add_subdirectory(JUCE)
#add_subdirectory(extras/Build/CMake)
if(JUCE_MODULES_ONLY)
    #return()
endif()

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

option(JUCE_BUILD_PROJECTS "Add build targets for plugins" ON)

#set(JUCE_MODULES_GLOBAL_PATH "C:/Users/Marius/Documents/JUCE/modules")
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


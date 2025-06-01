option(BUILD_BITCRUSHER "Build the BitCrusher plugin" ON)
option(BUILD_NEURALAMP "Build the GainPlugin plugin" ON)
option(BUILD_TEMPLATE "Build the template plugin" ON)

if(BUILD_BITCRUSHER)
    add_subdirectory(BitCrusher)
endif()

if(BUILD_NEURALAMP)
    add_subdirectory(NeuralAmpPlugin)
endif()

if(BUILD_TEMPLATE)
    add_subdirectory(template)
endif()
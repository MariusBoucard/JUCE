option(BUILD_BITCRUSHER "Build the BitCrusher plugin" ON)
option(BUILD_NEURALAMP "Build the GainPlugin plugin" ON)
option(BUILD_TEMPLATE "Build the template plugin" ON)
option(BUILD_TEMPLATEBIS "Build the template plugin" ON)
option(BUILD_FAUST_PEDAL "Build the template plugin" ON)

option(BUILD_EQSTRIP "Build the template plugin" ON)

if(BUILD_BITCRUSHER)
    add_subdirectory(BitCrusher)
endif()

if(BUILD_NEURALAMP)
    message("building neural amp")
    add_subdirectory(NeuralAmpPlugin)
endif()

if(BUILD_EQSTRIP)
    message("building eq strip")

    add_subdirectory(EqStrip)
endif()

if(BUILD_TEMPLATE)
    add_subdirectory(template)
endif()
if(BUILD_TEMPLATEBIS)
    add_subdirectory(templateBis)
endif()
if(BUILD_FAUST_PEDAL)
    add_subdirectory(faustPedalSaturator)
endif()

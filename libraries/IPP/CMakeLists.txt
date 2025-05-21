cmake_minimum_required(VERSION 3.10)

project(IPP)

# Set the path to the IPP include, lib, and bin directories
set(IPP_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(IPP_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(IPP_BIN_DIR "${CMAKE_CURRENT_SOURCE_DIR}/bin")

# Find all DLLs in the bin directory
file(GLOB IPP_DLLS "${IPP_BIN_DIR}/*.dll")
# Find all static or shared libraries in the lib directory
file(GLOB IPP_LIBS "${IPP_LIB_DIR}/*.lib" "${IPP_LIB_DIR}/*.a" "${IPP_LIB_DIR}/*.so" "${IPP_LIB_DIR}/*.dylib")

# Create an interface library target for IPP
add_library(ipp INTERFACE)
target_include_directories(ipp INTERFACE "${IPP_INCLUDE_DIR}")
target_link_libraries(ipp INTERFACE ${IPP_LIBS})

# Function to copy DLLs to the target directory after build
function(ipp_copy_dlls target)
    foreach(dll ${IPP_DLLS})
        add_custom_command(TARGET ${target} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                "${dll}"
                $<TARGET_FILE_DIR:${target}>
        )
    endforeach()
endfunction()

# Export variables and function for parent scope
set(IPP_DLLS ${IPP_DLLS} PARENT_SCOPE)
set(ipp_copy_dlls ipp_copy_dlls PARENT_SCOPE)

# Optionally, print what was found for debugging
message(STATUS "IPP include dir: ${IPP_INCLUDE_DIR}")
message(STATUS "IPP libs: ${IPP_LIBS}")
message(STATUS "IPP DLLs: ${IPP_DLLS}")
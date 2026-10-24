cmake_minimum_required(VERSION 3.20)
project(smlib LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

set(SMLIBPY_PATCH_DIR "${SMLIBPY_DIR}/third_party/patches")
function(smlibpy_patch_sources sources_var dir)
    file(GLOB patched CONFIGURE_DEPENDS "${SMLIBPY_PATCH_DIR}/${dir}/src/*.cpp")
    set(sources ${${sources_var}})
    foreach(file ${patched})
        get_filename_component(name "${file}" NAME)
        string(REPLACE "." "\\." pattern "/${name}$")
        list(LENGTH sources before)
        list(FILTER sources EXCLUDE REGEX "${pattern}")
        list(LENGTH sources after)
        math(EXPR removed "${before} - ${after}")
        if(NOT removed EQUAL 1)
            message(FATAL_ERROR "${file} must replace exactly one kernel source source/${dir}/src/${name}")
        endif()
        list(APPEND sources "${file}")
    endforeach()
    set(${sources_var} ${sources} PARENT_SCOPE)
endfunction()

file(GLOB SMLIB_SOURCES CONFIGURE_DEPENDS "${USD_BREP_DIR}/source/SMLib/src/*.cpp")
smlibpy_patch_sources(SMLIB_SOURCES SMLib)
add_library(smlib STATIC ${SMLIB_SOURCES})
add_library(smlib::smlib ALIAS smlib)
target_include_directories(smlib PUBLIC
    $<BUILD_INTERFACE:${USD_BREP_DIR}/source/SMLib/inc>
    $<INSTALL_INTERFACE:include>
)
target_compile_definitions(smlib PUBLIC
    NOMINMAX
    SM_GRAPHICS_CALLBACKS=1
    $<$<CONFIG:Release,RelWithDebInfo,MinSizeRel>:NDEBUG>
)

file(GLOB SM_API_SOURCES CONFIGURE_DEPENDS "${USD_BREP_DIR}/source/SM_API/src/*.cpp")
smlibpy_patch_sources(SM_API_SOURCES SM_API)

set(SMLIBPY_CPP_FILES
    "${SMLIBPY_DIR}/src/cpp/ext.cpp"
    "${SMLIBPY_DIR}/src/cpp/step_build.cpp"
    "${SMLIBPY_DIR}/src/cpp/measure.cpp"
    "${SMLIBPY_DIR}/src/cpp/tessellate.cpp"
    "${USD_BREP_DIR}/source/SmPyLib/src/SmPyError.cpp"
)

add_library(sm_api STATIC ${SM_API_SOURCES} ${SMLIBPY_CPP_FILES})
add_library(smlib::sm_api ALIAS sm_api)
target_include_directories(sm_api PUBLIC
    $<BUILD_INTERFACE:${USD_BREP_DIR}/source/SM_API/inc>
    $<BUILD_INTERFACE:${SMLIBPY_DIR}/src/cpp>
    $<BUILD_INTERFACE:${USD_BREP_DIR}/source/SmPyLib/src>
    $<INSTALL_INTERFACE:include>
)
target_compile_definitions(sm_api PUBLIC SM_API_EXPORTS)
target_link_libraries(sm_api PUBLIC smlib)

if(MSVC)
    foreach(t smlib sm_api)
        target_compile_options(${t} PRIVATE /utf-8 /bigobj /wd4244 /wd4305 /wd4267 /W1)
        if(CMAKE_GENERATOR MATCHES "Visual Studio")
            target_compile_options(${t} PRIVATE /MP)
        endif()
    endforeach()
else()
    foreach(t smlib sm_api)
        target_compile_options(${t} PRIVATE -w)
    endforeach()
endif()

install(TARGETS smlib sm_api
    EXPORT smlibTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

install(DIRECTORY "${USD_BREP_DIR}/source/SMLib/inc/" DESTINATION include FILES_MATCHING PATTERN "*.h")
install(DIRECTORY "${USD_BREP_DIR}/source/SM_API/inc/" DESTINATION include FILES_MATCHING PATTERN "*.h")
install(FILES
    "${SMLIBPY_DIR}/src/cpp/ext_shared.h"
    "${SMLIBPY_DIR}/src/cpp/kernel.h"
    "${SMLIBPY_DIR}/src/cpp/step_build.h"
    "${SMLIBPY_DIR}/src/cpp/measure.h"
    "${SMLIBPY_DIR}/src/cpp/tessellate.h"
    "${SMLIBPY_DIR}/src/cpp/value.h"
    "${USD_BREP_DIR}/source/SmPyLib/src/SmPyError.h"
    DESTINATION include
)

install(EXPORT smlibTargets
    FILE smlibTargets.cmake
    NAMESPACE smlib::
    DESTINATION share/smlib
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/smlibConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/smlibConfig.cmake"
    INSTALL_DESTINATION share/smlib
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/smlibConfigVersion.cmake"
    VERSION 0.1.0
    COMPATIBILITY SameMajorVersion
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/smlibConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/smlibConfigVersion.cmake"
    DESTINATION share/smlib
)

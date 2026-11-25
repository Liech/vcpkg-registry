cmake_minimum_required(VERSION 3.20)
project(ufbx VERSION 0.23.1 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

add_library(ufbx STATIC "${UFBX_DIR}/ufbx.c")
add_library(ufbx::ufbx ALIAS ufbx)

target_include_directories(ufbx PUBLIC
    $<BUILD_INTERFACE:${UFBX_DIR}>
    $<INSTALL_INTERFACE:include>
)

if(MSVC)
    target_compile_options(ufbx PRIVATE /utf-8)
endif()

install(TARGETS ufbx
    EXPORT ufbxTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

install(FILES "${UFBX_DIR}/ufbx.h" DESTINATION include)

install(EXPORT ufbxTargets
    FILE ufbxTargets.cmake
    NAMESPACE ufbx::
    DESTINATION share/ufbx
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/ufbxConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/ufbxConfig.cmake"
    INSTALL_DESTINATION share/ufbx
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/ufbxConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/ufbxConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/ufbxConfigVersion.cmake"
    DESTINATION share/ufbx
)

set(VCPKG_LIBRARY_LINKAGE static)

if(EXISTS "${CURRENT_PORT_DIR}/../../../CADacomb/CMakeLists.txt")
    set(SOURCE_PATH "${CURRENT_PORT_DIR}/../../../CADacomb")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO Liech/CADacomb
        REF "0.0.1"
        SHA512 0
        HEAD_REF main
    )
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        render CADACOMB_BUILD_RENDER
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DCADACOMB_BUILD_TESTS=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME CADacomb)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

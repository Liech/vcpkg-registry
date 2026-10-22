if(EXISTS "${CURRENT_PORT_DIR}/../../../Polyglot/CMakeLists.txt")
    set(SOURCE_PATH "${CURRENT_PORT_DIR}/../../../Polyglot")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO Liech/Polyglot
        REF "2a617af922c1a6904dd2c7ee625055e0343c5d8d"
        SHA512 0
        HEAD_REF main
    )
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTS=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME Polyglot)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

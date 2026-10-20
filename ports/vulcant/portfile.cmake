vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Liech/Vulcant
    REF "${VERSION}"
    SHA512 0
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DVULCANT_BUILD_EXAMPLES=OFF
        -DVULCANT_BUILD_TESTS=OFF
        -DBUILD_GODOT_BINDINGS=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME Vulcant CONFIG_PATH lib/cmake/Vulcant)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

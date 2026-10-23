set(VCPKG_LIBRARY_LINKAGE static)

if(EXISTS "${CURRENT_PORT_DIR}/../../../Vulcant/CMakeLists.txt")
    set(SOURCE_PATH "${CURRENT_PORT_DIR}/../../../Vulcant")
elseif(EXISTS "${CURRENT_PORT_DIR}/../../../../Vulcant/CMakeLists.txt")
    set(SOURCE_PATH "${CURRENT_PORT_DIR}/../../../../Vulcant")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO Liech/Vulcant
        REF "45c6b92886d4b36885ace3e782d7de61f6248391"
        SHA512 c29e02126ec261e3eb70cc3b513f1d87b4a404e4da3c1732a261d60fdfcb8c815a34a915ade057bbfa81fb77cec92931f1b7ef39e0edd846f697f903753262eb
        HEAD_REF main
    )
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        toolkit BUILD_TOOLKIT
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_EXAMPLES=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_GODOT_BINDINGS=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME Vulcant)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

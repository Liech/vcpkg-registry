set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_from_github(
    OUT_SOURCE_PATH UFBX_SOURCE_PATH
    REPO ufbx/ufbx
    REF "v0.23.1"
    SHA512 783733311503b01854505342ad4d77cfdc8fb191b8c7a664c02b090e054420c391c28f63416f824bfb64ba1ffef6a7f2f5cadd6e185d851d45c708fab2f24b51
    HEAD_REF master
)

file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/src/ufbx-build")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${CURRENT_BUILDTREES_DIR}/src/ufbx-build")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/ufbxConfig.cmake.in" DESTINATION "${CURRENT_BUILDTREES_DIR}/src/ufbx-build")

vcpkg_cmake_configure(
    SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/src/ufbx-build"
    OPTIONS
        "-DUFBX_DIR=${UFBX_SOURCE_PATH}"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME ufbx)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${UFBX_SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

set(VCPKG_LIBRARY_LINKAGE static)

if(EXISTS "${CURRENT_PORT_DIR}/../../../cadexample/smlibpy/CMakeLists.txt" AND EXISTS "${CURRENT_PORT_DIR}/../../../cadexample/smlibpy/third_party/usd-brep/source/SMLib/src/SmBrep.cpp")
    set(SMLIBPY_SOURCE_PATH "${CURRENT_PORT_DIR}/../../../cadexample/smlibpy")
    set(USD_BREP_SOURCE_PATH "${CURRENT_PORT_DIR}/../../../cadexample/smlibpy/third_party/usd-brep")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SMLIBPY_SOURCE_PATH
        REPO awv-informatik/smlibpy
        REF "18fbd049220df0dc44e53d499e2aa0174aad4b43"
        SHA512 b6370a4a04dfcc6f5eebb5991ef64916dd3ac3a0f7a40ef48c091d74be23f541bef989d37256b96f1656fce70fee0f0a9c889a076dc91ba77e471d80f54c8633
        HEAD_REF main
    )
    vcpkg_from_github(
        OUT_SOURCE_PATH USD_BREP_SOURCE_PATH
        REPO NVIDIA-Omniverse/usd-brep
        REF "c9c5979f04cea8c38213004d4f04df0dcfb40d05"
        SHA512 6693135f0dd429af631dd034d7b8c68df7d8b15d336f8805a6613a26800b2df05e68ec0b1fb8e2931d1d605182ae03bd6d1ffec27f823ea54e4c44ce46906dad
        HEAD_REF main
    )
endif()

file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/src/smlib-build")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${CURRENT_BUILDTREES_DIR}/src/smlib-build")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/smlibConfig.cmake.in" DESTINATION "${CURRENT_BUILDTREES_DIR}/src/smlib-build")

vcpkg_cmake_configure(
    SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/src/smlib-build"
    OPTIONS
        "-DSMLIBPY_DIR=${SMLIBPY_SOURCE_PATH}"
        "-DUSD_BREP_DIR=${USD_BREP_SOURCE_PATH}"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME smlib)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_copy_pdbs()

file(INSTALL "${SMLIBPY_SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

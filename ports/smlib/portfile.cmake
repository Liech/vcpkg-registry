set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_from_github(
    OUT_SOURCE_PATH SMLIBPY_SOURCE_PATH
    REPO awv-informatik/smlibpy
    REF "18fbd049220df0dc44e53d499e2aa0174aad4b43"
    SHA512 1d7e86a9eca998dd112ac197849cdeaa4e0dca3ace2acb6513d8a5f103ae68a44f80f64223d57bdef5db5a773ca3ca7453ee728e29755e42bf58ad251d7a8c42
    HEAD_REF main
)

vcpkg_from_github(
    OUT_SOURCE_PATH USD_BREP_SOURCE_PATH
    REPO NVIDIA-Omniverse/usd-brep
    REF "c9c5979f04cea8c38213004d4f04df0dcfb40d05"
    SHA512 61037b73db9a03223b3c07dc5aad9a1bde3ecf69c7a96bec45db083e1ab8b745c0570f9d8add77dffca355fdf31eb4683ae4a0cf5c24aed0fa278d2a01b495b4
    HEAD_REF main
)

vcpkg_replace_string("${USD_BREP_SOURCE_PATH}/source/SMLib/inc/SmTypes.h" "#define SM_EXPORT   __declspec( dllexport )" "#define SM_EXPORT")
vcpkg_replace_string("${USD_BREP_SOURCE_PATH}/source/SMLib/inc/SmTArray.h" "#define SM_TARRAY_TEMPLATE_PREDECLARATION(x) template class SM_EXPORT SmTArray<x>" "#define SM_TARRAY_TEMPLATE_PREDECLARATION(x)")
vcpkg_replace_string("${USD_BREP_SOURCE_PATH}/source/SM_API/inc/SmApiTypes.h" "__declspec(dllexport)" "")
vcpkg_replace_string("${USD_BREP_SOURCE_PATH}/source/SM_API/inc/SmApiTypes.h" "__declspec(dllimport)" "")

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

file(INSTALL "${SMLIBPY_SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

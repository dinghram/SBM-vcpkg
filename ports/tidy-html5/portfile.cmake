set(TIDY_VERSION 5.6.0)
include(vcpkg_common_functions)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/tidy-html5-${TIDY_VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/htacg/tidy-html5/archive/${TIDY_VERSION}.tar.gz"
    FILENAME "tidy-html5-${TIDY_VERSION}.zip"
    SHA512 179088a6dbd29bb0e4f0219222f755b186145495f7414f6d0e178803ab67140391283d35352d946f9790c6b1b5b462ee6e24f1cc84f19391cb9b65e73979ffd1)

vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
    ${CMAKE_CURRENT_LIST_DIR}/remove_execution_character_set.patch
    ${CMAKE_CURRENT_LIST_DIR}/fixCMakeLists.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED_LIB)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON
        -DBUILD_SHARED_LIB=${BUILD_SHARED_LIB}
        -DTIDY_CONSOLE_SHARED=${BUILD_SHARED_LIB}
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/tidyd.exe)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/tidy-html5)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/tidy.exe ${CURRENT_PACKAGES_DIR}/tools/tidy-html5/tidy.exe)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})

file(INSTALL ${SOURCE_PATH}/README/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/tidy-html5 RENAME copyright)

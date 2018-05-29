include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/log4cplus-2.0.1)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/log4cplus/log4cplus/releases/download/REL_2_0_1/log4cplus-2.0.1.tar.gz"
    FILENAME "log4cplus-2.0.1.tar.gz"
    SHA512 85d7f21c29c34b4d90e19f937646b109a190b535c3900dbe0f51bbf24bbee23d22499b2c896315d0279e3b42d94e3d1e1b4e1ca75746db306f054439642ac899
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES 
      ${CMAKE_CURRENT_LIST_DIR}/fixCMakeLists.patch
      ${CMAKE_CURRENT_LIST_DIR}/fix_cpp17.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DLOG4CPLUS_BUILD_TESTING=OFF -DLOG4CPLUS_BUILD_LOGGINGSERVER=OFF -DWITH_UNIT_TESTS=OFF
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/log4cplus)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/log4cplus)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/log4cplus/LICENSE ${CURRENT_PACKAGES_DIR}/share/log4cplus/copyright)

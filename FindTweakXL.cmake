include(FetchContent)

if(NOT TARGET TweakXL)
  add_library(TweakXL INTERFACE)
  target_include_directories(TweakXL INTERFACE deps/tweak_xl/support/red4ext)
endif()

if(NOT DEFINED MOD_TWEAK_XL_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/tweakXL.zip OR MOD_FORCE_UPDATE_DEPS)
    file(DOWNLOAD
      https://api.github.com/repos/psiberx/cp2077-tweak-xl/releases
      ${MOD_BINARY_DIR}/downloads/tweakXL_releases.json
    )
    file(READ ${MOD_BINARY_DIR}/downloads/tweakXL_releases.json TWEAK_XL_RELEASES)
    string(JSON TWEAK_XL_URL GET "${TWEAK_XL_RELEASES}" 0 assets 0 browser_download_url)
    file(DOWNLOAD
      ${TWEAK_XL_URL}
      ${MOD_BINARY_DIR}/downloads/tweakXL.zip
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/tweakXL.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_prereqs/
    )
  endif()
  set(MOD_TWEAK_XL_DEPENDENCY_ADDED ON)
endif()
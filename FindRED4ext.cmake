include(FetchContent)

list(APPEND MOD_REQUIREMENTS "RED4ext 1.27.0+")
if(NOT DEFINED MOD_RED4EXT_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/red4ext.zip OR MOD_FORCE_UPDATE_DEPS)
    if(NOT DEFINED MOD_RED4EXT_DOWNLOAD_URL)
      file(DOWNLOAD
        https://api.github.com/repos/WopsS/RED4ext/releases
        ${MOD_BINARY_DIR}/downloads/RED4ext_releases.json
      )
      file(READ ${MOD_BINARY_DIR}/downloads/RED4ext_releases.json RED4EXT_RELEASES)
      string(JSON MOD_RED4EXT_DOWNLOAD_URL GET "${RED4EXT_RELEASES}" 0 assets 0 browser_download_url)
    endif()
    file(DOWNLOAD
      ${MOD_RED4EXT_DOWNLOAD_URL}
      ${MOD_BINARY_DIR}/downloads/red4ext.zip
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/red4ext.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_requirements/
    )
  endif()
  set(MOD_RED4EXT_DEPENDENCY_ADDED ON)
endif()
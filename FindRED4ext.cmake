include(FetchContent)

if(NOT DEFINED MOD_RED4EXT_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/red4ext.zip OR MOD_FORCE_UPDATE_DEPS)
    if(NOT DEFINED MOD_RED4EXT_DOWNLOAD_URL)
      set(MOD_RED4EXT_DOWNLOAD_URL "https://github.com/WopsS/RED4ext/releases/download/v1.12.0/red4ext_1.12.0.zip")
    endif()
    file(DOWNLOAD
      ${MOD_RED4EXT_DOWNLOAD_URL}
      ${MOD_BINARY_DIR}/downloads/red4ext.zip
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/red4ext.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_prereqs/
    )
  endif()
  set(MOD_RED4EXT_DEPENDENCY_ADDED ON)
endif()
include(FetchContent)

if(NOT DEFINED MOD_RED4EXT_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/red4ext.zip OR MOD_FORCE_UPDATE_DEPS)
    file(DOWNLOAD
      https://github.com/WopsS/RED4ext/releases/download/v1.12.0/red4ext_1.12.0.zip
      ${MOD_BINARY_DIR}/downloads/red4ext.zip
      EXPECTED_HASH SHA256=04CD4E22516EBBB082F2F586648E9BE97EA04FF4CCA649F28913E7B40DE087CD
      SHOW_PROGRESS
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/red4ext.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_prereqs/
    )
  endif()
  set(MOD_RED4EXT_DEPENDENCY_ADDED ON)
endif()
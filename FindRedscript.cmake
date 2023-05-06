include(FetchContent)

if(NOT DEFINED MOD_REDSCRIPT_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/redscript.zip OR MOD_FORCE_UPDATE_DEPS)
    if(NOT DEFINED MOD_REDSCRIPT_DOWNLOAD_URL)
      set(MOD_REDSCRIPT_DOWNLOAD_URL "https://github.com/jac3km4/redscript/releases/download/v0.5.13/redscript-v0.5.13.zip")
    endif()
    file(DOWNLOAD
      ${MOD_REDSCRIPT_DOWNLOAD_URL}
      ${MOD_BINARY_DIR}/downloads/redscript.zip
      SHOW_PROGRESS
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/redscript.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_prereqs/
    )
  endif()
  set(MOD_REDSCRIPT_DEPENDENCY_ADDED ON)
endif()
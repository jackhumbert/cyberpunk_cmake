include(FetchContent)

if(NOT DEFINED MOD_REDSCRIPT_DEPENDENCY_ADDED)
  list(APPEND MOD_REQUIREMENTS "Redscript 0.5.14+")
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/redscript.zip OR MOD_FORCE_UPDATE_DEPS)
    if(NOT DEFINED MOD_REDSCRIPT_DOWNLOAD_URL)
      file(DOWNLOAD
        https://api.github.com/repos/jac3km4/redscript/releases
        ${MOD_BINARY_DIR}/downloads/redscript_releases.json
      )
      file(READ ${MOD_BINARY_DIR}/downloads/redscript_releases.json REDSCRIPT_RELEASES)
      string(JSON MOD_REDSCRIPT_DOWNLOAD_URL GET "${REDSCRIPT_RELEASES}" 0 assets 1 browser_download_url)
    endif()
    file(DOWNLOAD
      ${MOD_REDSCRIPT_DOWNLOAD_URL}
      ${MOD_BINARY_DIR}/downloads/redscript.zip
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/redscript.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_requirements/
    )
  endif()
  set(MOD_REDSCRIPT_DEPENDENCY_ADDED ON)
endif()
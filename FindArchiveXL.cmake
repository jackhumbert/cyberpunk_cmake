include(FetchContent)

if(NOT DEFINED MOD_ARCHIVE_XL_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/archiveXL.zip OR MOD_FORCE_UPDATE_DEPS)
    file(DOWNLOAD
      https://github.com/psiberx/cp2077-archive-xl/releases/download/v1.4.4/ArchiveXL-1.4.4.zip
      ${MOD_BINARY_DIR}/downloads/archiveXL.zip
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/archiveXL.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_prereqs/
    )
  endif()
  set(MOD_ARCHIVE_XL_DEPENDENCY_ADDED ON)
endif()
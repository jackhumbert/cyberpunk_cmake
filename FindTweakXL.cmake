include(FetchContent)

if(NOT DEFINED MOD_TWEAK_XL_DEPENDENCY_ADDED)
  if(NOT EXISTS ${MOD_BINARY_DIR}/downloads/tweakXL.zip OR MOD_FORCE_UPDATE_DEPS)
    file(DOWNLOAD
    https://github.com/psiberx/cp2077-tweak-xl/releases/download/v1.1.4/TweakXL-1.1.4.zip
      ${MOD_BINARY_DIR}/downloads/tweakXL.zip
      SHOW_PROGRESS
    )
    file(ARCHIVE_EXTRACT
        INPUT ${MOD_BINARY_DIR}/downloads/tweakXL.zip
        DESTINATION ${TOP_MOD_SOURCE_DIR}/game_dir_prereqs/
    )
  endif()
  set(MOD_TWEAK_XL_DEPENDENCY_ADDED ON)
endif()
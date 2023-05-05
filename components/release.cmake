#[[Configures the release zip file with the path passed:
configure_release(${MOD_SLUG}_${MOD_VERSION_STR}.zip)
configure_release(release.zip)
Uses these variables:
* MOD_SLUG
* MOD_VERSION_STR
* MOD_GAME_DIR
Sets these variables:
* MOD_ZIP_FILE
]]
macro(configure_release ZIP_FILE)
  set(MOD_ZIP_FILE_RAW ${ZIP_FILE})
  cmake_path(IS_RELATIVE MOD_ZIP_FILE_RAW FILENAME_IS_RELATIVE)
  if(${FILENAME_IS_RELATIVE})
    set(MOD_ZIP_FILE ${MOD_SOURCE_DIR}/${MOD_ZIP_FILE_RAW})
  else()
    set(MOD_ZIP_FILE ${MOD_ZIP_FILE_RAW})
  endif()
  if(DEFINED GITHUB_ENV)
    get_filename_component(MOD_ZIP_FILENAME ${MOD_ZIP_FILE} NAME_WLE)
    if(EXISTS "${GITHUB_ENV}")
      file(APPEND "${GITHUB_ENV}" "MOD_ZIP_FILENAME=${MOD_ZIP_FILENAME}")
    else()
      message(WARNING "GITHUB_ENV file does not exist: ${GITHUB_ENV}")
    endif()
  endif()
  # if(DEFINED CMAKE_CI_BUILD AND ${PROJECT_IS_TOP_LEVEL})
  #   add_custom_target(ci_release
  #     COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${MOD_ZIP_FILE}" --format=zip .
  #     WORKING_DIRECTORY ${MOD_GAME_DIR}
  #     DEPENDS ${MOD_SLUG}
  #     COMMENT "Zipping game_dir for '${MOD_NAME}' ${MOD_VERSION_STR}")
  # else()
    add_custom_target(${MOD_SLUG}_release
      COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${MOD_ZIP_FILE}" --format=zip .
      WORKING_DIRECTORY ${MOD_GAME_DIR}
      DEPENDS ${MOD_SLUG}
      COMMENT "Zipping game_dir for '${MOD_NAME}' ${MOD_VERSION_STR}")
  # endif()
endmacro()
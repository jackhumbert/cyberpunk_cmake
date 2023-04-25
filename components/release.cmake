# MOD_SLUG
# MOD_ZIP_FILE
# MOD_VERSION_STR
# MOD_GAME_DIR
macro(configure_release ZIP_FILE)
  set(MOD_ZIP_FILE_RAW ${ZIP_FILE})
  cmake_path(IS_RELATIVE MOD_ZIP_FILE_RAW FILENAME_IS_RELATIVE)
  if(${FILENAME_IS_RELATIVE})
    set(MOD_ZIP_FILE ${MOD_SOURCE_DIR}/${MOD_ZIP_FILE_RAW})
  else()
    set(MOD_ZIP_FILE ${MOD_ZIP_FILE_RAW})
  endif()
  if("${CMAKE_BUILD_TYPE}" STREQUAL "CI" AND ${PROJECT_IS_TOP_LEVEL})
    add_custom_target(ci_release
      COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${MOD_ZIP_FILE}" --format=zip .
      WORKING_DIRECTORY ${MOD_GAME_DIR}
      DEPENDS ${MOD_SLUG}
      COMMENT "Zipping game_dir for '${MOD_NAME}' ${MOD_VERSION_STR}")
  else()
    add_custom_target(${MOD_SLUG}_release
      COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${MOD_ZIP_FILE}" --format=zip .
      WORKING_DIRECTORY ${MOD_GAME_DIR}
      DEPENDS ${MOD_SLUG}
      COMMENT "Zipping game_dir for '${MOD_NAME}' ${MOD_VERSION_STR}")
  endif()
endmacro()
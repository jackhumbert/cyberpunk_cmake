# MOD_SLUG
# MOD_ZIP_FILE
# MOD_VERSION_STR
# MOD_GAME_DIR
macro(configure_release ZIP_FILE)
  set(MOD_ZIP_FILE ${ZIP_FILE})
  add_custom_target(${MOD_SLUG}_release
    COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${MOD_ZIP_FILE}" --format=zip .
    WORKING_DIRECTORY ${MOD_GAME_DIR}
    DEPENDS ${MOD_SLUG}
    COMMENT "Zipping game_dir for '${MOD_NAME}' ${MOD_VERSION_STR}")
endmacro()
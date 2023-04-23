
# Release

add_custom_target(release
  COMMAND ${CMAKE_COMMAND} -E tar "cfv" "${MOD_ZIP_FILE}" --format=zip .
  WORKING_DIRECTORY ${MOD_GAME_DIR}
  DEPENDS ${MOD_SLUG}
  COMMENT "Zipping game_dir for '${MOD_NAME}' v${MOD_VERSION_MAJOR}.${MOD_VERSION_MINOR}.${MOD_VERSION_PATCH}")
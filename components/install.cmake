#[[Configures the installation of the mod from `MOD_GAME_DIR` to `CYBERPUNK_2077_GAME_DIR`
Uses these variables:
* MOD_GAME_DIR
* CYBERPUNK_2077_GAME_DIR
Sets these variables:
* MOD_GAME_DIR_INSTALL_FILES
]]
macro(configure_install)
  file(GLOB MOD_GAME_DIR_INSTALL_FILES ${MOD_GAME_DIR}/*)

  install(DIRECTORY ${MOD_GAME_DIR_INSTALL_FILES}
    DESTINATION ${CYBERPUNK_2077_GAME_DIR})
endmacro()
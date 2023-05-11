#[[Configures the installation of the mod from `MOD_GAME_DIR` to `CYBERPUNK_2077_GAME_DIR`
Uses these variables:
* MOD_GAME_DIR
* CYBERPUNK_2077_GAME_DIR
Sets these variables:
* MOD_GAME_DIR_INSTALL_FILES
]]
option(MOD_INSTALL_PREREQS "Install the prereqs as well as the game_dir" OFF)
macro(configure_install)
  if(${PROJECT_IS_TOP_LEVEL} OR ${MOD_INSTALL_PREREQS})
    file(GLOB MOD_GAME_DIR_INSTALL_FILES ${MOD_GAME_DIR}/*)

    install(DIRECTORY ${MOD_GAME_DIR_INSTALL_FILES}
      DESTINATION ${CYBERPUNK_2077_GAME_DIR})
  endif()
endmacro()
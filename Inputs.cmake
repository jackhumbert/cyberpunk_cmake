# MOD_GAME_DIR
# MOD_INPUTS_FILE

set(MOD_GAME_DIR_INPUT_FILE "${MOD_GAME_DIR}/r6/input/${CMAKE_PROJECT_NAME}.xml")
# set(MOD_INPUTS_FILE "${PROJECT_SOURCE_DIR}/src/input_loader/${CMAKE_PROJECT_NAME}.xml")

add_custom_command(
  OUTPUT ${MOD_GAME_DIR_INPUT_FILE}
  DEPENDS ${MOD_INPUTS_FILE}
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  ${MOD_INPUTS_FILE}
  ${MOD_GAME_DIR_INPUT_FILE}
)

add_custom_target(${MOD_SLUG}_input
  DEPENDS ${MOD_GAME_DIR_INPUT_FILE}
)

set_target_properties(${MOD_SLUG}_input PROPERTIES FOLDER "Red4ext/Dependencies")
add_dependencies(${MOD_SLUG} ${MOD_SLUG}_input)
set(MOD_GAME_DIR_INPUT_FILE ${MOD_GAME_DIR}/r6/input/${MOD_SLUG}.xml)

#[[Configures one input file to be placed at `MOD_GAME_DIR_INPUT_FILE`. Accepts the path of the input file:
configure_inputs(mod.xml)
Sets these variables:
* MOD_GAME_DIR_INPUT_FILE
]]
macro(configure_inputs INPUT_FILE)
  set(INPUTS_FILE_RAW ${INPUT_FILE})
  cmake_path(IS_RELATIVE INPUTS_FILE_RAW IS_INPUTS_FILE_RAW)
  if(${IS_INPUTS_FILE_RAW})
    set(MOD_INPUTS_FILE ${MOD_SOURCE_DIR}/${INPUTS_FILE_RAW})
  else()
    set(MOD_INPUTS_FILE ${INPUTS_FILE_RAW})
  endif()

  if(EXISTS ${MOD_INPUTS_FILE})
    message(STATUS "Configure input file: ${MOD_INPUTS_FILE}")
  else()
    message(STATUS "Configure input file: ${MOD_INPUTS_FILE} - Warning: file does not exist")
  endif()

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

  list(APPEND ${MOD_SLUG}_GAME_DIR_FILES ${MOD_GAME_DIR_INPUT_FILE})

  set_target_properties(${MOD_SLUG}_input PROPERTIES FOLDER "Red4ext/Dependencies")
  add_dependencies(${MOD_SLUG} ${MOD_SLUG}_input)
endmacro()
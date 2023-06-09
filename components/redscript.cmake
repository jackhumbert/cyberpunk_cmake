
set(REDSCRIPT_MODULE_IN_FILENAME "Module.reds.in")

set(REDSCRIPT_PACKED_FILENAME "packed.reds")
set(REDSCRIPT_MODULE_FILENAME "module.reds")

set(LOAD_REDSCRIPT_FROM_RED4EXT OFF)

#[[Configures redscript at the location passed:
configure_redscipt(src/redscript)
Sets `MOD_REDSCRIPT_DIR` and uses the following variables:
* MOD_SLUG
* MOD_TOOLS_DIR
* MOD_GAME_DIR
* CYBERPUNK_2077_REDSCRIPT_BACKUP
]]
macro(configure_redscript REDSCRIPT_DIR)
  set(REDSCRIPT_DIR_RAW ${REDSCRIPT_DIR})

  if("${REDSCRIPT_DIR_RAW}" STREQUAL "")
    set(REDSCRIPT_DIR_RAW ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  cmake_path(IS_RELATIVE REDSCRIPT_DIR_RAW IS_REDSCRIPT_DIR_RELATIVE)

  if(${IS_REDSCRIPT_DIR_RELATIVE})
    set(MOD_REDSCRIPT_DIR ${MOD_SOURCE_DIR}/${REDSCRIPT_DIR_RAW})
  else()
    set(MOD_REDSCRIPT_DIR ${REDSCRIPT_DIR_RAW})
  endif()
  
  set(${MOD_PREFIX}_REDSCRIPT_PREREQ_FILE "${MOD_BINARY_DIR}/dependencies.redscripts")
  set(REDSCRIPT_LAST_LINT "${MOD_BINARY_DIR}/redscript.lint")
  set(${MOD_PREFIX}_REDSCRIPT_PRECOMPILE_DIR "${MOD_BINARY_DIR}/redscript/precompile")


  set(MOD_GAME_DIR_REDSCRIPT_DIR "${MOD_GAME_DIR}/r6/scripts")
  set(MOD_GAME_DIR_REDSCRIPT_MOD_DIR "${MOD_GAME_DIR}/r6/scripts/${MOD_SLUG}")

  set(MOD_GAME_DIR_REDSCRIPT_PACKED_FILE "${MOD_GAME_DIR_REDSCRIPT_MOD_DIR}/${REDSCRIPT_PACKED_FILENAME}")
  set(MOD_GAME_DIR_REDSCRIPT_MODULE_FILE "${MOD_GAME_DIR_REDSCRIPT_MOD_DIR}/${REDSCRIPT_MODULE_FILENAME}")
  
  set(MOD_GAME_DIR_RED4EXT_PACKED_FILE "${MOD_GAME_DIR_RED4EXT_MOD_DIR}/${REDSCRIPT_PACKED_FILENAME}")
  set(MOD_GAME_DIR_RED4EXT_MODULE_FILE "${MOD_GAME_DIR_RED4EXT_MOD_DIR}/${REDSCRIPT_MODULE_FILENAME}")


  if(NOT ${LOAD_REDSCRIPT_FROM_RED4EXT})
    list(APPEND ${MOD_PREFIX}_UNINSTALL_LOCATIONS "${MOD_GAME_DIR_REDSCRIPT_DIR}")
    set(MOD_GAME_DIR_PACKED_FILE ${MOD_GAME_DIR_REDSCRIPT_PACKED_FILE})
    set(MOD_GAME_DIR_MODULE_FILE ${MOD_GAME_DIR_REDSCRIPT_MODULE_FILE})
  else()
    set(MOD_GAME_DIR_PACKED_FILE ${MOD_GAME_DIR_RED4EXT_PACKED_FILE})
    set(MOD_GAME_DIR_MODULE_FILE ${MOD_GAME_DIR_RED4EXT_MODULE_FILE})
  endif()

  print_rel_dir("Configuring redscript files in:" ${MOD_REDSCRIPT_DIR})

  include(Header)

  set(REDSCRIPT_MODULE_IN_FILE "${MOD_REDSCRIPT_DIR}/${REDSCRIPT_MODULE_IN_FILENAME}")

  file(GLOB_RECURSE REDSCRIPT_SOURCE_FILES ${MOD_REDSCRIPT_DIR}/*.reds)

  list(APPEND CMAKE_MESSAGE_INDENT "  ")

  foreach(FILE ${REDSCRIPT_SOURCE_FILES})
    file(RELATIVE_PATH RELATIVE_PATH "${MOD_REDSCRIPT_DIR}" "${FILE}")
    file(RELATIVE_PATH RELATIVE_SOURCE_PATH "${MOD_SOURCE_DIR}" "${FILE}")
    message(STATUS "'${RELATIVE_PATH}'")
  endforeach()

  list(POP_BACK CMAKE_MESSAGE_INDENT)

  enable_language(REDSCRIPT)

  # packed.reds file
  add_library(${MOD_SLUG}.packed.reds STATIC ${REDSCRIPT_SOURCE_FILES})
  set_target_properties(${MOD_SLUG}.packed.reds PROPERTIES 
    OUTPUT_NAME ${MOD_SLUG}.packed
    LINKER_LANGUAGE Swift
    SUFFIX .reds
  )
  target_include_directories(${MOD_SLUG}.packed.reds PUBLIC ${MOD_REDSCRIPT_DIR})

  source_group("Source Files" FILES ${REDSCRIPT_SOURCE_FILES})
  add_dependencies(${MOD_SLUG} ${MOD_SLUG}.packed.reds)
  list(APPEND ${MOD_PREFIX}_GAME_DIR_FILES ${MOD_GAME_DIR_PACKED_FILE})

  # module.reds file
  if(EXISTS "${REDSCRIPT_MODULE_IN_FILE}")
    configure_file(${REDSCRIPT_MODULE_IN_FILE} ${MOD_SLUG}.${REDSCRIPT_MODULE_FILENAME})
    add_library(${MOD_SLUG}.module.reds MODULE ${MOD_SLUG}.${REDSCRIPT_MODULE_FILENAME})
    target_link_libraries(${MOD_SLUG}.module.reds PUBLIC ${MOD_SLUG}.packed.reds)
    set_target_properties(${MOD_SLUG}.module.reds PROPERTIES 
      OUTPUT_NAME ${MOD_SLUG}.module
      LINKER_LANGUAGE Swift
      SUFFIX .reds
    )
    add_dependencies(${MOD_SLUG} ${MOD_SLUG}.module.reds)
    list(APPEND ${MOD_PREFIX}_GAME_DIR_FILES ${MOD_GAME_DIR_MODULE_FILE})
  endif()

  find_package(Redscript)

  if(NOT ${LOAD_REDSCRIPT_FROM_RED4EXT})
    list(APPEND ${MOD_PREFIX}_GAME_DIR_FOLDERS ${MOD_GAME_DIR_REDSCRIPT_MOD_DIR})
  endif()
endmacro()

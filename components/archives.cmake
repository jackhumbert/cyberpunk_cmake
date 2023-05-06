set(MOD_GAME_DIR_ARCHIVES_DIR "${MOD_GAME_DIR}/archive/pc/mod")

#[[Configures .archive & .archive.xl files. Accepts any number of files as arguments, like:
configure_archives(mod.archive mod2.archive mod.archive.xl)
Uses these variables:
* MOD_SLUG
* MOD_GAME_DIR
Can be configured to use a different install folder via `MOD_GAME_DIR_ARCHIVES_DIR`.
Sets these variables:
* MOD_GAME_DIR_ARCHIVES
* MOD_GAME_DIR_ARCHIVE_XL
]]
macro(configure_archives)
  process_arg("${ARGV}" ARCHIVE_FILES ${MOD_SOURCE_DIR})

  unset(MOD_GAME_DIR_ARCHIVES)
  unset(MOD_GAME_DIR_ARCHIVE_XLS)
  message(STATUS "Configuring archives")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")

  # processes both .archive & .archive.xl files
  foreach(ARCHIVE ${ARCHIVE_FILES})
    get_filename_component(EXTENSION ${ARCHIVE} EXT)
    file(RELATIVE_PATH RELATIVE_FILE ${MOD_SOURCE_DIR} ${ARCHIVE})

    if(NOT EXISTS ${ARCHIVE})
      message(STATUS "Configuring ${ARCHIVE} - Warning: File not found")
    else()
      message(STATUS "Configuring ${ARCHIVE}")
    endif()

    if("${EXTENSION}" STREQUAL ".archive")
      get_filename_component(ARCHIVE_NAME ${ARCHIVE} NAME)
      list(APPEND MOD_GAME_DIR_ARCHIVES "${MOD_GAME_DIR_ARCHIVES_DIR}/${ARCHIVE_NAME}")
      add_custom_command(
        OUTPUT ${MOD_GAME_DIR_ARCHIVES_DIR}/${ARCHIVE_NAME}
        DEPENDS ${ARCHIVE}
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ARCHIVE}
        ${MOD_GAME_DIR_ARCHIVES_DIR}/${ARCHIVE_NAME}
      )
    elseif("${EXTENSION}" STREQUAL ".archive.xl")
      get_filename_component(ARCHIVE_XL_NAME ${ARCHIVE} NAME)
      list(APPEND MOD_GAME_DIR_ARCHIVE_XLS "${MOD_GAME_DIR_ARCHIVES_DIR}/${ARCHIVE_XL_NAME}")
      add_custom_command(
        OUTPUT ${MOD_GAME_DIR_ARCHIVES_DIR}/${ARCHIVE_XL_NAME}
        DEPENDS ${ARCHIVE}
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${ARCHIVE}
        ${MOD_GAME_DIR_ARCHIVES_DIR}/${ARCHIVE_XL_NAME}
      )
    else()
      message(STATUS "Not configuring ${ARCHIVE} - Unknown archive file")
    endif()
  endforeach()

  list(POP_BACK CMAKE_MESSAGE_INDENT)

  if(DEFINED MOD_GAME_DIR_ARCHIVE_XLS)
    find_package(ArchiveXL)
  endif()

  add_custom_target(${MOD_SLUG}_archives
    DEPENDS ${MOD_GAME_DIR_ARCHIVES} ${MOD_GAME_DIR_ARCHIVE_XLS}
  )
  list(APPEND ${MOD_PREFIX}_GAME_DIR_FILES ${MOD_GAME_DIR_ARCHIVES})
  list(APPEND ${MOD_PREFIX}_GAME_DIR_FILES ${MOD_GAME_DIR_ARCHIVE_XLS})
  set_target_properties(${MOD_SLUG}_archives PROPERTIES FOLDER "Archives")
  add_dependencies(${MOD_SLUG} ${MOD_SLUG}_archives)
endmacro()
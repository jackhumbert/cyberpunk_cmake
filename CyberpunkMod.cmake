set(CYBERPUNK_CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
set(CYBERPUNK_CMAKE_SCRIPTS ${CYBERPUNK_CMAKE_MODULE_PATH}/scripts)
set(CYBERPUNK_CMAKE_FILES ${CYBERPUNK_CMAKE_MODULE_PATH}/files)

set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)

set(CYBERPUNK_2077_GAME_DIR "C:/Program Files (x86)/Steam/steamapps/common/Cyberpunk 2077" CACHE STRING "Cyberpunk 2077 game directory")
set(CYBERPUNK_2077_REDSCRIPT_BACKUP "${CYBERPUNK_2077_GAME_DIR}/r6/cache/final.redscripts.bk" CACHE STRING "final.redscripts.bk file created by Redscript after running it for the first time")

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

string(TIMESTAMP CURRENT_YEAR "%Y")

set(CONFIGURE_MOD_ARG_NAMES NAME SLUG DESCRIPTION URL AUTHOR VERSION LICENSE PREFIX COPYRIGHT)

#[[Configures the main `MOD_SLUG` target - can be passed a number of argument name/value pairs, which sets the MOD_<name> variable:
* NAME
* SLUG
* PREFIX
* DESCRIPTION
* URL
* AUTHOR
* VERSION
* LICENSE
* COPYRIGHT
]]
macro(configure_mod)
  set(MOD_SLUG "${PROJECT_NAME}")
  set(MOD_ARGS "${ARGV}")
  unset(MOD_PREFIX)
  foreach(MOD_ARG ${MOD_ARGS})
    if(DEFINED MOD_ARG_NAME)
      # message(STATUS "MOD_${MOD_ARG_NAME}: ${MOD_ARG}")
      set(MOD_${MOD_ARG_NAME} ${MOD_ARG})
      unset(MOD_ARG_NAME)
    else()
      if(${MOD_ARG} IN_LIST CONFIGURE_MOD_ARG_NAMES)
        set(MOD_ARG_NAME ${MOD_ARG})
      endif()
    endif()
  endforeach()
  if(NOT DEFINED MOD_PREFIX)
    set(MOD_PREFIX ${MOD_SLUG})
  endif()

  if(NOT DEFINED MOD_COPYRIGHT)
    set(MOD_COPYRIGHT "Copyright (c) 2023 ${MOD_AUTHOR}. All rights reserved.")
  endif()

  if(DEFINED MOD_SOURCE_DIR)
    set(PARENT_MOD_SOURCE_DIR ${MOD_SOURCE_DIR})
    set(TOP_MOD_SOURCE_DIR ${MOD_SOURCE_DIR})
    file(RELATIVE_PATH MOD_REL_PATH "${MOD_SOURCE_DIR}" "${PROJECT_SOURCE_DIR}")
    set(MOD_BINARY_DIR ${MOD_BINARY_DIR}/${MOD_REL_PATH})
  else()
    set(TOP_MOD_SOURCE_DIR ${PROJECT_SOURCE_DIR})
    set(MOD_BINARY_DIR ${PROJECT_BINARY_DIR})
  endif()

  set(MOD_SOURCE_DIR "${PROJECT_SOURCE_DIR}")
  set(MOD_TOOLS_DIR "${MOD_SOURCE_DIR}/tools")

  if(DEFINED PARENT_MOD_SOURCE_DIR)
    set(MOD_GAME_DIR "${PARENT_MOD_SOURCE_DIR}/game_dir_prereqs")
  else()
    set(MOD_GAME_DIR "${MOD_SOURCE_DIR}/game_dir")
  endif()
  
  set(${MOD_PREFIX}_GAME_DIR_FILES)
  set(${MOD_PREFIX}_GAME_DIR_FOLDERS)
  set(${MOD_PREFIX}_UNINSTALL_LOCATIONS)

  # load all the components
  file(GLOB CONFIGURE_COMPONENTS RELATIVE "${CYBERPUNK_CMAKE_MODULE_PATH}" "${CYBERPUNK_CMAKE_MODULE_PATH}/components/*.cmake" )
  foreach(COMPONENT ${CONFIGURE_COMPONENTS})
    get_filename_component(COMPONENT_NAME ${COMPONENT} NAME_WLE)
    # message(STATUS "Found component: ${COMPONENT_NAME}")
    include(components/${COMPONENT_NAME})
  endforeach()

  set(MOD_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
  set(MOD_VERSION_MINOR ${PROJECT_VERSION_MINOR})
  set(MOD_VERSION_PATCH ${PROJECT_VERSION_PATCH})
  set(MOD_VERSION_STR "v${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

  if(PROJECT_IS_TOP_LEVEL)
    set(FOLDER_PREFIX)
    # set(MOD_TARGET_PREFIX)
  else()
    set(FOLDER_PREFIX "${MOD_NAME}/")
    # set(MOD_TARGET_PREFIX "${MOD_SLUG}_")
  endif()

  add_custom_target(${MOD_SLUG} ALL)

  set_target_properties(${MOD_SLUG} PROPERTIES FOLDER "${FOLDER_PREFIX}")
endmacro()

macro(print_rel_dir MESSAGE LOCATION)
  file(RELATIVE_PATH RELATIVE_LOCATION "${TOP_MOD_SOURCE_DIR}" "${LOCATION}")
  message(STATUS "${MESSAGE} '${RELATIVE_LOCATION}'")
endmacro()

function(process_arg LIST_IN LIST_OUT_STR RELATIVE_PATH)
  if("${ARGV3}" STREQUAL "")
    set(GLOB "*")
  else()
    set(GLOB "${ARGV3}")
  endif()
  set(LIST_OUT)
  list(LENGTH LIST_IN LIST_LENGTH)
  foreach(LIST_FILE ${LIST_IN})
    cmake_path(IS_RELATIVE LIST_FILE LIST_FILE_IS_RELATIVE)
    if(LIST_FILE_IS_RELATIVE)
      set(WORKING_PATH ${RELATIVE_PATH}/${LIST_FILE})
    else()
      set(WORKING_PATH ${LIST_FILE})
    endif()
    if(IS_DIRECTORY ${WORKING_PATH})
      file(GLOB_RECURSE WORKING_FILES LIST_DIRECTORIES false ${GLOB})
      foreach(WORKING_FILE ${WORKING_FILES})
        list(APPEND LIST_OUT ${WORKING_FILE})
      endforeach()
    else()
      list(APPEND LIST_OUT ${WORKING_PATH})
    endif()
  endforeach()
  set(${LIST_OUT_STR} ${LIST_OUT} PARENT_SCOPE)
endfunction()

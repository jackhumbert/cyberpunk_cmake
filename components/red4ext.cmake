set(MOD_VERSIONINFO_RC_FILE ${CYBERPUNK_CMAKE_FILES}/versioninfo.rc)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#[[Configures a RED4ext plugin at the location passed:
configure_redscript(src/red4ext)
Uses these variables:
* MOD_GAME_DIR
Sets these variables:
* MOD_RED4EXT_SOURCE_DIR
]]
macro(configure_red4ext)
  set(RED4EXT_DIR_RAW ${ARGV0})

  if("${RED4EXT_DIR_RAW}" STREQUAL "")
    set(RED4EXT_DIR_RAW ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  cmake_path(IS_RELATIVE RED4EXT_DIR_RAW IS_REDSCRIPT_DIR_RELATIVE)

  if(${IS_REDSCRIPT_DIR_RELATIVE})
    set(MOD_RED4EXT_SOURCE_DIR ${MOD_SOURCE_DIR}/${RED4EXT_DIR_RAW})
  else()
    set(MOD_RED4EXT_SOURCE_DIR ${RED4EXT_DIR_RAW})
  endif()

  set(MOD_GAME_DIR_RED4EXT_DIR ${MOD_GAME_DIR}/red4ext/plugins)
  set(MOD_GAME_DIR_RED4EXT_MOD_DIR ${MOD_GAME_DIR}/red4ext/plugins/${MOD_SLUG})
  list(APPEND ${MOD_PREFIX}_UNINSTALL_LOCATIONS "${MOD_GAME_DIR}/red4ext/plugins")

  print_rel_dir("Configuring red4ext files in" ${MOD_RED4EXT_SOURCE_DIR})
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  
  file(GLOB_RECURSE HEADER_FILES ${MOD_RED4EXT_SOURCE_DIR}/*.hpp)
  file(GLOB_RECURSE SOURCE_FILES ${MOD_RED4EXT_SOURCE_DIR}/*.cpp)
  file(GLOB_RECURSE RC_FILES ${MOD_RED4EXT_SOURCE_DIR}/*.rc)

  message(STATUS "Configuring header files:")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  foreach(FILE ${HEADER_FILES})
    file(RELATIVE_PATH FILE_RELATIVE "${MOD_RED4EXT_SOURCE_DIR}" "${FILE}")
    message(STATUS "'${FILE_RELATIVE}'")
  endforeach()
  list(POP_BACK CMAKE_MESSAGE_INDENT)

  message(STATUS "Configuring source files:")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  foreach(FILE ${SOURCE_FILES})
    file(RELATIVE_PATH FILE_RELATIVE "${MOD_RED4EXT_SOURCE_DIR}" "${FILE}")
    message(STATUS "'${FILE_RELATIVE}'")
  endforeach()
  list(POP_BACK CMAKE_MESSAGE_INDENT)

  message(STATUS "Configuring rc files:")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
  foreach(FILE ${RC_FILES})
    file(RELATIVE_PATH FILE_RELATIVE "${MOD_RED4EXT_SOURCE_DIR}" "${FILE}")
    message(STATUS "'${FILE_RELATIVE}'")
  endforeach()
  list(POP_BACK CMAKE_MESSAGE_INDENT)

  find_package(RED4ext)
  find_package(RED4ext.SDK)
  print_rel_dir("RED4ext.SDK:" ${MOD_RED4EXT_SDK_DIR})
  
  list(APPEND CMAKE_MODULE_PATH "${MOD_RED4EXT_SDK_DIR}/cmake")
  include(GetGameVersion)

  if(DEFINED GITHUB_ENV AND ${PROJECT_IS_TOP_LEVEL})
    if(EXISTS "${GITHUB_ENV}")
    file(APPEND "${GITHUB_ENV}" "CYBERPUNK_2077_GAME_VERSION=${CYBERPUNK_2077_GAME_VERSION_STR}\n")
    file(APPEND "${GITHUB_ENV}" "CYBERPUNK_2077_GAME_VERSION_STR= for ${CYBERPUNK_2077_GAME_VERSION_STR}\n")
    else()
      message(WARNING "GITHUB_ENV file does not exist: ${GITHUB_ENV}")
    endif()
  endif()

  enable_language(CXX)
  enable_language(RC)
  add_library(${MOD_SLUG}.dll SHARED)

  set_target_properties(${MOD_SLUG}.dll PROPERTIES FOLDER Red4ext)

  target_compile_definitions(${MOD_SLUG}.dll PUBLIC

    # Support Windows 7 and above.
    WINVER=0x0601
    _WIN32_WINNT=0x0601

    # Exclude unnecessary APIs.
    WIN32_LEAN_AND_MEAN

    # Use Unicode charset.
    UNICODE
    _UNICODE

    # https://github.com/microsoft/STL/issues/1934
    _ITERATOR_DEBUG_LEVEL=0

    # for Codeware
    NOMINMAX

    # _DEBUG
    # _WINDLL
    _CRT_SECURE_NO_WARNINGS
  )

  target_compile_definitions(${MOD_SLUG}.dll PRIVATE
    MOD_VERSION_STR="${MOD_VERSION_STR}"
    MOD_VERSION_MAJOR=${MOD_VERSION_MAJOR}
    MOD_VERSION_MINOR=${MOD_VERSION_MINOR}
    MOD_VERSION_PATCH=${MOD_VERSION_PATCH}

    GAME_VERSION_MAJOR=${CYBERPUNK_2077_FILE_VERSION_MAJOR}
    GAME_VERSION_MINOR=${CYBERPUNK_2077_FILE_VERSION_MINOR}
    GAME_VERSION_BUILD=${CYBERPUNK_2077_FILE_VERSION_BUILD}
    GAME_VERSION_PRIVATE=${CYBERPUNK_2077_FILE_VERSION_PRIVATE}

    VER_INTERNALNAME_STR="${MOD_SLUG}"
    VER_FILEVERSION=${MOD_VERSION_MAJOR},${MOD_VERSION_MINOR},${MOD_VERSION_PATCH}
    VER_FILEVERSION_STR="${MOD_VERSION_STR}"
    VER_PRODUCTVERSION=${CYBERPUNK_2077_FILE_VERSION_MAJOR},${CYBERPUNK_2077_FILE_VERSION_MINOR},${CYBERPUNK_2077_FILE_VERSION_BUILD},${CYBERPUNK_2077_FILE_VERSION_PRIVATE}
    VER_PRODUCTVERSION_STR="${CYBERPUNK_2077_GAME_VERSION_STR}"
    VER_COMPANYNAME="${MOD_AUTHOR}"
    VER_FILEDESCRIPTION_STR="Red4ext plugin for Cyberpunk 2077"
    VER_LEGALCOPYRIGHT_STR="${MOD_COPYRIGHT}"
    VER_COMPANYNAME_STR="${MOD_AUTHOR}"
    VER_PRODUCTNAME_STR="${MOD_NAME}"
    VER_ORIGINALFILENAME_STR="${MOD_SLUG}.dll"
    VER_COMMENTS_STR="Built for ${CYBERPUNK_2077_GAME_VERSION_STR}"
  )

  set_target_properties(${MOD_SLUG}.dll PROPERTIES OUTPUT_NAME ${MOD_SLUG})
  set_target_properties(${MOD_SLUG}.dll PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
  set_target_properties(${MOD_SLUG}.dll PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

  source_group(_CMake REGULAR_EXPRESSION cmake_pch.*)
  source_group(TREE "${MOD_RED4EXT_SOURCE_DIR}" FILES ${HEADER_FILES} ${SOURCE_FILES} ${RC_FILES})

  target_include_directories(${MOD_SLUG}.dll PUBLIC ${MOD_RED4EXT_SOURCE_DIR})
  target_include_directories(${MOD_SLUG}.dll PUBLIC ${CYBERPUNK_CMAKE_INCLUDE})
  target_sources(${MOD_SLUG}.dll PRIVATE ${HEADER_FILES} ${SOURCE_FILES} ${RC_FILES} ${MOD_VERSIONINFO_RC_FILE})

  if(EXISTS ${MOD_RED4EXT_SOURCE_DIR}/stdafx.hpp)
    target_precompile_headers(${MOD_SLUG}.dll PUBLIC ${MOD_RED4EXT_SOURCE_DIR}/stdafx.hpp)
  endif()

  if(DEFINED MOD_RED4EXT_SDK_DIR)
    target_link_libraries(${MOD_SLUG}.dll
      PUBLIC
      RED4ext.SDK
    )
  endif()

  add_custom_command(
    TARGET ${MOD_SLUG}.dll POST_BUILD
    BYPRODUCTS ${MOD_GAME_DIR_RED4EXT_MOD_DIR}/${MOD_SLUG}.dll
    DEPENDS ${MOD_SLUG}.dll
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    $<TARGET_FILE:${MOD_SLUG}.dll>
    ${MOD_GAME_DIR_RED4EXT_MOD_DIR}/${MOD_SLUG}.dll
    COMMENT "${MOD_SLUG}.dll -> ${MOD_GAME_DIR_RED4EXT_MOD_DIR}/${MOD_SLUG}.dll")

  add_custom_command(
    TARGET ${MOD_SLUG}.dll POST_BUILD
    BYPRODUCTS  ${MOD_GAME_DIR_DEBUG}/red4ext/plugins/${MOD_SLUG}/${MOD_SLUG}.pdb
    DEPENDS ${MOD_SLUG}.dll
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    $<TARGET_PDB_FILE:${MOD_SLUG}.dll>
    ${MOD_GAME_DIR_DEBUG}/red4ext/plugins/${MOD_SLUG}/${MOD_SLUG}.pdb
    COMMENT "${MOD_SLUG}.pdb -> ${MOD_GAME_DIR_DEBUG}/red4ext/plugins/${MOD_SLUG}/${MOD_SLUG}.pdb")
    
  add_dependencies(${MOD_SLUG} ${MOD_SLUG}.dll)
  list(POP_BACK CMAKE_MESSAGE_INDENT)

  list(APPEND ${MOD_PREFIX}_GAME_DIR_FILES ${MOD_GAME_DIR_RED4EXT_MOD_DIR}/${MOD_SLUG}.dll)
  list(APPEND ${MOD_PREFIX}_GAME_DIR_FOLDERS ${MOD_GAME_DIR_RED4EXT_MOD_DIR})
endmacro()

macro(configure_red4ext_addresses ZOLTAN_ADDRESSES)
  message(STATUS "Configuring Zoltan")
  set(MOD_ZOLTAN_ADDRESSES "${ZOLTAN_ADDRESSES}")
  cmake_path(IS_RELATIVE MOD_ZOLTAN_ADDRESSES IS_ADDRESSES_RELATIVE)
  if (IS_ADDRESSES_RELATIVE)
    set(MOD_ZOLTAN_ADDRESSES ${MOD_RED4EXT_SOURCE_DIR}/${MOD_ZOLTAN_ADDRESSES})
  endif()
  message(STATUS "  Addresses file: ${MOD_ZOLTAN_ADDRESSES}")
  if(NOT DEFINED CMAKE_CI_BUILD)
    set(ZOLTAN_FILES "${HEADER_FILES};${SOURCE_FILES}")
    list(REMOVE_ITEM ZOLTAN_FILES ${MOD_ZOLTAN_ADDRESSES})
    # message(STATUS "Zoltan files: ${ZOLTAN_FILES}")
    add_custom_target(${MOD_SLUG}_zoltan DEPENDS ${ZOLTAN_FILES})
    add_custom_command(
      OUTPUT ${MOD_ZOLTAN_ADDRESSES}
      DEPENDS ${ZOLTAN_FILES}
      COMMAND ${ZOLTAN_CLANG_EXE}
      ARGS ${MOD_RED4EXT_SOURCE_DIR}/ -x ${CYBERPUNK_2077_EXE} -f="-std=c++20" -f="-include stdafx.hpp" -f="-I${MOD_RED4EXT_SDK_DIR}/include" --c-output "${MOD_ZOLTAN_ADDRESSES}" --safe-addr
      COMMENT "Finding binary addresses of declared functions in files in ${MOD_RED4EXT_SOURCE_DIR}"
    )

    add_custom_target(${MOD_SLUG}_addresses DEPENDS ${MOD_ZOLTAN_ADDRESSES})
    set_target_properties(${MOD_SLUG}_addresses PROPERTIES FOLDER Red4ext)
    add_dependencies(${MOD_SLUG}.dll ${MOD_SLUG}_addresses)
  else()
    if(EXISTS ${MOD_ZOLTAN_ADDRESSES})
      message(STATUS "  Found addresses file: ${MOD_ZOLTAN_ADDRESSES}")
    else()
      message(SEND_ERROR "Addresses file doesn't exist: ${MOD_ZOLTAN_ADDRESSES}")
    endif()
  endif()
endmacro()
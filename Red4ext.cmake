# inputs
# MOD_RED4EXT_SDK_DIR
# ZOLTAN_USER_SIGNATURES
# ZOLTAN_ADDRESSES_OUTPUT
# ZOLTAN_CLANG_EXE

# project(${MOD_SLUG}.dll LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Addresses from Zoltan

add_custom_command(
  OUTPUT ${ZOLTAN_ADDRESSES_OUTPUT}
  DEPENDS ${ZOLTAN_USER_SIGNATURES}
  COMMAND ${ZOLTAN_CLANG_EXE}
  ARGS ${ZOLTAN_USER_SIGNATURES} ${CYBERPUNK_2077_EXE} -f "std=c++20" -f "I${MOD_RED4EXT_SDK_DIR}/include" --c-output "${ZOLTAN_ADDRESSES_OUTPUT}" --safe-addr
  COMMENT "Finding binary addresses of declared functions in ${ZOLTAN_USER_SIGNATURES}"
)

add_custom_target(addresses DEPENDS ${ZOLTAN_ADDRESSES_OUTPUT})
set_target_properties(addresses PROPERTIES FOLDER Red4ext)

add_compile_definitions(
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
  #  _DEBUG
#  _WINDLL
 _CRT_SECURE_NO_WARNINGS
  MOD_VERSION_STR="${MOD_VERSION_STR}"
  MOD_VERSION_MAJOR=${MOD_VERSION_MAJOR}
  MOD_VERSION_MINOR=${MOD_VERSION_MINOR}
  MOD_VERSION_PATCH=${MOD_VERSION_PATCH}
)

add_library(${MOD_SLUG}.dll SHARED ${ZOLTAN_ADDRESSES_OUTPUT})
set_target_properties(${MOD_SLUG}.dll PROPERTIES FOLDER Red4ext)

set_target_properties(${MOD_SLUG}.dll PROPERTIES OUTPUT_NAME ${MOD_SLUG})
set_target_properties(${MOD_SLUG}.dll PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
set_target_properties(${MOD_SLUG}.dll PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

file(GLOB_RECURSE HEADER_FILES *.hpp)
file(GLOB_RECURSE SOURCE_FILES *.cpp)
file(GLOB_RECURSE RC_FILES *.rc)

source_group(_CMake REGULAR_EXPRESSION cmake_pch.*)
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${HEADER_FILES} ${SOURCE_FILES} ${RC_FILES})

target_include_directories(${MOD_SLUG}.dll PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_sources(${MOD_SLUG}.dll PRIVATE ${HEADER_FILES} ${SOURCE_FILES} ${RC_FILES})

target_precompile_headers(${MOD_SLUG}.dll PUBLIC stdafx.hpp)

add_custom_command(
  TARGET ${MOD_SLUG}.dll POST_BUILD
  DEPENDS ${MOD_SLUG}.dll
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  $<TARGET_FILE:${MOD_SLUG}.dll>
  ${MOD_GAME_DIR}/red4ext/plugins/${MOD_SLUG}/${MOD_SLUG}.dll
  COMMENT "${MOD_SLUG}.dll -> ${MOD_GAME_DIR}/red4ext/plugins/${MOD_SLUG}/${MOD_SLUG}.dll")
add_dependencies(${MOD_SLUG} ${MOD_SLUG}.dll)
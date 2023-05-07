# this should find the compiler for LANG and configure CMake(LANG)Compiler.cmake.in

include(${CMAKE_ROOT}/Modules/CMakeDetermineCompiler.cmake)
#include(Platform/${CMAKE_SYSTEM_NAME}-Determine-Redscript OPTIONAL)
#include(Platform/${CMAKE_SYSTEM_NAME}-Redscript OPTIONAL)
if(NOT CMAKE_Redscript_COMPILER_NAMES)
  set(CMAKE_Redscript_COMPILER_NAMES redscript-cli.exe)
endif()

# Build a small source file to identify the compiler.
if(NOT CMAKE_Redscript_COMPILER_ID_RUN)
  set(CMAKE_Redscript_COMPILER_ID_RUN 1)

  # Try to identify the compiler.
  set(CMAKE_Redscript_COMPILER_ID)
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerId.cmake)
  CMAKE_DETERMINE_COMPILER_ID(Redscript RSFLAGS CMakeRedscriptCompilerId.reds)

  execute_process(COMMAND "${CMAKE_Redscript_COMPILER}" "--version" OUTPUT_VARIABLE output)
  string(REPLACE "\n" ";" output "${output}")
  foreach(line ${output})
    string(TOUPPER ${line} line)
    string(REGEX REPLACE "^.*COMPILER.*VERSION[^\\.0-9]*([\\.0-9]+).*$" "\\1" version "${line}")
    if(version AND NOT "x${line}" STREQUAL "x${version}")
      set(CMAKE_Redscript_COMPILER_VERSION ${version})
      break()
    endif()
  endforeach()
  message(STATUS "The Redscript compiler version is ${CMAKE_Redscript_COMPILER_VERSION}")
endif()

# configure variables set in this file for fast reload later on
configure_file(deps/cyberpunk_cmake/CMakeRedscriptCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeRedscriptCompiler.cmake
  @ONLY
  )
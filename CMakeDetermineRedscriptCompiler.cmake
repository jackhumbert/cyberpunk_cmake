# this should find the compiler for LANG and configure CMake(LANG)Compiler.cmake.in

find_program(CMAKE_REDSCRIPT_COMPILER
  NAMES "redscript-cli.exe"
  PATHS ${CYBERPUNK_CMAKE_TOOLS}
)

mark_as_advanced(CMAKE_REDSCRIPT_COMPILER)

# set(ENV{CMAKE_REDSCRIPT_COMPILER_LAUNCHER} powershell.exe)
set(CMAKE_REDSCRIPT_SOURCE_FILE_EXTENSIONS reds)
set(CMAKE_REDSCRIPT_OUTPUT_EXTENSION .redscripts)
set(CMAKE_REDSCRIPT_COMPILER_ENV_VAR "REDSCRIPT")

# configure variables set in this file for fast reload later on
configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeRedscriptCompiler.cmake.in
${CMAKE_PLATFORM_INFO_DIR}/CMakeRedscriptCompiler.cmake @ONLY)
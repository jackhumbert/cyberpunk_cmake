# Cyberpunk CMake Mod Tools

This is a set of CMake scripts & tools to make creating, developing, depending on other mods, and releasing Cyberpunk 2077 mods easier.

## Features of this toolset:

* Configure mod and all components/options from `CMakeLists.txt` file
* C++ RED4ext plugin support
    * Integrated hook address-finding with Zoltan
    * Autopopulating VersionInfo template file
* Input loader support
* Redscript support
    * Dependency support - compiles submodule redscripts into a local final.redscripts file to lint against
    * Compiles all redscript files into a single "packed" file for easier updating
* TweakXL support
    * Compiles all .yaml files into a single "packed" file
* Archive & ArchiveXL support
* Automatic uninstall.bat script generation at relevant locations (r6/scripts & red4ext/plugins)
* Easily generate releases with custom formats

## Example CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.24)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/deps/cyberpunk_cmake")

include(CyberpunkMod)

project(project_slug VERSION 0.0.0)

configure_mod(
  NAME "Project Name"
  AUTHOR "Your Name"
  URL "https://github.com/your_name/your_repo"
  LICENSE "Licensed under the MIT license. See the license.md in the root project for details."
)

find_program(ZOLTAN_CLANG_EXE NAMES zoltan-clang.exe PATHS "${MOD_TOOLS_DIR}" CACHE)
find_program(CYBERPUNK_2077_EXE NAMES Cyberpunk2077.exe PATHS "${CYBERPUNK_2077_GAME_DIR}/bin/x64" DOC "Cyberpunk2077.exe Executable File" CACHE)
find_program(REDSCRIPT_CLI_EXE NAMES redscript-cli.exe PATHS "${MOD_TOOLS_DIR}" CACHE)

# RED4ext plugin & addresses found by Zoltan
configure_red4ext(red4ext)
configure_red4ext_addresses(Main.cpp Addresses.hpp)

# Redscript 
configure_redscript(redscript)

# Archive/.xl management
configure_archives(mod.archive mod.archive.xl)

# Tweaks
configure_tweaks(tweaks)

# Inputs
configure_inputs(inputs/${MOD_SLUG}.xml)

# Release zip file location/name
configure_release(${MOD_SLUG}_${MOD_VERSION_STR}.zip)

# Copy readme & license to any mod folders created
configure_folder_file(readme.md)
configure_folder_file(license.md)

# Install game_dir to Cyberpunk game directory
configure_install()

# Uninstall script generation
configure_uninstall()
```

## Templates:

* [Full demo with all components](https://github.com/jackhumbert/cyberpunk_cmake_mod)
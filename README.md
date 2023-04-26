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

## Examples:

* [Full demo with all components](https://github.com/jackhumbert/cyberpunk_cmake_mod)
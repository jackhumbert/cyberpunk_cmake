include(ResolveDependency)

if(NOT TARGET RedLib)
  resolve_dependency(deps/red_lib)
  add_compile_definitions(NOMINMAX)
  add_subdirectory(deps/red_lib)
endif()
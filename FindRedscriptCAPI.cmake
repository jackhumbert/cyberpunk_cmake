include(ResolveDependency)

if(NOT TARGET RedscriptCAPI)
  set(RESCRIPT_CAPI_DIR "${PROJECT_SOURCE_DIR}/deps/redscript_capi")

  resolve_dependency(deps/redscript_capi)
  add_library(RedscriptCAPI SHARED IMPORTED)
  set_target_properties(RedscriptCAPI PROPERTIES 
    FOLDER "Dependencies" 
    LINKER_LANGUAGE C 
    # OUTPUT_NAME redscript_capi
    IMPORTED_LOCATION "${RESCRIPT_CAPI_DIR}/redscript_capi.dll"
    IMPORTED_IMPLIB "${RESCRIPT_CAPI_DIR}/redscript_capi.dll.lib"
  )

  target_include_directories(RedscriptCAPI INTERFACE "${RESCRIPT_CAPI_DIR}/src")
  configure_mod_file("${RESCRIPT_CAPI_DIR}/redscript_capi.dll" "red4ext/plugins/ctd_helper/redscript_capi.dll")
  configure_mod_file("${RESCRIPT_CAPI_DIR}/redscript_capi.pdb" "red4ext/plugins/ctd_helper/redscript_capi.pdb")
endif()
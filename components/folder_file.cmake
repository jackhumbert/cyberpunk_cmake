#[[Configures files (relative to `MOD_SOURCE_DIR`) to be copied into each folder created by the mod (usually one named `MOD_SLUG`)
Call after main components, but before uninstall
Common to use with readme.md/license.md
]]
macro(configure_folder_file FILENAME)
    if(EXISTS ${MOD_SOURCE_DIR}/${FILENAME})
        message(STATUS "Configuring ${MOD_SOURCE_DIR}/${FILENAME}")
    else()
    message(STATUS "Configuring ${MOD_SOURCE_DIR}/${FILENAME} - Warning: file does not exist")
    endif()
    foreach(FOLDER ${${MOD_PREFIX}_GAME_DIR_FOLDERS})
        configure_file(${MOD_SOURCE_DIR}/${FILENAME} ${FOLDER}/${FILENAME} COPYONLY)
        list(APPEND ${MOD_PREFIX}_GAME_DIR_FILES ${FOLDER}/${FILENAME})
    endforeach()
endmacro()
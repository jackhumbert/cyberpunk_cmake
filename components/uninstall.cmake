set(MOD_UNINSTALL_FILENAME "${MOD_SLUG}_uninstall.bat")
set(MOD_UNINSTALL_BAT_IN "${CYBERPUNK_CMAKE_FILES}/uninstall.bat.in")

#[[Configures uninstall bat scripts
Must be called last, since this depends on the other components adding paths to 
`${MOD_SLUG}_GAME_DIR_FILES`, `${MOD_SLUG}_GAME_DIR_FOLDERS`, and `{${MOD_SLUG}_UNINSTALL_LOCATIONS`
]]
macro(configure_uninstall)
    foreach(LOCATION ${${MOD_SLUG}_UNINSTALL_LOCATIONS})
        list(APPEND ${MOD_SLUG}_GAME_DIR_FILES ${LOCATION}/${MOD_UNINSTALL_FILENAME})
    endforeach()

    message(STATUS "Configuring files to uninstall:")
    list(APPEND CMAKE_MESSAGE_INDENT "  ")
    set(MOD_INSTALLED_FILE_LIST)

    foreach(FILE_PATH ${${MOD_SLUG}_GAME_DIR_FILES})
        file(RELATIVE_PATH GAME_DIR_FILE ${MOD_GAME_DIR} ${FILE_PATH})
        file(TO_NATIVE_PATH "${GAME_DIR_FILE}" GAME_DIR_FILE_NATIVE)
        list(APPEND MOD_INSTALLED_FILE_LIST ${GAME_DIR_FILE_NATIVE})
        message(STATUS "'${GAME_DIR_FILE}'")
    endforeach()
    list(POP_BACK CMAKE_MESSAGE_INDENT)
    list(JOIN MOD_INSTALLED_FILE_LIST " " MOD_INSTALLED_FILES)

    message(STATUS "Configuring folders to uninstall:")
    list(APPEND CMAKE_MESSAGE_INDENT "  ")
    set(MOD_INSTALLED_FOLDER_LIST)

    foreach(FOLDER_PATH ${${MOD_SLUG}_GAME_DIR_FOLDERS})
        file(RELATIVE_PATH GAME_DIR_FOLDER ${MOD_GAME_DIR} ${FOLDER_PATH})
        file(TO_NATIVE_PATH "${GAME_DIR_FOLDER}" GAME_DIR_FOLDER_NATIVE)
        list(APPEND MOD_INSTALLED_FOLDER_LIST ${GAME_DIR_FOLDER_NATIVE})
        message(STATUS "'${GAME_DIR_FOLDER}'")
    endforeach()
    list(POP_BACK CMAKE_MESSAGE_INDENT)
    list(JOIN MOD_INSTALLED_FOLDER_LIST " " MOD_INSTALLED_FOLDERS)

    # get the relative path for each uninstall location & generate the uninstall.bat there
    foreach(LOCATION ${${MOD_SLUG}_UNINSTALL_LOCATIONS})
        file(RELATIVE_PATH MOD_UNINSTALL_RELATIVE_PATH ${LOCATION} ${MOD_SOURCE_DIR})
        configure_file(${MOD_UNINSTALL_BAT_IN} ${LOCATION}/${MOD_UNINSTALL_FILENAME})
    endforeach()
endmacro()

#[[Configures a particular file to uninstall
Must be called before `configure_uninstall`
]]
macro(configure_uninstall_file REL_PATH)
list(APPEND ${MOD_SLUG}_GAME_DIR_FILES "${MOD_GAME_DIR}/${REL_PATH}")
endmacro()

#[[Configures a particular folder to uninstall
Must be called before `configure_uninstall`
]]
macro(configure_uninstall_folder REL_PATH)
list(APPEND ${MOD_SLUG}_GAME_DIR_FOLDERS "${MOD_GAME_DIR}/${REL_PATH}")
endmacro()
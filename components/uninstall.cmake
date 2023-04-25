set(MOD_UNINSTALL_FILENAME "${MOD_SLUG}_uninstall.bat")
set(MOD_UNINSTALL_BAT_IN "${MOD_CYBERPUNK_CMAKE_MODULE_PATH}/files/uninstall.bat.in")

macro(configure_uninstall)
    foreach(LOCATION ${MOD_UNINSTALL_LOCATIONS})
        list(APPEND MOD_GAME_DIR_FILES ${LOCATION}/${MOD_UNINSTALL_FILENAME})
    endforeach()

    message(STATUS "Configuring files to uninstall:")
    list(APPEND CMAKE_MESSAGE_INDENT "  ")
    set(MOD_INSTALLED_FILE_LIST)

    foreach(FILE_PATH ${MOD_GAME_DIR_FILES})
        file(RELATIVE_PATH GAME_DIR_FILE ${MOD_GAME_DIR} ${FILE_PATH})
        file(TO_NATIVE_PATH "${GAME_DIR_FILE}" GAME_DIR_FILE_NATIVE)
        list(APPEND MOD_INSTALLED_FILE_LIST ${GAME_DIR_FILE_NATIVE})
        message(STATUS "'${GAME_DIR_FILE}'")
    endforeach()

    list(POP_BACK CMAKE_MESSAGE_INDENT)
    list(JOIN MOD_INSTALLED_FILE_LIST " " MOD_INSTALLED_FILES)

    # get the relative path for each uninstall location & generate the uninstall.bat there
    foreach(LOCATION ${MOD_UNINSTALL_LOCATIONS})
        file(RELATIVE_PATH MOD_UNINSTALL_RELATIVE_PATH ${LOCATION} ${MOD_SOURCE_DIR})
        configure_file(${MOD_UNINSTALL_BAT_IN} ${LOCATION}/${MOD_UNINSTALL_FILENAME})
    endforeach()
endmacro()
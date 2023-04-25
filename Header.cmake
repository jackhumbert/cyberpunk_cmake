# Header generation

set(MOD_HEADER_TXT_FILE ${CMAKE_CURRENT_LIST_DIR}/files/Header.txt)

configure_file(${MOD_HEADER_TXT_FILE}.in ${MOD_HEADER_TXT_FILE})
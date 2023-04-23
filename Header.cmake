# Header generation

string(TIMESTAMP CURRENT_YEAR "%Y")
configure_file(${CMAKE_CURRENT_LIST_DIR}/Header.txt.in ${CMAKE_CURRENT_LIST_DIR}/Header.txt)
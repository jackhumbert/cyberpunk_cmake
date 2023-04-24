# MOD_SLUG
# MOD_SOURCE_DIR
# MOD_NAME

if(PROJECT_IS_TOP_LEVEL)
  set(FOLDER_PREFIX)
  # set(MOD_TARGET_PREFIX)
else()
  set(FOLDER_PREFIX "${MOD_NAME}/")
  # set(MOD_TARGET_PREFIX "${MOD_SLUG}_")
endif()

add_custom_target(${MOD_SLUG} ALL)
set_target_properties(${MOD_SLUG} PROPERTIES FOLDER "${FOLDER_PREFIX}")

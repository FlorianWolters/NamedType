include_guard()

find_path(Catch_INCLUDE_DIR
  NAMES "catch.hpp"
  PATHS
    ${CMAKE_PROJECT_DIR}  
    ${CMAKE_SOURCE_DIR}
  )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Catch Catch_INCLUDE_DIR)

if(Catch_FOUND AND
   NOT TARGET Catch::Catch)
  add_library(Catch::Catch INTERFACE IMPORTED)

  set_target_properties(Catch::Catch
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Catch_INCLUDE_DIR}"
    )

  set(Catch_INCLUDE_DIRS ${Catch_INCLUDE_DIR})
  mark_as_advanced(
    Catch_INCLUDE_DIR
    Catch_INCLUDE_DIRS
    )
endif()

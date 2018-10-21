cmake_minimum_required(VERSION 3.10.3)

project(NamedType
  VERSION 1.0.1
  LANGUAGES CXX
  DESCRIPTION "Type-safe strong type (named type / opaque type) C++ library."
  )

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules")

include(CTest)

option(CMAKE_EXPORT_COMPILE_COMMANDS
  "Enable/Disable output of compile commands during generation."
  ON)

set(header_source_files
  ${PROJECT_SOURCE_DIR}/named_type.hpp
  ${PROJECT_SOURCE_DIR}/named_type_impl.hpp
  ${PROJECT_SOURCE_DIR}/underlying_functionalities.hpp
  ${PROJECT_SOURCE_DIR}/crtp.hpp
)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
source_group("Header Files" FILES ${header_source_files})

add_library(${PROJECT_NAME} INTERFACE)
target_compile_features(${PROJECT_NAME}
  INTERFACE
    cxx_auto_type
    cxx_constexpr
    cxx_decltype_auto
  )
target_include_directories(${PROJECT_NAME} INTERFACE ${PROJECT_SOURCE_DIR})
target_sources(${PROJECT_NAME}
  INTERFACE
  $<BUILD_INTERFACE:${header_source_files}>
  )

# HACK: There is currently no other possibility to support IntelliSense in
# some IDEs (e.g. Visual Studio Code) for INTERFACE (header-only) libraries.
add_custom_target(${PROJECT_NAME}_ide SOURCES ${header_source_files})
set_property(TARGET ${PROJECT_NAME}_ide
PROPERTY
  FOLDER "IDE"
)

if(BUILD_TESTING)
  find_package(Catch REQUIRED)

  add_executable(${PROJECT_NAME}_test "${PROJECT_SOURCE_DIR}/main.cpp")
  target_compile_features(${PROJECT_NAME}_test
    PRIVATE
    cxx_decltype_auto
    )
  target_compile_definitions(${PROJECT_NAME}_test
    PRIVATE
    CATCH_CONFIG_MAIN
    )
  set_property(TARGET ${PROJECT_NAME}_test
    PROPERTY
      FOLDER "Tests"
    )
  target_link_libraries(${PROJECT_NAME}_test PRIVATE Catch::Catch)
  add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME}_test)
endif()

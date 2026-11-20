# The Windows layer of core_alerts (architecture §12.3, slice 2.44): the
# looping ring sound, the device check's readings, start with Windows and the
# taskbar flash. Built with the app by `flutter build windows` (CI's
# `windows-release` job); it has no unit tests.
cmake_minimum_required(VERSION 3.14)

set(PROJECT_NAME "core_alerts")
project(${PROJECT_NAME} LANGUAGES CXX)
cmake_policy(VERSION 3.14...3.25)

# Flutter's tooling links the plugin by this name.
set(PLUGIN_NAME "core_alerts_plugin")

add_library(${PLUGIN_NAME} SHARED
  "include/core_alerts/core_alerts_plugin_c_api.h"
  "core_alerts_plugin.cpp"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE
  flutter flutter_wrapper_plugin winmm powrprof ole32)

set(core_alerts_bundled_libraries "" PARENT_SCOPE)

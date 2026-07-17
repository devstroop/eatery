cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the build version.
# Each macro is only defined when the corresponding CMake variable has a
# non-empty value, so that Runner.rc can fall back to safe defaults
# (1,0,0,0 / "1.0.0") when version information is unavailable.
if(DEFINED FLUTTER_VERSION AND NOT FLUTTER_VERSION STREQUAL "")
  target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
endif()
if(DEFINED FLUTTER_VERSION_MAJOR AND NOT FLUTTER_VERSION_MAJOR STREQUAL "")
  target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
endif()
if(DEFINED FLUTTER_VERSION_MINOR AND NOT FLUTTER_VERSION_MINOR STREQUAL "")
  target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
endif()
if(DEFINED FLUTTER_VERSION_PATCH AND NOT FLUTTER_VERSION_PATCH STREQUAL "")
  target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
endif()
if(DEFINED FLUTTER_VERSION_BUILD AND NOT FLUTTER_VERSION_BUILD STREQUAL "")
  target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")
endif()

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)

# === libeaterystore (Zig + embedded SQLite) ===
# The Dart FFI loader opens "eaterystore.dll" from the executable directory, so
# copy it next to the runner (for dev runs from Visual Studio / `flutter run`
# and CI builds). Build it first with:
#   cd ..\..\libeaterystore && zig build shared-lib -Dtarget=x86_64-windows-gnu
set(EATERYSTORE_DLL
  "${CMAKE_CURRENT_SOURCE_DIR}/../../libeaterystore/zig-out/bin/eaterystore.dll")
if(EXISTS "${EATERYSTORE_DLL}")
  add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
      "${EATERYSTORE_DLL}" "$<TARGET_FILE_DIR:${BINARY_NAME}>"
    VERBATIM)
else()
  message(WARNING
    "eaterystore.dll not found at ${EATERYSTORE_DLL}. Build it with: "
    "(cd ../../libeaterystore && zig build shared-lib -Dtarget=x86_64-windows-gnu)")
endif()

# CMake script to build Android APKs using Gradle.
# This creates an `apk` build target that constructs debug and release APKs
# and copies them to ${CMAKE_INSTALL_PREFIX}/android.
#
# Usage:
#   cmake --build <build-dir> --target apk
#   OR
#   cmake --build <build-dir> --target apk-debug
#   cmake --build <build-dir> --target apk-release

# Ensure we have android preset and paths
if(NOT ANDROID)
    message(WARNING "build-apk.cmake: ANDROID not set, skipping APK targets")
    return()
endif()

# Get the root project directory (cmake_platforms/, parent of build/)
# CMAKE_BINARY_DIR is build/x64-linux-xxx, so we go up 2 levels
get_filename_component(BUILD_PARENT "${CMAKE_BINARY_DIR}" DIRECTORY)
get_filename_component(PROJECT_ROOT "${BUILD_PARENT}" DIRECTORY)
get_filename_component(ANDROID_PROJECT_DIR "${PROJECT_ROOT}/android" ABSOLUTE)

# Ensure gradle wrapper exists
if(NOT EXISTS "${ANDROID_PROJECT_DIR}/gradlew")
    message(WARNING "Gradle wrapper not found at ${ANDROID_PROJECT_DIR}/gradlew")
endif()

# Create output directory for APKs
file(MAKE_DIRECTORY "${CMAKE_INSTALL_PREFIX}/android")

# --- Debug APK target ---
add_custom_target(apk-debug
    COMMAND
        "${ANDROID_PROJECT_DIR}/gradlew"
        -p "${ANDROID_PROJECT_DIR}"
        assembleDebug
    COMMAND
        ${CMAKE_COMMAND} -E copy
        "${ANDROID_PROJECT_DIR}/app/build/outputs/apk/debug/app-debug.apk"
        "${CMAKE_INSTALL_PREFIX}/android/app-debug.apk"
    WORKING_DIRECTORY "${ANDROID_PROJECT_DIR}"
    COMMENT "Building Android debug APK and installing to ${CMAKE_INSTALL_PREFIX}/android"
)

# --- Release APK target ---
add_custom_target(apk-release
    COMMAND
        "${ANDROID_PROJECT_DIR}/gradlew"
        -p "${ANDROID_PROJECT_DIR}"
        assembleRelease
    COMMAND
        ${CMAKE_COMMAND} -E copy
        "${ANDROID_PROJECT_DIR}/app/build/outputs/apk/release/app-release.apk"
        "${CMAKE_INSTALL_PREFIX}/android/app-release.apk"
    WORKING_DIRECTORY "${ANDROID_PROJECT_DIR}"
    COMMENT "Building Android release APK and installing to ${CMAKE_INSTALL_PREFIX}/android"
)

# --- Combined APK target (builds both debug and release) ---
add_custom_target(apk
    DEPENDS apk-debug apk-release
    COMMENT "Building all Android APKs"
)

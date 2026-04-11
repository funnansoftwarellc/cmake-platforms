project(hello-triangle)

if(ANDROID)
    add_library(${PROJECT_NAME} SHARED)
else()
    add_executable(${PROJECT_NAME})
endif()

target_sources(${PROJECT_NAME}
    PRIVATE
        main.cpp
)

if(EMSCRIPTEN)
    set(raylib_USE_STATIC_LIBS ON)

    target_link_options(${PROJECT_NAME}
        PRIVATE
            -sUSE_GLFW=3
            -sASYNCIFY
    )

    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")

    install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.html
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.js
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.wasm
        DESTINATION web
    )
elseif(ANDROID)
    find_library(log-lib log)
    find_library(android-lib android)
    find_library(GLESv2-lib GLESv2)
    find_library(EGL-lib EGL)
    find_library(OpenSLES-lib OpenSLES)

    target_link_libraries(${PROJECT_NAME}
        PRIVATE
            ${log-lib}
            ${android-lib}
            ${GLESv2-lib}
            ${EGL-lib}
            ${OpenSLES-lib}
            atomic
    )

    # Force-export ANativeActivity_onCreate from raylib's static lib so that
    # Android's NativeActivity can find the entry point in the shared library.
    target_link_options(${PROJECT_NAME}
        PRIVATE
            -u ANativeActivity_onCreate
    )
else()
    find_package(glfw3 CONFIG REQUIRED)

    target_link_libraries(${PROJECT_NAME}
        PRIVATE
            glfw
    )
endif()

find_package(raylib CONFIG REQUIRED)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        raylib
)

if(NOT EMSCRIPTEN)
    install(TARGETS ${PROJECT_NAME}
        BUNDLE DESTINATION .
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
endif()

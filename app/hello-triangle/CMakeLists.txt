project(hello-triangle)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
    PRIVATE
        main.cpp
)

find_package(raylib CONFIG REQUIRED)

target_link_libraries(${PROJECT_NAME} PRIVATE
    raylib
)
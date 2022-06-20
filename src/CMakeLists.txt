target_sources(
    ${CMAKE_PROJECT_NAME}
    PUBLIC
    application.c
    )

target_include_directories(
    ${CMAKE_PROJECT_NAME}
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

add_library(greeter
    src/greeter.cpp
)

target_include_directories(greeter
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        src
)

add_subdirectory(test)
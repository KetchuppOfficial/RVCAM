cmake_minimum_required(VERSION 3.21)

project(rvcam
        LANGUAGES CXX)

if (${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR})
    message(FATAL_ERROR "In-source build is forbidden")
endif()

find_package(verilator REQUIRED)
find_package(fmt REQUIRED)
find_package(elfio REQUIRED)
find_package(CLI11 REQUIRED)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(${CMAKE_PROJECT_NAME} src/main.cpp)
target_compile_features(${CMAKE_PROJECT_NAME} PRIVATE cxx_std_23)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE fmt::fmt)

verilate(${CMAKE_PROJECT_NAME}
    SOURCES
        src/adder.sv
        src/alu.sv
    TOP_MODULE
        ALU
    PREFIX
        ${CMAKE_PROJECT_NAME}
)

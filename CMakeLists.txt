cmake_minimum_required(VERSION 3.21)

project(riscv-verilog
        LANGUAGES CXX)

if (${PROJECT_SOURCE_DIR} STREQUAL ${PROJECT_BINARY_DIR})
    message(FATAL_ERROR "In-source build is forbidden")
endif()

find_package(verilator REQUIRED)
find_package(fmt REQUIRED)
find_package(elfio REQUIRED)
find_package(CLI11 REQUIRED)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# temporary executable to check that nix works as advertised
add_executable(hello main.cpp)
target_link_libraries(hello PRIVATE fmt::fmt)

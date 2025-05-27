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
        src/control-unit/alu-decoder.sv
        src/control-unit/control-unit.sv
        src/control-unit/main-decoder.sv

        src/memory/data-memory.sv
        src/memory/instruction-memory.sv

        src/pipeline/decode/decode.sv
        src/pipeline/decode/imm-decoder.sv
        src/pipeline/decode/reg-file.sv

        src/pipeline/execute/alu-arg-source.sv
        src/pipeline/execute/execute.sv
        src/pipeline/execute/pc-source-decoder.sv

        src/pipeline/fetch/fetch.sv
        src/pipeline/fetch/next-pc.sv

        src/pipeline/write-back/write-back.sv

        src/pipeline/data-path.sv
        src/pipeline/hazard-unit.sv

        src/utils/adder-nzcv.sv
        src/utils/adder.sv
        src/utils/alu.sv
        src/utils/enabled-flip-flop-with-clear.sv
        src/utils/enabled-flip-flop.sv
        src/utils/flip-flop-with-clear.sv
        src/utils/flip-flop.sv

        src/hart.sv
        src/top.sv
    INCLUDE_DIRS
        include
    TOP_MODULE
        Top
    PREFIX
        ${CMAKE_PROJECT_NAME}
)

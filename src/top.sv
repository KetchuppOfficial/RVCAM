`include "constants.sv"

module Top(
    input logic clk, reset
);
    logic[`INSTR_LEN-1:0] instr;
    logic[`XLEN-1:0] pc, addr, read_data, write_data;
    logic we_memory;

    Hart hart(
        // inputs
        clk, reset,
        instr, read_data,
        // outputs
        pc, addr, write_data, we_memory
    );

    InstructionMemory #(/*ADDR_BITS=*/12) instr_memory(
        // inputs
        pc,
        // outputs
        instr
    );

    DataMemory #(/*ADDR_BITS=*/24) data_memory(
        // inputs
        clk, we_memory,
        addr, write_data,
        // outputs
        read_data
    );
endmodule

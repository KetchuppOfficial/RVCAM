`include "constants.sv"

module FetchStage(
    input logic clk, reset,
    input logic stall_fetch,
    input logic[`PC_SRC_BITS_COUNT-1:0] pc_source,
    input logic[`XLEN-1:0] pc_plus_imm_execute, alu_result_execute,

    output logic[`XLEN-1:0] pc_fetch, pc_plus_4
);
    logic[`XLEN-1:0] next_pc_fetch;

    NextPC next_pc_mod(
        // inputs
        pc_source, pc_plus_4, pc_plus_imm_execute, alu_result_execute,
        // outputs
        next_pc_fetch
    );

    EnabledFF #(`XLEN) pc_reg(
        // inputs
        clk, reset, ~stall_fetch, next_pc_fetch,
        // outputs
        pc_fetch
    );

    Adder #(`XLEN) pc_plus_4_adder(
        // inputs
        pc_fetch, {{`XLEN-3{1'b0}}, 3'b100}, `ADDER_ADD,
        // outputs
        pc_plus_4
    );
endmodule

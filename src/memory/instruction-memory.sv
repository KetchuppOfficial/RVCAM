`include "constants.sv"

module InstructionMemory #(
    parameter N_WORDS
) (
    input logic[`XLEN-1:0] addr,

    output logic[`INSTR_LEN-1:0] instruction
);
    logic[`INSTR_LEN-1:0] RAM[N_WORDS:0];

    initial
        $readmemh("memory-image.txt", RAM);

    assign rd = RAM[addr[`XLEN-1:2]]; // instructions are 4-byte aligned
endmodule

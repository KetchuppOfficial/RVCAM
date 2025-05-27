`include "constants.sv"

module InstructionMemory #(
    parameter ADDR_BITS
) (
    input logic[`XLEN-1:0] addr,

    output logic[`INSTR_LEN-1:0] instruction
);
    localparam kActualAddrBits = ADDR_BITS - 2;

    logic[`INSTR_LEN-1:0] RAM[2**kActualAddrBits-1:0];

    initial
        $readmemh("memory-image.txt", RAM);

    assign instruction = RAM[addr[ADDR_BITS-1:2]]; // instructions are 4-byte aligned
endmodule

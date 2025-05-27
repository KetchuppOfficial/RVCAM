`include "constants.sv"

module DataMemory #(
    parameter ADDR_BITS
) (
    input logic clk, we,
    input logic[`XLEN-1:0] addr, input_data,

    output logic[`XLEN-1:0] output_data
);
    localparam kActualAddrBits = ADDR_BITS - 3;

    logic[kActualAddrBits-1:0] cell_index;
    logic [`XLEN-1:0] RAM[2**kActualAddrBits-1:0];

    assign cell_index = addr[ADDR_BITS-1:3];
    assign output_data = RAM[cell_index];

    always_ff @(posedge clk)
        if (we)
            RAM[cell_index] <= input_data;
endmodule

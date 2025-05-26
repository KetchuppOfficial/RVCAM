`include "constants.sv"

module DataMemory #(
    parameter N_WORDS
) (
    input logic clk, we,
    input logic[`XLEN-1:0] addr, input_data,

    output logic[`XLEN-1:0] output_data
);
    logic[`XLEN-3:0] cell_index;
    logic [`XLEN-1:0] RAM[N_WORDS-1:0];

    assign cell_index = addr[`XLEN:3];
    assign output_data = RAM[cell_index];

    always_ff @(posedge clk)
        if (we)
            RAM[cell_index] <= input_data;
endmodule

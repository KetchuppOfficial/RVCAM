`include "constants.sv"

module Adder #(
    parameter N = `XLEN
) (
    input logic[N-1:0] a, b,
    input logic control,

    output logic[N-1:0] result
);
    logic[N-1:0] b_or_inv_b;
    logic carry;

    assign b_or_inv_b = control ? ~b : b;
    assign {carry, result} = a + b_or_inv_b + {{N-1{1'b0}}, control};
endmodule

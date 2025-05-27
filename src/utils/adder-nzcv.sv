`include "constants.sv"

module AdderNZCV #(
    parameter N = `XLEN
) (
    input logic[N-1:0] a, b,
    input logic control,

    output logic[N-1:0] result,
    output logic n, z, c, v
);
    logic[N-1:0] b_or_inv_b;
    logic a_sign, b_sign, result_sign;

    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign result_sign = result[N-1];

    assign n = result[N-1];
    assign z = (result == 0);
    assign v = (a_sign ^ result_sign) // "a" and "result" have opposite signs
             & ~(control ^ (a_sign ^ b_sign)); // addition:    sign(a) == sign(b), or
                                               // subtraction: sign(a) != sign(b)

    assign b_or_inv_b = control ? ~b : b;
    assign {c, result} = a + b_or_inv_b + {{N-1{1'b0}}, control };
endmodule

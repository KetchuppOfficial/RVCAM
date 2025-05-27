`include "constants.sv"

module ALU #(
    parameter N = `XLEN
) (
    input logic[N-1:0] a, b,
    input logic[3:0] control,

    output logic[N-1:0] result,
    output logic n, z, c, v
);
    logic[N-1:0] sum;

    AdderNZCV adder(.a(a), .b(b), .control(control[0]),
                .result(sum), .n(n), .z(z), .c(c), .v(v));

    always_comb
        case (control)
            `ALU_CNTL_ADD:
                result = sum;
            `ALU_CNTL_AND:
                result = a & b;
            `ALU_CNTL_OR:
                result = a | b;
            `ALU_CNTL_XOR:
                result = a ^ b;
            `ALU_CNTL_SLL:
                result = a << b;
            `ALU_CNTL_SRL:
                result = a >> b;
            `ALU_CNTL_SRA:
                result = a >>> b;
            `ALU_CNTL_SUB:
                result = sum;
            `ALU_CNTL_SLT:
                result = {{N-1{1'b0}}, n ^ v};
            `ALU_CNTL_SLTU:
                result = {{N-1{1'b0}}, ~c};
            default:
                result = {N{1'bx}};
        endcase
endmodule

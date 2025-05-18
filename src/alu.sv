module ALU #(
    parameter N = 64
) (
    input logic[N-1:0] a, b,
    input logic[3:0] control,

    output logic[N-1:0] result
);
    logic n, z, c, v;
    logic[N-1:0] sum;

    Adder adder(.a(a), .b(b), .control(control[0]),
                   .result(sum), .n(n), .z(z), .c(c), .v(v));

    always_comb
        case (control)
            4'b000_0: // add
                result = sum;
            4'b000_1: // sub
                result = sum;
            4'b001_0: // and
                result = a & b;
            4'b010_0: // or
                result = a | b;
            4'b011_0: // xor
                result = a ^ b;
            4'b010_1: // eq
                result = {{N-1{1'b0}}, z};
            4'b011_1: // ne
                result = {{N-1{1'b0}}, ~z};
            4'b100_1: // slt
                result = {{N-1{1'b0}}, n ^ v};
            4'b101_1: // sltu
                result = {{N-1{1'b0}}, ~c};
            4'b110_1: // sge
                result = {{N-1{1'b0}}, ~(n ^ v)};
            4'b111_1: // sgeu
                result = {{N-1{1'b0}}, c};
            default:
                result = {N{1'bx}};
        endcase
endmodule

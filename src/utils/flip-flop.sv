module FF #(
    parameter N
) (
    input logic clk, reset,
    input logic[N-1:0] in,

    output logic[N-1:0] out
);
    always_ff @(posedge clk, posedge reset)
        if (reset)
            out <= 0;
        else
            out <= in;
endmodule

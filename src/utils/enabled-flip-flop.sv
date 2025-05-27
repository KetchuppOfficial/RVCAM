module EnabledFF #(
    parameter N
) (
    input logic clk, reset, en,
    input logic[N-1:0] in,

    output logic[N-1:0] out
);
    always_ff @(posedge clk, posedge reset)
        if (reset)
            out <= 0;
        else if (en)
            out <= in;
endmodule

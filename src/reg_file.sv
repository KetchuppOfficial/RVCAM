module RegFile #(
    parameter XLEN = 64,
    parameter NREGS = 32
) (
    input logic clk,
    input logic we3,
    input logic[$clog(NREGS):0] addr1, addr2, addr3,
    input logic[XLEN-1:0] wd3,

    output logic[XLEN-1:0] rd1, rd2
);
    logic[XLEN-1:0] reg_file[NREGS-1:0];

    always_ff @(posedge clk)
        if (we3)
            reg_file[addr3] <= wd3;

    assign rd1 = (addr1 == 0) ? 0 : reg_file[addr1];
    assign rd2 = (addr2 == 0) ? 0 : reg_file[addr2];
endmodule

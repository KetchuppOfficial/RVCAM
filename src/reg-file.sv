`include "constants.sv"

module RegFile #(
    parameter N = `XLEN,
    parameter GPRS = `GPRS_COUNT
) (
    input logic clk,
    input logic we3,
    input logic[$clog(GPRS):0] addr1, addr2, addr3,
    input logic[N-1:0] wd3,

    output logic[N-1:0] rd1, rd2
);
    logic[N-1:0] reg_file[GPRS-1:0];

    always_ff @(negedge clk)
        if (we3)
            reg_file[addr3] <= wd3;

    assign rd1 = (addr1 == 0) ? 0 : reg_file[addr1];
    assign rd2 = (addr2 == 0) ? 0 : reg_file[addr2];
endmodule

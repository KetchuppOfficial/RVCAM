`include "constants.sv"

module HazardUnit(
    input logic[`GPR_ENCODE_BITS-1:0] rs1_decode, rs2_decode, rs1_execute, rs2_execute,
    input logic[`GPR_ENCODE_BITS-1:0] rd_execute, rd_memory, rd_writeback,
    input logic branch_taken, load_on_execute,
    input logic we_gpr_memory, we_gpr_writeback,

    output logic[`FORWARD_SRC_BITS_COUNT-1:0] forward_rs1, forward_rs2,
    output logic stall_fetch, stall_decode, flush_decode, flush_execute
);
    logic stall_because_of_load;

    always_comb begin
        forward_rs1 = `NO_FORWARDING;
        if (rs1_execute != {`GPR_ENCODE_BITS{1'b0}}) begin
            if (we_gpr_memory & (rs1_execute == rd_memory))
                forward_rs1 = `FORWARD_FROM_MEMORY;
            else if (we_gpr_writeback & (rs1_execute == rd_writeback))
                forward_rs1 = `FORWARD_FROM_WRITEBACK;
        end

        forward_rs2 = `NO_FORWARDING;
        if (rs2_execute != {`GPR_ENCODE_BITS{1'b0}})
            if (we_gpr_memory & (rs2_execute == rd_memory))
                forward_rs2 = `FORWARD_FROM_MEMORY;
            else if (we_gpr_writeback & (rs2_execute == rd_writeback))
                forward_rs2 = `FORWARD_FROM_WRITEBACK;
    end

    assign stall_because_of_load = load_on_execute
                                 & (rs1_decode == rd_execute | rs2_decode == rd_execute);
    assign stall_fetch = stall_because_of_load;
    assign stall_decode = stall_because_of_load;

    assign flush_decode = branch_taken;
    assign flush_execute = stall_because_of_load | branch_taken;
endmodule

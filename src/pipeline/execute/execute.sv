`include "constants.sv"

module ExecuteStage(
    input logic[`XLEN-1:0] gpr1_value, gpr2_value, pc, imm, alu_result_memory, result_writeback,
    input logic[`FORWARD_SRC_BITS_COUNT-1:0] forward_rs1, forward_rs2,
    input logic[`ALU_CNTL_BITS_COUNT-1:0] alu_control,
    input logic alu_src1, alu_src2,
    input logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type,

    output logic[`XLEN-1:0] alu_result, pc_plus_imm, gpr2_value_or_forwarded_value,
    output logic[`PC_SRC_BITS_COUNT-1:0] pc_source,
    output logic branch_taken
);
    logic[`XLEN-1:0] alu_arg1, alu_arg2, ignore;
    logic n, z, c, v;

    ALUArgSource alu_arg1_source(
        // inputs
        gpr1_value, alu_result_memory, result_writeback, {`XLEN{1'b0}}, forward_rs1, alu_src1,
        // outputs
        alu_arg1, ignore
    );

    ALUArgSource alu_arg2_source(
        // inputs
        gpr2_value, alu_result_memory, result_writeback, imm, forward_rs2, alu_src2,
        // outputs
        alu_arg2, gpr2_value_or_forwarded_value
    );

    ALU #(/*N = */`XLEN) alu(
        // inputs
        alu_arg1, alu_arg2, alu_control,
        // outputs
        alu_result, n, z, c, v
    );

    PCSourceDecoder pc_source_decoder(
        // inputs:
        branch_type, n, z, c, v,
        // outputs:
        pc_source, branch_taken
    );

    Adder #(/*N = */`XLEN) adder(
        // inputs
        pc, imm, `ADDER_ADD,
        // outputs
        pc_plus_imm
    );
endmodule

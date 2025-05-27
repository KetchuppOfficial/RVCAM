`include "constants.sv"

module DecodeStage(
    input logic clk,
    input logic[`INSTR_LEN-1:0] instruction,
    input logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type,
    input logic we_gpr_writeback,
    input logic[`GPR_ENCODE_BITS-1:0] rd_writeback,
    input logic[`XLEN-1:0] result_writeback,

    output logic[`OPCODE_LEN-1:0] opcode,
    output logic[`FUNCT3_LEN-1:0] funct3,
    output logic funct7_bit5,
    output logic[`GPR_ENCODE_BITS-1:0] rs1, rs2, rd,
    output logic[`XLEN-1:0] imm,
    output logic[`XLEN-1:0] gpr1_value, gpr2_value
);
    assign opcode = instruction[`OPCODE_END:`OPCODE_BEGIN];
    assign funct3 = instruction[`FUNCT3_END:`FUNCT3_BEGIN];
    assign funct7_bit5 = instruction[`FUNCT7_BEGIN + 5];
    assign rs1 = instruction[`RS1_END:`RS1_BEGIN];
    assign rs2 = instruction[`RS2_END:`RS2_BEGIN];
    assign rd = instruction[`RD_END:`RD_BEGIN];

    RegFile #(/*N = */`XLEN) reg_file(
        // inputs
        clk, we_gpr_writeback, rs1, rs2, rd_writeback, result_writeback,
        // outputs
        gpr1_value, gpr2_value
    );

    ImmDecoder imm_decoder(
        // inputs
        instruction[31:7], imm_type,
        // outputs
        imm
    );
endmodule

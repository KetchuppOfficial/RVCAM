`include "constants.sv"

module ControlUnit (
    input logic[`OPCODE_LEN-1:0] opcode,
    input logic[`FUNCT3_LEN-1:0] funct3,
    input logic funct7_bit5,

    output logic[`RESULT_SRC_BITS_COUNT-1:0] result_src,
    output logic we_memory,
    output logic alu_src1, alu_src2,
    output logic[`ALU_CNTL_BITS_COUNT-1:0] alu_control,
    output logic we_gpr,
    output logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type,
    output logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type
);
    logic[`ALU_OP_BITS_COUNT-1:0] alu_op;

    MainDecoder main_decoder(
        // inputs:
        opcode, funct3,
        // outputs:
        imm_type, alu_src1, alu_src2, alu_op, branch_type, we_memory, we_gpr, result_src
    );

    ALUDecoder alu_decoder(
        // inputs:
        alu_op, funct3, funct7_bit5, opcode[5],
        // outputs:
        alu_control
    );
endmodule

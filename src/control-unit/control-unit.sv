`include "constants.sv"

module ControlUnit (
    input logic[`OPCODE_LEN-1:0] opcode,
    input logic[`FUNCT3_LEN-1:0] funct3,
    input logic funct7_bit5,
    input logic zero_flag,

    output logic[`RESULT_SRC_BITS_COUNT-1:0] result_src,
    output logic write_memory,
    output logic[`PC_SRC_BITS_COUNT-1:0] pc_source,
    output logic alu_src2,
    output logic[`ALU_CNTL_BITS_COUNT-1:0] alu_control,
    output logic write_gpr,
    output logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type
);
    logic[`ALU_OP_BITS_COUNT-1:0] alu_op;
    logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type;

    MainDecoder main_decoder(
        // inputs:
        opcode,
        // outputs:
        imm_type, alu_src2, alu_op, branch_type, write_memory, write_gpr, result_src
    );

    ALUDecoder alu_decoder(
        // inputs:
        alu_op, funct3, funct7_bit5, opcode[5],
        // outputs:
        alu_control
    );

    PCSourceDecoder pc_source_decoder(
        // inputs:
        branch_type, zero_flag,
        // outputs:
        pc_source
    );
endmodule

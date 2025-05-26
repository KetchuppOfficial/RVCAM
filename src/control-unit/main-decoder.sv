`include "constants.sv"

module MainDecoder (
    input logic[`OPCODE_LEN-1:0] opcode,

    output logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type,
    output logic alu_src2,
    output logic[`ALU_OP_BITS_COUNT-1:0] alu_op,
    output logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type,
    output logic write_memory,
    output logic write_gpr,
    output logic[`RESULT_SRC_BITS_COUNT-1:0] result_src
);
    localparam kControlBitsCount = `IMM_TYPE_BITS_COUNT +
                                   `ALU_OP_BITS_COUNT +
                                   `RESULT_SRC_BITS_COUNT + 5;
    logic[kControlBitsCount-1:0] controls;

    assign {imm_type, alu_src2, alu_op, is_cond_branch,
            is_uncond_branch, write_memory, write_gpr, write_gpr_src} = controls;

    always_comb
        case (opcode)
            `OP_AUIPC:
                controls = {`IMM_TYPE_U,
                            1'bx,
                            {`ALU_OP_BITS_COUNT{1'bx}},
                            `BRANCH_TYPE_NOT_BRANCH,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_PC_PLUS_IMM};
            `OP_LUI:
                controls = {`IMM_TYPE_U,
                            1'bx,
                            {`ALU_OP_BITS_COUNT{1'bx}},
                            `BRANCH_TYPE_NOT_BRANCH,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_IMM};
            `OP_JALR:
                controls = {`IMM_TYPE_I,
                            `ALU_SRC2_IMM,
                            `ALU_OP_ADD,
                            `BRANCH_TYPE_INDIRECT,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_PC_PLUS_4};
            `OP_JAL:
                controls = {`IMM_TYPE_J,
                            1'bx,
                            {`ALU_OP_BITS_COUNT{1'bx}},
                            `BRANCH_TYPE_UNCOND,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_PC_PLUS_4};
            `OP_LOAD:
                controls = {`IMM_TYPE_I,
                            `ALU_SRC2_IMM,
                            `ALU_OP_ADD,
                            `BRANCH_TYPE_NOT_BRANCH,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_MEM};
            `OP_STORE:
                controls = {`IMM_TYPE_S,
                            `ALU_SRC2_IMM,
                            `ALU_OP_ADD,
                            `BRANCH_TYPE_NOT_BRANCH,
                            1'b1,
                            1'b0,
                            {`RESULT_SRC_BITS_COUNT{1'bx}}};
            `OP_COND_BR:
                controls = {`IMM_TYPE_B,
                            `ALU_SRC2_GPR,
                            `ALU_OP_SUB,
                            `BRANCH_TYPE_COND,
                            1'b0,
                            1'b0,
                            {`RESULT_SRC_BITS_COUNT{1'bx}}};
            `OP_RV32_REG_REG_ARITH:
                controls = {{`IMM_TYPE_BITS_COUNT{1'bx}},
                            `ALU_SRC2_GPR,
                            `ALU_OP_OTH,
                            1'b0,
                            1'b0,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_ALU};
            `OP_RV32_REG_IMM_ARITH:
                controls = {`IMM_TYPE_I,
                            `ALU_SRC2_IMM,
                            `ALU_OP_OTH,
                            `BRANCH_TYPE_NOT_BRANCH,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_ALU};
            `OP_RV64_REG_IMM_ARITH:
                controls = {`IMM_TYPE_I,
                            `ALU_SRC2_IMM,
                            `ALU_OP_OTH,
                            `BRANCH_TYPE_NOT_BRANCH,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_ALU};
            `OP_RV64_REG_REG_ARITH:
                controls = {{`IMM_TYPE_BITS_COUNT{1'bx}},
                            `ALU_SRC2_GPR,
                            `ALU_OP_OTH,
                            `BRANCH_TYPE_NOT_BRANCH,
                            1'b0,
                            1'b1,
                            `RESULT_SRC_ALU};
            default:
                controls = {kControlBitsCount{1'bx}};
        endcase
endmodule

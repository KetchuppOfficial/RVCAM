`include "constants.sv"

module ImmDecoder (
    input logic[`INSTR_LEN-1:`OPCODE_END+1] imm,
    input logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type,

    output logic[`XLEN-1:0] sext_imm
);
    logic sign_bit;

    assign sign_bit = imm[`INSTR_LEN-1];

    always_comb
        case (imm_type)
            `IMM_TYPE_I:
                sext_imm = {{`XLEN-`I_TYPE_BITS{sign_bit}},
                            imm[31:20]};
            `IMM_TYPE_S:
                sext_imm = {{`XLEN-`S_TYPE_BITS{sign_bit}},
                            imm[31:25],
                            imm[11:7]};
            `IMM_TYPE_B:
                sext_imm = {{`XLEN-`B_TYPE_BITS{sign_bit}},
                            sign_bit,
                            imm[7],
                            imm[30:25],
                            imm[11:8],
                            1'b0};
            `IMM_TYPE_U:
                sext_imm = {{`XLEN-`U_TYPE_BITS{sign_bit}},
                            imm[31:12],
                            12'b0};
            `IMM_TYPE_J:
                sext_imm = {{`XLEN-`J_TYPE_BITS{sign_bit}},
                            sign_bit,
                            imm[19:12],
                            imm[20],
                            imm[30:21],
                            1'b0};
            default:
                sext_imm = {`XLEN{1'bx}};
        endcase
endmodule

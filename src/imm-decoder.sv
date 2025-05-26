`include "constants.sv"

module ImmDecoder (
    input logic[`MAX_IMM_LEN-1:0] imm,
    input logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type,

    output logic[`XLEN-1:0] sext_imm
);
    function int shift(int value);
        return value -`OPCODE_LEN;
    endfunction

    logic sign_bit;

    assign sign_bit = imm[shift(31)];

    always_comb
        case (imm_type)
            `IMM_TYPE_I:
                sext_imm = {{`XLEN-`I_TYPE_BITS{sign_bit}},
                            imm[shift(31):shift(20)]};
            `IMM_TYPE_S:
                sext_imm = {{`XLEN-`S_TYPE_BITS{sign_bit}},
                            imm[shift(31):shift(25)],
                            imm[shift(11):shift(7)]};
            `IMM_TYPE_B:
                sext_imm = {{`XLEN-`B_TYPE_BITS{sign_bit}},
                            sign_bit,
                            imm[shift(7)],
                            imm[shift(30):shift(25)],
                            imm[shift(11):shift(8)],
                            1'b0};
            `IMM_TYPE_U:
                sext_imm = {{`XLEN-`U_TYPE_BITS{sign_bit}},
                            imm[shift(31):shift(12)],
                            12'b0};
            `IMM_TYPE_J:
                sext_imm = {{`XLEN-`J_TYPE_BITS{sign_bit}},
                            sign_bit,
                            imm[shift(19):shift(12)],
                            imm[shift(20)],
                            imm[shift(30):shift(21)],
                            1'b0};
            default: sext_imm = {`XLEN{1'bx}};
        endcase
endmodule

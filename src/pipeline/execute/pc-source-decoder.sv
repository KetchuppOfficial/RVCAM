`include "constants.sv"

module PCSourceDecoder (
    input logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type,
    input logic n, z, c, v,

    output logic[`PC_SRC_BITS_COUNT-1:0] pc_source,
    output logic branch_taken
);
    logic[`PC_SRC_BITS_COUNT:0] result;

    assign {pc_source, branch_taken} = result;

    always_comb
        case (branch_type)
            `BRANCH_TYPE_NOT_BRANCH:
                result = {`PC_SRC_PC_PLUS_4, 1'b0};
            `BRANCH_TYPE_JAL:
                result = {`PC_SRC_PC_PLUS_IMM, 1'b1};
            `BRANCH_TYPE_JALR:
                result = {`PC_SRC_GPR_PLUS_IMM, 1'b1};
            `BRANCH_TYPE_BEQ:
                if (z)
                    result = {`PC_SRC_PC_PLUS_IMM, 1'b1};
                else
                    result = {`PC_SRC_PC_PLUS_4, 1'b0};
            `BRANCH_TYPE_BNE:
                if (~z)
                    result = {`PC_SRC_PC_PLUS_IMM, 1'b1};
                else
                    result = {`PC_SRC_PC_PLUS_4, 1'b0};
            `BRANCH_TYPE_BLT:
                if (n ^ v)
                    result = {`PC_SRC_PC_PLUS_IMM, 1'b1};
                else
                    result = {`PC_SRC_PC_PLUS_4, 1'b0};
            `BRANCH_TYPE_BGE:
                if (~(n ^ v))
                    result = {`PC_SRC_PC_PLUS_IMM, 1'b1};
                else
                    result = {`PC_SRC_PC_PLUS_4, 1'b0};
            `BRANCH_TYPE_BLTU:
                if (~c)
                    result = {`PC_SRC_PC_PLUS_IMM, 1'b1};
                else
                    result = {`PC_SRC_PC_PLUS_4, 1'b0};
            `BRANCH_TYPE_BGEU:
                if (c)
                    result = {`PC_SRC_PC_PLUS_IMM, 1'b1};
                else
                    result = {`PC_SRC_PC_PLUS_4, 1'b0};
            default:
                result = {1 + `PC_SRC_BITS_COUNT{1'bx}};
        endcase
endmodule

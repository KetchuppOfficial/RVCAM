`include "constants.sv"

module PCSourceDecoder (
    input logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type,
    input logic zero_flag,

    output logic[`PC_SRC_BITS_COUNT-1:0] pc_source
);
    always_comb
        case (branch_type)
            `BRANCH_TYPE_NOT_BRANCH:
                pc_source = `PC_SRC_PC_PLUS_4;
            `BRANCH_TYPE_UNCOND:
                pc_source = `PC_SRC_PC_PLUS_IMM;
            `BRANCH_TYPE_COND:
                if (zero_flag)
                    pc_source = `PC_SRC_PC_PLUS_IMM;
                else
                    pc_source = `PC_SRC_PC_PLUS_4;
            `BRANCH_TYPE_INDIRECT:
                pc_source = `PC_SRC_GPR_PLUS_IMM;
            default:
                pc_source = {`PC_SRC_BITS_COUNT{1'bx}};
        endcase
endmodule

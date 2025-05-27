`include "constants.sv"

module NextPC(
    input logic[`PC_SRC_BITS_COUNT-1:0] pc_source,
    input logic[`XLEN-1:0] pc_plus_4_fetch, pc_plus_imm_execute, alu_result_execute,

    output logic[`XLEN-1:0] next_pc_fetch
);
    always_comb
        case (pc_source)
            `PC_SRC_PC_PLUS_4:
                next_pc_fetch = pc_plus_4_fetch;
            `PC_SRC_PC_PLUS_IMM:
                next_pc_fetch = pc_plus_imm_execute;
            `PC_SRC_GPR_PLUS_IMM:
                next_pc_fetch = alu_result_execute;
            default:
                next_pc_fetch = {`XLEN{1'bx}};
        endcase
endmodule

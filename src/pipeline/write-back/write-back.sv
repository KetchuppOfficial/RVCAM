`include "constants.sv"

module WriteBackStage(
    input logic[`XLEN-1:0] alu_result, read_data, pc_plus_4, pc_plus_imm,
    input logic[`RESULT_SRC_BITS_COUNT-1:0] result_src,

    output logic[`XLEN-1:0] result
);
    always_comb
        case (result_src)
            `RESULT_SRC_ALU:
                result = alu_result;
            `RESULT_SRC_MEM:
                result = read_data;
            `RESULT_SRC_PC_PLUS_4:
                result = pc_plus_4;
            `RESULT_SRC_PC_PLUS_IMM:
                result = pc_plus_imm;
            default:
                result = {`XLEN{1'bx}};
        endcase
endmodule

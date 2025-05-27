`include "constants.sv"

module ALUArgSource(
    input logic[`XLEN-1:0] gpr_value, alu_result_memory, result_writeback, imm,
    input logic[`FORWARD_SRC_BITS_COUNT-1:0] forward_rs,
    input logic alu_src,

    output logic[`XLEN-1:0] alu_arg, gpr_value_or_forwarded_value
);
    always_comb
        case (forward_rs)
            `NO_FORWARDING:
                gpr_value_or_forwarded_value = gpr_value;
            `FORWARD_FROM_WRITEBACK:
                gpr_value_or_forwarded_value = result_writeback;
            `FORWARD_FROM_MEMORY:
                gpr_value_or_forwarded_value = alu_result_memory;
            default:
                gpr_value_or_forwarded_value = {`XLEN{1'bx}};
        endcase

    always_comb
        case (alu_src)
            `ALU_SRC_GPR:
                alu_arg = gpr_value_or_forwarded_value;
            `ALU_SRC_IMM:
                alu_arg = imm;
            default:
                alu_arg = {`XLEN{1'bx}};
        endcase
endmodule

`include "constants.sv"

module ALUDecoder (
    input logic[`ALU_OP_BITS_COUNT-1:0] alu_op,
    input logic[`FUNCT3_LEN-1:0] funct3,
    input logic funct7_bit5, // 0 for addition, 1 for subtraction
    input logic opcode_bit5, // 0 for reg-imm R-type instructions, 1 for reg-reg

    output logic[`ALU_CNTL_BITS_COUNT-1:0] alu_control
);
    always_comb
        case (alu_op)
            `ALU_OP_ADD:
                alu_control = `ALU_CNTL_ADD;
            `ALU_OP_SUB:
                alu_control = `ALU_CNTL_SUB;
            `ALU_OP_OTH:
                case (funct3)
                    3'b000:
                        if (opcode_bit5 & funct7_bit5)
                            alu_control = `ALU_CNTL_SUB;
                        else
                            alu_control = `ALU_CNTL_ADD;
                    3'b001:
                        alu_control = `ALU_CNTL_SLL;
                    3'b010:
                        alu_control = `ALU_CNTL_SLT;
                    3'b011:
                        alu_control = `ALU_CNTL_SLTU;
                    3'b100:
                        alu_control = `ALU_CNTL_XOR;
                    3'b101:
                        if (funct7_bit5)
                            alu_control = `ALU_CNTL_SRA;
                        else
                            alu_control = `ALU_CNTL_SRL;
                    3'b110:
                        alu_control = `ALU_CNTL_OR;
                    3'b111:
                        alu_control = `ALU_CNTL_AND;
                    default:
                        alu_control = {`ALU_CNTL_BITS_COUNT{1'bx}};
                endcase
            default:
                alu_control = {`ALU_CNTL_BITS_COUNT{1'bx}};
        endcase
endmodule

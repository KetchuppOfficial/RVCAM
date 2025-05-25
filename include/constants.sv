// Common architectural constants
`define XLEN 64
`define GPRS_COUNT 32

// Instruction decoding
// Note: begin and end are inclusive
`define INSTR_LEN 32
`define OPCODE_LEN 7
`define MAX_IMM_LEN (`INSTR_LEN - `OPCODE_LEN)
`define OPCODE_BEGIN 0
`define OPCODE_END 6
`define RD_BEGIN 7
`define RD_END 11
`define FUNCT3_BEGIN 12
`define FUNCT3_END 14
`define RS1_BEGIN 15
`define RS1_END 19
`define RS2_BEGIN 20
`define RS2_END 24
`define FUNCT7_BEGIN 25
`define FUNCT7_END 31

// ALU control modes
// Note: the least significant bit must be 1 for comparison operations because they use subtraction
`define ALU_ADD  4'b000_0
`define ALU_SUB  4'b000_1
`define ALU_AND  4'b001_0
`define ALU_OR   4'b010_0
`define ALU_XOR  4'b011_0
`define ALU_EQ   4'b010_1
`define ALU_NE   4'b011_1
`define ALU_SLT  4'b100_1
`define ALU_SLTU 4'b101_1
`define ALU_SGE  4'b110_1
`define ALU_SGEU 4'b111_1

// Immediate decoding modes
`define I_TYPE 3'b000
`define S_TYPE 3'b001
`define B_TYPE 3'b010
`define U_TYPE 3'b011
`define J_TYPE 3'b100
`define I_TYPE_BITS 12
`define S_TYPE_BITS 12
`define B_TYPE_BITS 13
`define U_TYPE_BITS 32
`define J_TYPE_BITS 21

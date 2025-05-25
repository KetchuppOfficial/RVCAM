// Common architectural constants
`define XLEN 64
`define GPRS_COUNT 32

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

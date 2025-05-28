// Common architectural constants
`define XLEN 64
`define GPR_ENCODE_BITS 5
`define GPRS_COUNT (1 << 5)

// Instruction decoding
// Note: begin and end are inclusive
`define INSTR_LEN 32
`define MAX_IMM_LEN (`INSTR_LEN - `OPCODE_LEN)
`define OPCODE_BEGIN 0
`define OPCODE_END 6
`define OPCODE_LEN (`OPCODE_END - `OPCODE_BEGIN + 1)
`define RD_BEGIN 7
`define RD_END 11
`define FUNCT3_BEGIN 12
`define FUNCT3_END 14
`define FUNCT3_LEN (`FUNCT3_END - `FUNCT3_BEGIN + 1)
`define RS1_BEGIN 15
`define RS1_END 19
`define RS2_BEGIN 20
`define RS2_END 24
`define FUNCT7_BEGIN 25
`define FUNCT7_END 31
`define FUNCT7_LEN (`FUNCT7_END - `FUNCT7_BEGIN + 1)

// Opcodes
`define OP_SYSTEM             7'b1110011 // ecall, ebreak
`define OP_AUIPC              7'b0010111
`define OP_LUI                7'b0110111
`define OP_JALR               7'b1100111
`define OP_JAL                7'b1101111
`define OP_LOAD               7'b0000011
`define OP_STORE              7'b0100011
`define OP_COND_BR            7'b1100011
`define OP_RV32_REG_REG_ARITH 7'b0110011
`define OP_RV32_REG_IMM_ARITH 7'b0010011
`define OP_RV64_REG_IMM_ARITH 7'b0011011
`define OP_RV64_REG_REG_ARITH 7'b0111011

// Adder control signal
`define ADDER_ADD 1'b0
`define ADDER_SUB 1'b1

// Primary ALU operation type derived from opcode. The first two map directly to ALU control modes,
// the last one requires analysis of funct3 and funct7.
`define ALU_OP_BITS_COUNT 2
`define ALU_OP_ADD 2'b00 // auipc, jalr, loads, stores
`define ALU_OP_SUB 2'b01 // conditional branches
`define ALU_OP_OTH 2'b10 // reg-reg and reg-imm R-type instructions

// ALU control modes
// Note: the least significant bit must be 1 for comparison operations because they use subtraction
`define ALU_CNTL_BITS_COUNT 4
`define ALU_CNTL_ADD  4'b000_0
`define ALU_CNTL_AND  4'b001_0
`define ALU_CNTL_OR   4'b010_0
`define ALU_CNTL_XOR  4'b011_0
`define ALU_CNTL_SLL  4'b100_0
`define ALU_CNTL_SRL  4'b101_0
`define ALU_CNTL_SRA  4'b110_0
`define ALU_CNTL_SUB  4'b000_1
`define ALU_CNTL_SLT  4'b001_1
`define ALU_CNTL_SLTU 4'b010_1

// Source of ALU arguments
`define ALU_SRC_GPR 1'b0
`define ALU_SRC_IMM 1'b1

// Immediate decoding modes
`define IMM_TYPE_BITS_COUNT 3
`define IMM_TYPE_I          3'b000
`define IMM_TYPE_S          3'b001
`define IMM_TYPE_B          3'b010
`define IMM_TYPE_U          3'b011
`define IMM_TYPE_J          3'b100
`define I_TYPE_BITS 12
`define S_TYPE_BITS 12
`define B_TYPE_BITS 13
`define U_TYPE_BITS 32
`define J_TYPE_BITS 21

// Result source
`define RESULT_SRC_BITS_COUNT  2
`define RESULT_SRC_ALU         2'b00
`define RESULT_SRC_MEM         2'b01
`define RESULT_SRC_PC_PLUS_4   2'b10
`define RESULT_SRC_PC_PLUS_IMM 2'b11

// Branch types
// Note: bits 3:1 of conditional branches correspond to their's funct3 field
`define BRANCH_TYPE_BITS_COUNT 4
`define BRANCH_TYPE_NOT_BRANCH 4'b000_0
`define BRANCH_TYPE_JAL        4'b001_0
`define BRANCH_TYPE_JALR       4'b010_0
`define BRANCH_TYPE_BEQ        4'b000_1
`define BRANCH_TYPE_BNE        4'b001_1
`define BRANCH_TYPE_BLT        4'b100_1
`define BRANCH_TYPE_BGE        4'b101_1
`define BRANCH_TYPE_BLTU       4'b110_1
`define BRANCH_TYPE_BGEU       4'b111_1

// PC source
`define PC_SRC_BITS_COUNT   2
`define PC_SRC_PC_PLUS_4    2'b00 // other instructions
`define PC_SRC_PC_PLUS_IMM  2'b01 // jal or one of beq, bne, blt, bge, bltu, bgeu is taken
`define PC_SRC_GPR_PLUS_IMM 2'b10 // jalr

// Hazard unit
`define FORWARD_SRC_BITS_COUNT 2
`define NO_FORWARDING          2'b00
`define FORWARD_FROM_WRITEBACK 2'b01
`define FORWARD_FROM_MEMORY    2'b10

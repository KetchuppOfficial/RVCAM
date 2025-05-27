`include "constants.sv"

module DataPath(
    // General inputs
    input logic clk, reset,

    // Inputs from instruction memory
    input logic[`INSTR_LEN-1:0] instr_fetch,

    // Inputs from control input
    input logic we_gpr,
    input logic[`RESULT_SRC_BITS_COUNT-1:0] result_src,
    input logic we_memory,
    input logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type,
    input logic[`ALU_CNTL_BITS_COUNT-1:0] alu_control,
    input logic alu_src1, alu_src2,
    input logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type,

    // Inputs from hazard unit
    input logic stall_fetch, stall_decode, flush_decode, flush_execute,
    input logic[`FORWARD_SRC_BITS_COUNT-1:0] forward_rs1, forward_rs2,

    // Input from memory
    input logic[`XLEN-1:0] read_data,

    // Outputs to control unit
    output logic[`OPCODE_LEN-1:0] opcode,
    output logic[`FUNCT3_LEN-1:0] funct3,
    output logic funct7_bit5,

    // Outputs to hazard unit
    output logic[`GPR_ENCODE_BITS-1:0] rs1_decode, rs2_decode, rs1_execute, rs2_execute, rd_execute,
                                       rd_memory, rd_writeback,
    output logic we_gpr_memory, we_gpr_writeback, branch_taken, load_on_execute,

    // Output to instruction memory
    output logic[`XLEN-1:0] pc_fetch,

    // Outputs to data memory
    output logic[`XLEN-1:0] alu_result_memory, write_data_memory,
    output logic we_memory_memory
);
    // Fetch
    logic[`XLEN-1:0] pc_plus_4_fetch;

    // Decode
    logic[`INSTR_LEN-1:0] instr_decode;
    logic[`XLEN-1:0] pc_decode, pc_plus_4_decode, imm_decode, gpr1_value_decode, gpr2_value_decode;
    logic[`GPR_ENCODE_BITS-1:0] rd_decode;

    // Execute
    logic we_gpr_execute, we_memory_execute;
    logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type_execute;
    logic[`ALU_CNTL_BITS_COUNT-1:0] alu_control_execute;
    logic alu_src1_execute, alu_src2_execute;
    logic[`XLEN-1:0] gpr1_value_execute, gpr2_value_execute, pc_execute, imm_execute;
    logic[`XLEN-1:0] pc_plus_imm_execute, pc_plus_4_execute, alu_result_execute;
    logic[`XLEN-1:0] gpr2_value_or_forwarded_value;
    logic[`PC_SRC_BITS_COUNT-1:0] pc_source_execute;
    logic[`RESULT_SRC_BITS_COUNT-1:0] result_src_execute;

    // Memory
    logic[`RESULT_SRC_BITS_COUNT-1:0] result_src_memory;
    logic[`XLEN-1:0] pc_plus_4_memory, pc_plus_imm_memory;

    // Write back
    logic[`RESULT_SRC_BITS_COUNT-1:0] result_src_writeback;
    logic[`XLEN-1:0] alu_result_writeback, read_data_writeback,
                     pc_plus_4_writeback, pc_plus_imm_writeback, result_writeback;

    FetchStage fetch(
        // inputs
        clk, reset, stall_fetch, pc_source_execute, pc_plus_imm_execute, alu_result_execute,
        // outputs
        pc_fetch, pc_plus_4_fetch
    );

    localparam kDecodeRegBits = `INSTR_LEN + 2 * `XLEN;

    EnabledFFWithClear #(/*N = */kDecodeRegBits) decode_reg(
        // inputs
        clk, reset, flush_decode, ~stall_decode,
        {instr_fetch, pc_fetch, pc_plus_4_fetch},
        // outputs
        {instr_decode, pc_decode, pc_plus_4_decode}
    );

    DecodeStage decode(
        // inputs
        clk, instr_decode, imm_type, we_gpr_writeback, rd_writeback, result_writeback,
        // outputs
        opcode, funct3, funct7_bit5, rs1_decode, rs2_decode, rd_decode, imm_decode,
        gpr1_value_decode, gpr2_value_decode
    );

    localparam kExecuteRegBits = 4 + `RESULT_SRC_BITS_COUNT + `BRANCH_TYPE_BITS_COUNT
                                   + `ALU_CNTL_BITS_COUNT + 5 * `XLEN + 3 * `GPR_ENCODE_BITS;

    FFWithClear #(/*N = */kExecuteRegBits) execute_reg(
        // inputs:
        clk, reset, flush_execute,
        {we_gpr, result_src, we_memory, branch_type, alu_control, alu_src1, alu_src2,
         gpr1_value_decode, gpr2_value_decode, pc_decode, rs1_decode, rs2_decode, rd_decode,
         imm_decode, pc_plus_4_decode},
        // outputs
        {we_gpr_execute, result_src_execute, we_memory_execute, branch_type_execute,
         alu_control_execute, alu_src1_execute, alu_src2_execute, gpr1_value_execute,
         gpr2_value_execute, pc_execute, rs1_execute, rs2_execute, rd_execute, imm_execute,
         pc_plus_4_execute}
    );

    assign load_on_execute = (result_src_execute == `RESULT_SRC_MEM);

    ExecuteStage execute(
        // inputs
        gpr1_value_execute, gpr2_value_execute, pc_execute, imm_execute, alu_result_memory,
        result_writeback, forward_rs1, forward_rs2, alu_control_execute, alu_src1_execute,
        alu_src2_execute, branch_type_execute,
        // outputs
        alu_result_execute, pc_plus_imm_execute, gpr2_value_or_forwarded_value, pc_source_execute,
        branch_taken
    );

    localparam kMemoryRegBits = 2 + `RESULT_SRC_BITS_COUNT + 4 * `XLEN + `GPR_ENCODE_BITS;

    FF #(/*N = */kMemoryRegBits) memory_reg(
        // inputs
        clk, reset,
        {we_gpr_execute, result_src_execute, we_memory_execute, alu_result_execute,
         gpr2_value_or_forwarded_value, pc_plus_imm_execute, rd_execute, pc_plus_4_execute},
        // outputs
        {we_gpr_memory, result_src_memory, we_memory_memory, alu_result_memory, write_data_memory,
         pc_plus_imm_memory, rd_memory, pc_plus_4_memory}
    );

    localparam kWriteBackRegBits = 1 + `RESULT_SRC_BITS_COUNT + 4 * `XLEN + `GPR_ENCODE_BITS;

    FF #(/*N = */kWriteBackRegBits) writeback_reg(
        // inputs
        clk, reset,
        {we_gpr_memory, result_src_memory, alu_result_memory, read_data, rd_memory,
         pc_plus_4_memory, pc_plus_imm_memory},
        // outputs
        {we_gpr_writeback, result_src_writeback, alu_result_writeback, read_data_writeback,
         rd_writeback, pc_plus_4_writeback, pc_plus_imm_writeback}
    );

    WriteBackStage write_back(
        // inputs
        alu_result_writeback, read_data_writeback, pc_plus_4_writeback, pc_plus_imm_writeback,
        result_src_writeback,
        // output
        result_writeback
    );
endmodule

`include "constants.sv"

module Hart(
    input logic clk, reset,

    // Inputs from instruction memory
    input logic[`INSTR_LEN-1:0] instr_fetch,

    // Input from memory
    input logic[`XLEN-1:0] read_data,

    // Outputs to instruction memory
    output logic[`XLEN-1:0] pc_fetch,

    // Outputs to data memory
    output logic[`XLEN-1:0] addr_memory, write_data_memory,
    output logic we_memory_memory
);
    // Hazard unit
    logic[`GPR_ENCODE_BITS-1:0] rs1_decode, rs2_decode, rs1_execute, rs2_execute;
    logic[`GPR_ENCODE_BITS-1:0] rd_execute, rd_memory, rd_writeback;
    logic branch_taken, load_on_execute;
    logic we_gpr_memory, we_gpr_writeback;
    logic[`FORWARD_SRC_BITS_COUNT-1:0] forward_rs1, forward_rs2;
    logic stall_fetch, stall_decode, flush_decode, flush_execute;

    // Control unit
    logic[`OPCODE_LEN-1:0] opcode;
    logic[`FUNCT3_LEN-1:0] funct3;
    logic funct7_bit5;
    logic we_gpr, we_memory, alu_src1, alu_src2;
    logic[`RESULT_SRC_BITS_COUNT-1:0] result_src;
    logic[`ALU_CNTL_BITS_COUNT-1:0] alu_control;
    logic[`IMM_TYPE_BITS_COUNT-1:0] imm_type;
    logic[`BRANCH_TYPE_BITS_COUNT-1:0] branch_type;

    HazardUnit hazard_unit(
        // inputs
        rs1_decode, rs2_decode, rs1_execute, rs2_execute, rd_execute, rd_memory, rd_writeback,
        branch_taken, load_on_execute, we_gpr_memory, we_gpr_writeback,
        // outputs
        forward_rs1, forward_rs2, stall_fetch, stall_decode, flush_decode, flush_execute
    );

    ControlUnit control_unit(
        // inputs
        opcode, funct3, funct7_bit5,
        // outputs
        result_src, we_memory, alu_src1, alu_src2, alu_control, we_gpr, imm_type, branch_type
    );

    DataPath data_path(
        // inputs
        clk, reset,

        instr_fetch,

        we_gpr, result_src, we_memory, branch_type, alu_control, alu_src1, alu_src2, imm_type,

        stall_fetch, stall_decode, flush_decode, flush_execute, forward_rs1, forward_rs2,

        read_data,

        // outputs
        opcode, funct3, funct7_bit5,

        rs1_decode, rs2_decode, rs1_execute, rs2_execute, rd_execute, rd_memory, rd_writeback,
        we_gpr_memory, we_gpr_writeback, branch_taken, load_on_execute,

        pc_fetch,

        addr_memory, write_data_memory, we_memory_memory
    );
endmodule

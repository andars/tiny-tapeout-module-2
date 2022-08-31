`default_nettype none

module alu_PROJECT_ID(
    input [3:0] regval,
    input [3:0] acc,
    input [3:0] data,
    input carry,
    input [2:0] alu_op,
    input [2:0] alu_in0_sel,
    input [1:0] alu_in1_sel,
    input [1:0] alu_cin_sel,
    output [4:0] result
);

`include "datapath.vh"

wire [3:0] alu_in0;
wire [3:0] alu_in1;
wire alu_cin;

reg [3:0] lg2_plus_1;
reg [4:0] dec_adjust;

assign alu_in0 = (alu_in0_sel == ALU_IN0_ACC) ? acc
               : (alu_in0_sel == ALU_IN0_ACC_INV) ? ~acc
               : (alu_in0_sel == ALU_IN0_REG) ? regval
               : (alu_in0_sel == ALU_IN0_REG_INV) ? ~regval
               : (alu_in0_sel == ALU_IN0_DATA) ? data
               : (alu_in0_sel == ALU_IN0_DATA_INV) ? ~data
               : 4'bx;

assign alu_in1 = (alu_in1_sel == ALU_IN1_ACC) ? acc
               : (alu_in1_sel == ALU_IN1_REG) ? regval
               : (alu_in1_sel == ALU_IN1_ONE) ? 4'b1
               : (alu_in1_sel == ALU_IN1_ONE_INV) ? 4'b1110
               : 4'bx;

assign alu_cin = (alu_cin_sel == ALU_CIN_ZERO) ? 1'b0
               : (alu_cin_sel == ALU_CIN_ONE) ? 1'b1
               : (alu_cin_sel == ALU_CIN_CARRY) ? carry
               : (alu_cin_sel == ALU_CIN_CARRY_INV) ? ~carry
               : 1'bx;

assign result = (alu_op == ALU_OP_ADD)   ? (alu_in0 + alu_in1 + {4'b0, alu_cin})
              : (alu_op == ALU_OP_ROL)   ? {alu_in0[3:0], alu_cin}
              : (alu_op == ALU_OP_ROR)   ? {alu_in0[0], alu_cin, alu_in0[3:1]}
              : (alu_op == ALU_OP_PASS)  ? {alu_cin, alu_in0}
              : (alu_op == ALU_OP_DEC_A) ? dec_adjust
              : (alu_op == ALU_OP_LG2_1) ? {1'b0, lg2_plus_1}
              : 5'bx;

// decimal adjust lookup is removed
always @(*) begin
    dec_adjust = 0;
end

// lookup for log2 + 1 is removed
always @(*) begin
    lg2_plus_1 = 4'h0;
end

endmodule

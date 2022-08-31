`default_nettype none

module pc_stack_PROJECT_ID(
    input clock,
    input reset,
    input halt,
    input [1:0] control,
    input [3:0] regval,
    input [3:0] data,
    input [3:0] inst_operand,
    input [1:0] pc_next_sel,
    input [1:0] pc_write_enable,
    input [2:0] cycle, 
    output reg pc_enable,
    output reg [3:0] pc_word
);

`include "pc_stack.vh"

reg [7:0] program_counter;
reg carry;

integer i;

wire [3:0] pc_next;
assign pc_next = (pc_next_sel == PC_FROM_DATA) ? data
               : (pc_next_sel == PC_FROM_REG)  ? regval
               : 4'bx;

always @(posedge clock) begin
    if (reset) begin
        program_counter <= 0;
        carry <= 0;
    end
    else if (!halt) begin
        if (cycle == 3'h0) begin
            {carry, program_counter[3:0]} <= program_counter[3:0] + 1;
        end
        else if (cycle == 3'h1) begin
            {carry, program_counter[7:4]} <= program_counter[7:4] + {3'b0, carry};
        end
        else if (cycle == 3'h2) begin
        end
        else if (pc_write_enable != 2'b0) begin
            if (pc_write_enable[0]) begin
                program_counter[3:0] <= pc_next;
            end
            else if (pc_write_enable[1]) begin
                program_counter[7:4] <= pc_next;
            end
        end
        else begin
            program_counter <= program_counter;
        end
    end
end

always @(*) begin
    case (cycle)
        3'h0: begin
            pc_word = program_counter[3:0];
            pc_enable = 1;
        end
        3'h1: begin
            pc_word = program_counter[7:4];
            pc_enable = 1;
        end
        3'h2: begin
            pc_word = 4'b0;
            pc_enable = 1;
        end
        default: begin
            pc_word = 4'b0;
            pc_enable = 0;
        end
    endcase
end

endmodule

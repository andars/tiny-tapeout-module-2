`default_nettype none

module user_module_PROJECT_ID(
  input [7:0] io_in,
  output [7:0] io_out
);

wire clock;
assign clock = io_in[0];

wire reset;
assign reset = io_in[1];

wire [3:0] data_in;
assign data_in = io_in[5:2];

wire test;
assign test = io_in[6];

wire [3:0] data_out;
assign io_out[3:0] = data_out;

wire data_en;
assign io_out[4] = data_en;

wire sync;
assign io_out[5] = sync;

wire rom_cmd;
assign io_out[6] = rom_cmd;

wire ram_cmd_n;
assign io_out[7] = ram_cmd_n;

cpu_PROJECT_ID cpu(
    .clock(clock),
    .reset(reset),
    .halt(1'b0),
    .data_i(data_in),
    .data_o(data_out),
    .data_en(data_en),
    .test(test),
    .sync(sync),
    .rom_cmd(rom_cmd),
    .ram_cmd_n(ram_cmd_n)
);

endmodule

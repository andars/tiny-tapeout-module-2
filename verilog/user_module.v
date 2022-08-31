`default_nettype none

module user_module_PROJECT_ID(
  input [7:0] io_in,
  output [7:0] io_out
);

// TODO
assign io_out[7] = io_in[7] & io_in[6];
assign io_out[6] = io_in[5] ^ io_in[4];
assign io_out[5] = io_in[3] | io_in[2];

endmodule

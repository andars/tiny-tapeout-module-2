`default_nettype none

module test_system(
    input clock,
    input reset,
    input test,
    input [3:0] rom_1_io,
    input [3:0] rom_2_io
);

wire [3:0] data;
wire sync;
wire rom_cmd;
wire ram_cmd_n;
wire [3:0] rom_3_io;
wire [3:0] rom_4_io;
wire [3:0] rom_5_io;
wire [3:0] ram_out;

wire halt;
assign halt = 1'b0;

assign data = cpu_data_en ? cpu_data_o
            : rom_1_data_en ? rom_1_data_o
            : rom_2_data_en ? rom_2_data_o
            : rom_3_data_en ? rom_3_data_o
            : rom_4_data_en ? rom_4_data_o
            : rom_5_data_en ? rom_5_data_o
            : ram_1_data_en ? ram_1_data_o
            : ram_2_data_en ? ram_2_data_o
            : 4'h0;

wire [3:0] cpu_data_o;
wire cpu_data_en;

wire [3:0] rom_1_data_o;
wire [3:0] rom_2_data_o;
wire [3:0] rom_3_data_o;
wire [3:0] rom_4_data_o;
wire [3:0] rom_5_data_o;
wire rom_1_data_en, rom_2_data_en, rom_3_data_en, rom_4_data_en, rom_5_data_en;

wire [3:0] ram_1_data_o;
wire ram_1_data_en;
wire [3:0] ram_2_data_o;
wire ram_2_data_en;

cpu_PROJECT_ID cpu(
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(cpu_data_o),
    .data_en(cpu_data_en),
    .test(test),
    .sync(sync),
    .rom_cmd(rom_cmd),
    .ram_cmd_n(ram_cmd_n)
);

test_rom #(.CHIP_ID(4'h0), .ROM_FILE("rom_0.hex")) rom_1 (
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(rom_1_data_o),
    .data_en(rom_1_data_en),
    .sync(sync),
    .cmd(rom_cmd),
    .in(rom_1_io),

    // unconnected backdoor
    .wb_data_i(32'h0),
    .wb_addr_i(32'h0),
    .wb_cyc_i(1'h0),
    .wb_strobe_i(1'h0),
    .wb_we_i(1'h0),
    .wb_data_o(),
    .wb_ack_o()
);

test_rom #(.CHIP_ID(4'h1), .ROM_FILE("rom_1.hex")) rom_2 (
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(rom_2_data_o),
    .data_en(rom_2_data_en),
    .sync(sync),
    .cmd(rom_cmd),
    .in(rom_2_io),

    // unconnected backdoor
    .wb_data_i(32'h0),
    .wb_addr_i(32'h0),
    .wb_cyc_i(1'h0),
    .wb_strobe_i(1'h0),
    .wb_we_i(1'h0),
    .wb_data_o(),
    .wb_ack_o()
);

test_rom #(.CHIP_ID(4'h2), .ROM_FILE("rom_2.hex")) rom_3 (
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(rom_3_data_o),
    .data_en(rom_3_data_en),
    .sync(sync),
    .cmd(rom_cmd),
    .in(rom_3_io),

    // unconnected backdoor
    .wb_data_i(32'h0),
    .wb_addr_i(32'h0),
    .wb_cyc_i(1'h0),
    .wb_strobe_i(1'h0),
    .wb_we_i(1'h0),
    .wb_data_o(),
    .wb_ack_o()
);

test_rom #(.CHIP_ID(4'h3), .ROM_FILE("rom_3.hex")) rom_4 (
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(rom_4_data_o),
    .data_en(rom_4_data_en),
    .sync(sync),
    .cmd(rom_cmd),
    .in(rom_4_io),

    // unconnected backdoor
    .wb_data_i(32'h0),
    .wb_addr_i(32'h0),
    .wb_cyc_i(1'h0),
    .wb_strobe_i(1'h0),
    .wb_we_i(1'h0),
    .wb_data_o(),
    .wb_ack_o()
);

test_rom #(.CHIP_ID(4'h4), .ROM_FILE("rom_4.hex")) rom_5 (
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(rom_5_data_o),
    .data_en(rom_5_data_en),
    .sync(sync),
    .cmd(rom_cmd),
    .in(rom_5_io),

    // unconnected backdoor
    .wb_data_i(32'h0),
    .wb_addr_i(32'h0),
    .wb_cyc_i(1'h0),
    .wb_strobe_i(1'h0),
    .wb_we_i(1'h0),
    .wb_data_o(),
    .wb_ack_o()
);

test_ram ram_1(
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(ram_1_data_o),
    .data_en(ram_1_data_en),
    .sync(sync),
    .cmd_n(ram_cmd_n),
    .out(ram_out),
    .p0(1'b0),

    // unconnected backdoor
    .wb_data_i(32'h0),
    .wb_addr_i(32'h0),
    .wb_cyc_i(1'h0),
    .wb_strobe_i(1'h0),
    .wb_we_i(1'h0),
    .wb_data_o(),
    .wb_ack_o()
);

test_ram ram_2(
    .clock(clock),
    .reset(reset),
    .halt(halt),
    .data_i(data),
    .data_o(ram_2_data_o),
    .data_en(ram_2_data_en),
    .sync(sync),
    .cmd_n(ram_cmd_n),
    .out(ram_out),
    .p0(1'b1),

    // unconnected backdoor
    .wb_data_i(32'h0),
    .wb_addr_i(32'h0),
    .wb_cyc_i(1'h0),
    .wb_strobe_i(1'h0),
    .wb_we_i(1'h0),
    .wb_data_o(),
    .wb_ack_o()
);

endmodule

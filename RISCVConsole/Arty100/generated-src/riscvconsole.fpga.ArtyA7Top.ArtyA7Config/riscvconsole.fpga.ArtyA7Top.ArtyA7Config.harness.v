module NonSyncResetSynchronizerPrimitiveShiftReg_d3_inArtyA7Top(
  input   clock,
  input   io_d,
  output  io_q
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg  sync_0; // @[SynchronizerReg.scala 51:66]
  reg  sync_1; // @[SynchronizerReg.scala 51:66]
  reg  sync_2; // @[SynchronizerReg.scala 51:66]
  assign io_q = sync_0; // @[SynchronizerReg.scala 59:8]
  always @(posedge clock) begin
    sync_0 <= sync_1; // @[SynchronizerReg.scala 57:10]
    sync_1 <= sync_2; // @[SynchronizerReg.scala 57:10]
    sync_2 <= io_d; // @[SynchronizerReg.scala 54:22]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  sync_0 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  sync_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  sync_2 = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SynchronizerShiftReg_w1_d3_inArtyA7Top(
  input   clock,
  input   io_d,
  output  io_q
);
  wire  output_chain_clock; // @[ShiftReg.scala 45:23]
  wire  output_chain_io_d; // @[ShiftReg.scala 45:23]
  wire  output_chain_io_q; // @[ShiftReg.scala 45:23]
  NonSyncResetSynchronizerPrimitiveShiftReg_d3_inArtyA7Top output_chain ( // @[ShiftReg.scala 45:23]
    .clock(output_chain_clock),
    .io_d(output_chain_io_d),
    .io_q(output_chain_io_q)
  );
  assign io_q = output_chain_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign output_chain_clock = clock;
  assign output_chain_io_d = io_d; // @[SynchronizerReg.scala 173:39]
endmodule
module AsyncResetSynchronizerPrimitiveShiftReg_d3_i0_inArtyA7Top(
  input   clock,
  input   reset,
  output  io_q
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg  sync_0; // @[SynchronizerReg.scala 51:87]
  reg  sync_1; // @[SynchronizerReg.scala 51:87]
  reg  sync_2; // @[SynchronizerReg.scala 51:87]
  assign io_q = sync_0; // @[SynchronizerReg.scala 59:8]
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[SynchronizerReg.scala 51:87]
      sync_0 <= 1'h0; // @[SynchronizerReg.scala 51:87]
    end else begin
      sync_0 <= sync_1; // @[SynchronizerReg.scala 57:10]
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[SynchronizerReg.scala 51:87]
      sync_1 <= 1'h0; // @[SynchronizerReg.scala 51:87]
    end else begin
      sync_1 <= sync_2; // @[SynchronizerReg.scala 57:10]
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[SynchronizerReg.scala 54:22]
      sync_2 <= 1'h0;
    end else begin
      sync_2 <= 1'h1;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  sync_0 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  sync_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  sync_2 = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  if (reset) begin
    sync_0 = 1'h0;
  end
  if (reset) begin
    sync_1 = 1'h0;
  end
  if (reset) begin
    sync_2 = 1'h0;
  end
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AsyncResetSynchronizerShiftReg_w1_d3_i0_inArtyA7Top(
  input   clock,
  input   reset,
  output  io_q
);
  wire  output_chain_clock; // @[ShiftReg.scala 45:23]
  wire  output_chain_reset; // @[ShiftReg.scala 45:23]
  wire  output_chain_io_q; // @[ShiftReg.scala 45:23]
  AsyncResetSynchronizerPrimitiveShiftReg_d3_i0_inArtyA7Top output_chain ( // @[ShiftReg.scala 45:23]
    .clock(output_chain_clock),
    .reset(output_chain_reset),
    .io_q(output_chain_io_q)
  );
  assign io_q = output_chain_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign output_chain_clock = clock;
  assign output_chain_reset = reset; // @[SynchronizerReg.scala 86:21]
endmodule
module SyncResetSynchronizerPrimitiveShiftReg_d3_i1_inArtyA7Top(
  input   clock,
  input   reset,
  input   io_d,
  output  io_q
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg  sync_0; // @[SynchronizerReg.scala 51:87]
  reg  sync_1; // @[SynchronizerReg.scala 51:87]
  reg  sync_2; // @[SynchronizerReg.scala 51:87]
  assign io_q = sync_0; // @[SynchronizerReg.scala 59:8]
  always @(posedge clock) begin
    sync_0 <= reset | sync_1; // @[SynchronizerReg.scala 51:{87,87} 57:10]
    sync_1 <= reset | sync_2; // @[SynchronizerReg.scala 51:{87,87} 57:10]
    sync_2 <= reset | io_d; // @[SynchronizerReg.scala 51:{87,87} 54:14]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  sync_0 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  sync_1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  sync_2 = _RAND_2[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SyncResetSynchronizerShiftReg_w1_d3_i1_inArtyA7Top(
  input   clock,
  input   reset,
  input   io_d,
  output  io_q
);
  wire  output_chain_clock; // @[ShiftReg.scala 45:23]
  wire  output_chain_reset; // @[ShiftReg.scala 45:23]
  wire  output_chain_io_d; // @[ShiftReg.scala 45:23]
  wire  output_chain_io_q; // @[ShiftReg.scala 45:23]
  SyncResetSynchronizerPrimitiveShiftReg_d3_i1_inArtyA7Top output_chain ( // @[ShiftReg.scala 45:23]
    .clock(output_chain_clock),
    .reset(output_chain_reset),
    .io_d(output_chain_io_d),
    .io_q(output_chain_io_q)
  );
  assign io_q = output_chain_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign output_chain_clock = clock;
  assign output_chain_reset = reset; // @[SynchronizerReg.scala 118:21]
  assign output_chain_io_d = io_d; // @[SynchronizerReg.scala 119:41]
endmodule
module ResetCatchAndSync_d3_inArtyA7Top(
  input   clock,
  input   reset,
  output  io_sync_reset
);
  wire  io_sync_reset_chain_clock; // @[ShiftReg.scala 45:23]
  wire  io_sync_reset_chain_reset; // @[ShiftReg.scala 45:23]
  wire  io_sync_reset_chain_io_q; // @[ShiftReg.scala 45:23]
  wire  _io_sync_reset_WIRE = io_sync_reset_chain_io_q; // @[ShiftReg.scala 48:{24,24}]
  AsyncResetSynchronizerShiftReg_w1_d3_i0_inArtyA7Top io_sync_reset_chain ( // @[ShiftReg.scala 45:23]
    .clock(io_sync_reset_chain_clock),
    .reset(io_sync_reset_chain_reset),
    .io_q(io_sync_reset_chain_io_q)
  );
  assign io_sync_reset = ~_io_sync_reset_WIRE; // @[ResetCatchAndSync.scala 29:7]
  assign io_sync_reset_chain_clock = clock;
  assign io_sync_reset_chain_reset = reset; // @[ResetCatchAndSync.scala 26:27]
endmodule
module ArtyA7Top(
  input         CLK100MHZ,
  input         ck_rst,
  inout         led_0,
  inout         led_1,
  inout         led_2,
  inout         led_3,
  inout         led0_r,
  inout         led0_g,
  inout         led0_b,
  inout         led1_r,
  inout         led1_g,
  inout         led1_b,
  inout         led2_r,
  inout         led2_g,
  inout         led2_b,
  inout         sw_0,
  inout         sw_1,
  inout         sw_2,
  inout         sw_3,
  inout         btn_0,
  inout         btn_1,
  inout         btn_2,
  inout         btn_3,
  inout         qspi_cs,
  inout         qspi_sck,
  inout         qspi_dq_0,
  inout         qspi_dq_1,
  inout         qspi_dq_2,
  inout         qspi_dq_3,
  inout         uart_rxd_out,
  inout         uart_txd_in,
  inout         ja_0,
  inout         ja_1,
  inout         ja_2,
  inout         ja_3,
  inout         ja_4,
  inout         ja_5,
  inout         ja_6,
  inout         ja_7,
  inout         jb_0,
  inout         jb_1,
  inout         jb_2,
  inout         jb_3,
  inout         jb_4,
  inout         jb_5,
  inout         jb_6,
  inout         jb_7,
  inout         jc_0,
  inout         jc_1,
  inout         jc_2,
  inout         jc_3,
  inout         jc_4,
  inout         jc_5,
  inout         jc_6,
  inout         jc_7,
  inout         jd_0,
  inout         jd_1,
  inout         jd_2,
  inout         jd_3,
  inout         jd_4,
  inout         jd_5,
  inout         jd_6,
  inout         jd_7,
  inout         ck_io_0,
  inout         ck_io_1,
  inout         ck_io_2,
  inout         ck_io_3,
  inout         ck_io_4,
  inout         ck_io_5,
  inout         ck_io_6,
  inout         ck_io_7,
  inout         ck_io_8,
  inout         ck_io_9,
  inout         ck_io_10,
  inout         ck_io_11,
  inout         ck_io_12,
  inout         ck_io_13,
  inout         ck_io_14,
  inout         ck_io_15,
  inout         ck_io_16,
  inout         ck_io_17,
  inout         ck_io_18,
  inout         ck_io_19,
  inout         ck_miso,
  inout         ck_mosi,
  inout         ck_ss,
  inout         ck_sck,
  output [13:0] ddr_ddr3_addr,
  output [2:0]  ddr_ddr3_ba,
  output        ddr_ddr3_ras_n,
  output        ddr_ddr3_cas_n,
  output        ddr_ddr3_we_n,
  output        ddr_ddr3_reset_n,
  output        ddr_ddr3_ck_p,
  output        ddr_ddr3_ck_n,
  output        ddr_ddr3_cke,
  output        ddr_ddr3_cs_n,
  output [1:0]  ddr_ddr3_dm,
  output        ddr_ddr3_odt,
  inout  [15:0] ddr_ddr3_dq,
  inout  [1:0]  ddr_ddr3_dqs_n,
  inout  [1:0]  ddr_ddr3_dqs_p
);
  wire  pll_clk_in1; // @[artya7.scala 34:19]
  wire  pll_clk_out1; // @[artya7.scala 34:19]
  wire  pll_clk_out2; // @[artya7.scala 34:19]
  wire  pll_clk_out3; // @[artya7.scala 34:19]
  wire  pll_reset; // @[artya7.scala 34:19]
  wire  pll_locked; // @[artya7.scala 34:19]
  wire  platform_clock; // @[artya7.scala 44:45]
  wire  platform_reset; // @[artya7.scala 44:45]
  wire  platform_ndreset; // @[artya7.scala 44:45]
  wire  platform_jtag_TRSTn; // @[artya7.scala 44:45]
  wire  platform_jtag_TCK; // @[artya7.scala 44:45]
  wire  platform_jtag_TMS; // @[artya7.scala 44:45]
  wire  platform_jtag_TDI; // @[artya7.scala 44:45]
  wire  platform_jtag_TDO_data; // @[artya7.scala 44:45]
  wire  platform_jtag_TDO_driven; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_0_o_poe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_1_o_poe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_2_o_poe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_3_o_poe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_4_o_poe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_5_o_poe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_6_o_poe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_i_ival; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_i_po; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_oval; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_oe; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_ie; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_pue; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_ds; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_ps; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_ds1; // @[artya7.scala 44:45]
  wire  platform_gpio_0_pins_7_o_poe; // @[artya7.scala 44:45]
  wire  platform_uart_0_txd; // @[artya7.scala 44:45]
  wire  platform_uart_0_rxd; // @[artya7.scala 44:45]
  wire  platform_i2c_0_scl_in; // @[artya7.scala 44:45]
  wire  platform_i2c_0_scl_out; // @[artya7.scala 44:45]
  wire  platform_i2c_0_scl_oe; // @[artya7.scala 44:45]
  wire  platform_i2c_0_sda_in; // @[artya7.scala 44:45]
  wire  platform_i2c_0_sda_out; // @[artya7.scala 44:45]
  wire  platform_i2c_0_sda_oe; // @[artya7.scala 44:45]
  wire [13:0] platform_artyA7MIGPorts_0_ddr3_addr; // @[artya7.scala 44:45]
  wire [2:0] platform_artyA7MIGPorts_0_ddr3_ba; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_ras_n; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_cas_n; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_we_n; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_reset_n; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_ck_p; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_ck_n; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_cke; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_cs_n; // @[artya7.scala 44:45]
  wire [1:0] platform_artyA7MIGPorts_0_ddr3_dm; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ddr3_odt; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_sys_clk_i; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_clk_ref_i; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ui_clk; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_ui_clk_sync_rst; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_mmcm_locked; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_aresetn; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_init_calib_complete; // @[artya7.scala 44:45]
  wire  platform_artyA7MIGPorts_0_sys_rst; // @[artya7.scala 44:45]
  wire  platform_spi_0_sck; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_0_i; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_0_o; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_0_ie; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_0_oe; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_1_i; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_1_o; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_1_ie; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_1_oe; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_2_i; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_2_o; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_2_ie; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_2_oe; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_3_i; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_3_o; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_3_ie; // @[artya7.scala 44:45]
  wire  platform_spi_0_dq_3_oe; // @[artya7.scala 44:45]
  wire  platform_spi_0_cs_0; // @[artya7.scala 44:45]
  wire  platform_otherclock; // @[artya7.scala 44:45]
  wire  pad_O; // @[Unisim.scala 271:23]
  wire  pad_I; // @[Unisim.scala 271:23]
  wire  pad_T; // @[Unisim.scala 271:23]
  wire  pad_1_O; // @[Unisim.scala 271:23]
  wire  pad_1_I; // @[Unisim.scala 271:23]
  wire  pad_1_T; // @[Unisim.scala 271:23]
  wire  pad_2_O; // @[Unisim.scala 271:23]
  wire  pad_2_I; // @[Unisim.scala 271:23]
  wire  pad_2_T; // @[Unisim.scala 271:23]
  wire  pad_3_O; // @[Unisim.scala 271:23]
  wire  pad_3_I; // @[Unisim.scala 271:23]
  wire  pad_3_T; // @[Unisim.scala 271:23]
  wire  pad_4_O; // @[Unisim.scala 271:23]
  wire  pad_4_I; // @[Unisim.scala 271:23]
  wire  pad_4_T; // @[Unisim.scala 271:23]
  wire  pad_5_O; // @[Unisim.scala 271:23]
  wire  pad_5_I; // @[Unisim.scala 271:23]
  wire  pad_5_T; // @[Unisim.scala 271:23]
  wire  pad_6_O; // @[Unisim.scala 271:23]
  wire  pad_6_I; // @[Unisim.scala 271:23]
  wire  pad_6_T; // @[Unisim.scala 271:23]
  wire  pad_7_O; // @[Unisim.scala 271:23]
  wire  pad_7_I; // @[Unisim.scala 271:23]
  wire  pad_7_T; // @[Unisim.scala 271:23]
  wire  platform_jtag_TDI_pad_O; // @[Unisim.scala 289:21]
  wire  platform_jtag_TDI_pad_I; // @[Unisim.scala 289:21]
  wire  platform_jtag_TDI_pad_T; // @[Unisim.scala 289:21]
  wire  platform_jtag_TMS_pad_O; // @[Unisim.scala 289:21]
  wire  platform_jtag_TMS_pad_I; // @[Unisim.scala 289:21]
  wire  platform_jtag_TMS_pad_T; // @[Unisim.scala 289:21]
  wire  platform_jtag_TCK_pad_O; // @[Unisim.scala 289:21]
  wire  platform_jtag_TCK_pad_I; // @[Unisim.scala 289:21]
  wire  platform_jtag_TCK_pad_T; // @[Unisim.scala 289:21]
  wire  pad_8_O; // @[Unisim.scala 271:23]
  wire  pad_8_I; // @[Unisim.scala 271:23]
  wire  pad_8_T; // @[Unisim.scala 271:23]
  wire  platform_jtag_TRSTn_pad_O; // @[Unisim.scala 289:21]
  wire  platform_jtag_TRSTn_pad_I; // @[Unisim.scala 289:21]
  wire  platform_jtag_TRSTn_pad_T; // @[Unisim.scala 289:21]
  wire  platform_uart_0_rxd_pad_O; // @[Unisim.scala 289:21]
  wire  platform_uart_0_rxd_pad_I; // @[Unisim.scala 289:21]
  wire  platform_uart_0_rxd_pad_T; // @[Unisim.scala 289:21]
  wire  pad_9_O; // @[Unisim.scala 281:21]
  wire  pad_9_I; // @[Unisim.scala 281:21]
  wire  pad_9_T; // @[Unisim.scala 281:21]
  wire  platform_spi_0_dq_0_i_spi_dq_0_sync_clock; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_0_i_spi_dq_0_sync_io_d; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_0_i_spi_dq_0_sync_io_q; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_1_i_spi_dq_1_sync_clock; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_1_i_spi_dq_1_sync_io_d; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_1_i_spi_dq_1_sync_io_q; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_2_i_spi_dq_2_sync_clock; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_2_i_spi_dq_2_sync_io_d; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_2_i_spi_dq_2_sync_io_q; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_3_i_spi_dq_3_sync_clock; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_3_i_spi_dq_3_sync_io_d; // @[ShiftReg.scala 45:23]
  wire  platform_spi_0_dq_3_i_spi_dq_3_sync_io_q; // @[ShiftReg.scala 45:23]
  wire  pad_10_O; // @[Unisim.scala 271:23]
  wire  pad_10_I; // @[Unisim.scala 271:23]
  wire  pad_10_T; // @[Unisim.scala 271:23]
  wire  pad_11_O; // @[Unisim.scala 271:23]
  wire  pad_11_I; // @[Unisim.scala 271:23]
  wire  pad_11_T; // @[Unisim.scala 271:23]
  wire  pad_12_O; // @[Unisim.scala 271:23]
  wire  pad_12_I; // @[Unisim.scala 271:23]
  wire  pad_12_T; // @[Unisim.scala 271:23]
  wire  pad_13_O; // @[Unisim.scala 271:23]
  wire  pad_13_I; // @[Unisim.scala 271:23]
  wire  pad_13_T; // @[Unisim.scala 271:23]
  wire  pad_14_O; // @[Unisim.scala 271:23]
  wire  pad_14_I; // @[Unisim.scala 271:23]
  wire  pad_14_T; // @[Unisim.scala 271:23]
  wire  pad_15_O; // @[Unisim.scala 271:23]
  wire  pad_15_I; // @[Unisim.scala 271:23]
  wire  pad_15_T; // @[Unisim.scala 271:23]
  wire  platform_i2c_0_scl_in_i2c_scl_sync_clock; // @[ShiftReg.scala 45:23]
  wire  platform_i2c_0_scl_in_i2c_scl_sync_reset; // @[ShiftReg.scala 45:23]
  wire  platform_i2c_0_scl_in_i2c_scl_sync_io_d; // @[ShiftReg.scala 45:23]
  wire  platform_i2c_0_scl_in_i2c_scl_sync_io_q; // @[ShiftReg.scala 45:23]
  wire  platform_i2c_0_sda_in_i2c_sda_sync_clock; // @[ShiftReg.scala 45:23]
  wire  platform_i2c_0_sda_in_i2c_sda_sync_reset; // @[ShiftReg.scala 45:23]
  wire  platform_i2c_0_sda_in_i2c_sda_sync_io_d; // @[ShiftReg.scala 45:23]
  wire  platform_i2c_0_sda_in_i2c_sda_sync_io_q; // @[ShiftReg.scala 45:23]
  wire  pad_16_O; // @[Unisim.scala 271:23]
  wire  pad_16_I; // @[Unisim.scala 271:23]
  wire  pad_16_T; // @[Unisim.scala 271:23]
  wire  pad_17_O; // @[Unisim.scala 271:23]
  wire  pad_17_I; // @[Unisim.scala 271:23]
  wire  pad_17_T; // @[Unisim.scala 271:23]
  wire  platform_artyA7MIGPorts_0_sys_rst_catcher_clock; // @[ResetCatchAndSync.scala 39:28]
  wire  platform_artyA7MIGPorts_0_sys_rst_catcher_reset; // @[ResetCatchAndSync.scala 39:28]
  wire  platform_artyA7MIGPorts_0_sys_rst_catcher_io_sync_reset; // @[ResetCatchAndSync.scala 39:28]
  wire  reset_catcher_clock; // @[ResetCatchAndSync.scala 39:28]
  wire  reset_catcher_reset; // @[ResetCatchAndSync.scala 39:28]
  wire  reset_catcher_io_sync_reset; // @[ResetCatchAndSync.scala 39:28]
  wire  reset = reset_catcher_io_sync_reset;
  wire  base_pin_o_oe = platform_gpio_0_pins_0_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_o_ie = platform_gpio_0_pins_0_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_1_o_oe = platform_gpio_0_pins_1_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_1_o_ie = platform_gpio_0_pins_1_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_2_o_oe = platform_gpio_0_pins_2_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_2_o_ie = platform_gpio_0_pins_2_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_3_o_oe = platform_gpio_0_pins_3_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_3_o_ie = platform_gpio_0_pins_3_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_4_o_oe = platform_gpio_0_pins_4_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_4_o_ie = platform_gpio_0_pins_4_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_5_o_oe = platform_gpio_0_pins_5_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_5_o_ie = platform_gpio_0_pins_5_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_6_o_oe = platform_gpio_0_pins_6_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_6_o_ie = platform_gpio_0_pins_6_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_7_o_oe = platform_gpio_0_pins_7_o_oe; // @[PinCtrl.scala 119:24 120:14]
  wire  base_pin_7_o_ie = platform_gpio_0_pins_7_o_ie; // @[PinCtrl.scala 119:24 120:14]
  wire  TDO_as_base_o_oe = platform_jtag_TDO_driven; // @[artya7.scala 62:29 63:24]
  wire  spi_dq_0_o_ie = ~platform_spi_0_dq_0_oe; // @[SPIPins.scala 30:19]
  wire  spi_dq_1_o_ie = ~platform_spi_0_dq_1_oe; // @[SPIPins.scala 30:19]
  wire  spi_dq_2_o_ie = ~platform_spi_0_dq_2_oe; // @[SPIPins.scala 30:19]
  wire  spi_dq_3_o_ie = ~platform_spi_0_dq_3_oe; // @[SPIPins.scala 30:19]
  wire  spi_dq_0_o_oe = platform_spi_0_dq_0_oe; // @[SPIPins.scala 29:16 artya7.scala 82:21]
  wire  spi_dq_1_o_oe = platform_spi_0_dq_1_oe; // @[SPIPins.scala 29:16 artya7.scala 82:21]
  wire  spi_dq_2_o_oe = platform_spi_0_dq_2_oe; // @[SPIPins.scala 29:16 artya7.scala 82:21]
  wire  spi_dq_3_o_oe = platform_spi_0_dq_3_oe; // @[SPIPins.scala 29:16 artya7.scala 82:21]
  wire  i2c_scl_o_oe = platform_i2c_0_scl_oe; // @[artya7.scala 115:21 I2CPins.scala 22:21]
  wire  i2c_sda_o_oe = platform_i2c_0_sda_oe; // @[artya7.scala 115:21 I2CPins.scala 27:21]
  pll pll ( // @[artya7.scala 34:19]
    .clk_in1(pll_clk_in1),
    .clk_out1(pll_clk_out1),
    .clk_out2(pll_clk_out2),
    .clk_out3(pll_clk_out3),
    .reset(pll_reset),
    .locked(pll_locked)
  );
  RVCSystem platform ( // @[artya7.scala 44:45]
    .clock(platform_clock),
    .reset(platform_reset),
    .ndreset(platform_ndreset),
    .jtag_TRSTn(platform_jtag_TRSTn),
    .jtag_TCK(platform_jtag_TCK),
    .jtag_TMS(platform_jtag_TMS),
    .jtag_TDI(platform_jtag_TDI),
    .jtag_TDO_data(platform_jtag_TDO_data),
    .jtag_TDO_driven(platform_jtag_TDO_driven),
    .gpio_0_pins_0_i_ival(platform_gpio_0_pins_0_i_ival),
    .gpio_0_pins_0_i_po(platform_gpio_0_pins_0_i_po),
    .gpio_0_pins_0_o_oval(platform_gpio_0_pins_0_o_oval),
    .gpio_0_pins_0_o_oe(platform_gpio_0_pins_0_o_oe),
    .gpio_0_pins_0_o_ie(platform_gpio_0_pins_0_o_ie),
    .gpio_0_pins_0_o_pue(platform_gpio_0_pins_0_o_pue),
    .gpio_0_pins_0_o_ds(platform_gpio_0_pins_0_o_ds),
    .gpio_0_pins_0_o_ps(platform_gpio_0_pins_0_o_ps),
    .gpio_0_pins_0_o_ds1(platform_gpio_0_pins_0_o_ds1),
    .gpio_0_pins_0_o_poe(platform_gpio_0_pins_0_o_poe),
    .gpio_0_pins_1_i_ival(platform_gpio_0_pins_1_i_ival),
    .gpio_0_pins_1_i_po(platform_gpio_0_pins_1_i_po),
    .gpio_0_pins_1_o_oval(platform_gpio_0_pins_1_o_oval),
    .gpio_0_pins_1_o_oe(platform_gpio_0_pins_1_o_oe),
    .gpio_0_pins_1_o_ie(platform_gpio_0_pins_1_o_ie),
    .gpio_0_pins_1_o_pue(platform_gpio_0_pins_1_o_pue),
    .gpio_0_pins_1_o_ds(platform_gpio_0_pins_1_o_ds),
    .gpio_0_pins_1_o_ps(platform_gpio_0_pins_1_o_ps),
    .gpio_0_pins_1_o_ds1(platform_gpio_0_pins_1_o_ds1),
    .gpio_0_pins_1_o_poe(platform_gpio_0_pins_1_o_poe),
    .gpio_0_pins_2_i_ival(platform_gpio_0_pins_2_i_ival),
    .gpio_0_pins_2_i_po(platform_gpio_0_pins_2_i_po),
    .gpio_0_pins_2_o_oval(platform_gpio_0_pins_2_o_oval),
    .gpio_0_pins_2_o_oe(platform_gpio_0_pins_2_o_oe),
    .gpio_0_pins_2_o_ie(platform_gpio_0_pins_2_o_ie),
    .gpio_0_pins_2_o_pue(platform_gpio_0_pins_2_o_pue),
    .gpio_0_pins_2_o_ds(platform_gpio_0_pins_2_o_ds),
    .gpio_0_pins_2_o_ps(platform_gpio_0_pins_2_o_ps),
    .gpio_0_pins_2_o_ds1(platform_gpio_0_pins_2_o_ds1),
    .gpio_0_pins_2_o_poe(platform_gpio_0_pins_2_o_poe),
    .gpio_0_pins_3_i_ival(platform_gpio_0_pins_3_i_ival),
    .gpio_0_pins_3_i_po(platform_gpio_0_pins_3_i_po),
    .gpio_0_pins_3_o_oval(platform_gpio_0_pins_3_o_oval),
    .gpio_0_pins_3_o_oe(platform_gpio_0_pins_3_o_oe),
    .gpio_0_pins_3_o_ie(platform_gpio_0_pins_3_o_ie),
    .gpio_0_pins_3_o_pue(platform_gpio_0_pins_3_o_pue),
    .gpio_0_pins_3_o_ds(platform_gpio_0_pins_3_o_ds),
    .gpio_0_pins_3_o_ps(platform_gpio_0_pins_3_o_ps),
    .gpio_0_pins_3_o_ds1(platform_gpio_0_pins_3_o_ds1),
    .gpio_0_pins_3_o_poe(platform_gpio_0_pins_3_o_poe),
    .gpio_0_pins_4_i_ival(platform_gpio_0_pins_4_i_ival),
    .gpio_0_pins_4_i_po(platform_gpio_0_pins_4_i_po),
    .gpio_0_pins_4_o_oval(platform_gpio_0_pins_4_o_oval),
    .gpio_0_pins_4_o_oe(platform_gpio_0_pins_4_o_oe),
    .gpio_0_pins_4_o_ie(platform_gpio_0_pins_4_o_ie),
    .gpio_0_pins_4_o_pue(platform_gpio_0_pins_4_o_pue),
    .gpio_0_pins_4_o_ds(platform_gpio_0_pins_4_o_ds),
    .gpio_0_pins_4_o_ps(platform_gpio_0_pins_4_o_ps),
    .gpio_0_pins_4_o_ds1(platform_gpio_0_pins_4_o_ds1),
    .gpio_0_pins_4_o_poe(platform_gpio_0_pins_4_o_poe),
    .gpio_0_pins_5_i_ival(platform_gpio_0_pins_5_i_ival),
    .gpio_0_pins_5_i_po(platform_gpio_0_pins_5_i_po),
    .gpio_0_pins_5_o_oval(platform_gpio_0_pins_5_o_oval),
    .gpio_0_pins_5_o_oe(platform_gpio_0_pins_5_o_oe),
    .gpio_0_pins_5_o_ie(platform_gpio_0_pins_5_o_ie),
    .gpio_0_pins_5_o_pue(platform_gpio_0_pins_5_o_pue),
    .gpio_0_pins_5_o_ds(platform_gpio_0_pins_5_o_ds),
    .gpio_0_pins_5_o_ps(platform_gpio_0_pins_5_o_ps),
    .gpio_0_pins_5_o_ds1(platform_gpio_0_pins_5_o_ds1),
    .gpio_0_pins_5_o_poe(platform_gpio_0_pins_5_o_poe),
    .gpio_0_pins_6_i_ival(platform_gpio_0_pins_6_i_ival),
    .gpio_0_pins_6_i_po(platform_gpio_0_pins_6_i_po),
    .gpio_0_pins_6_o_oval(platform_gpio_0_pins_6_o_oval),
    .gpio_0_pins_6_o_oe(platform_gpio_0_pins_6_o_oe),
    .gpio_0_pins_6_o_ie(platform_gpio_0_pins_6_o_ie),
    .gpio_0_pins_6_o_pue(platform_gpio_0_pins_6_o_pue),
    .gpio_0_pins_6_o_ds(platform_gpio_0_pins_6_o_ds),
    .gpio_0_pins_6_o_ps(platform_gpio_0_pins_6_o_ps),
    .gpio_0_pins_6_o_ds1(platform_gpio_0_pins_6_o_ds1),
    .gpio_0_pins_6_o_poe(platform_gpio_0_pins_6_o_poe),
    .gpio_0_pins_7_i_ival(platform_gpio_0_pins_7_i_ival),
    .gpio_0_pins_7_i_po(platform_gpio_0_pins_7_i_po),
    .gpio_0_pins_7_o_oval(platform_gpio_0_pins_7_o_oval),
    .gpio_0_pins_7_o_oe(platform_gpio_0_pins_7_o_oe),
    .gpio_0_pins_7_o_ie(platform_gpio_0_pins_7_o_ie),
    .gpio_0_pins_7_o_pue(platform_gpio_0_pins_7_o_pue),
    .gpio_0_pins_7_o_ds(platform_gpio_0_pins_7_o_ds),
    .gpio_0_pins_7_o_ps(platform_gpio_0_pins_7_o_ps),
    .gpio_0_pins_7_o_ds1(platform_gpio_0_pins_7_o_ds1),
    .gpio_0_pins_7_o_poe(platform_gpio_0_pins_7_o_poe),
    .uart_0_txd(platform_uart_0_txd),
    .uart_0_rxd(platform_uart_0_rxd),
    .i2c_0_scl_in(platform_i2c_0_scl_in),
    .i2c_0_scl_out(platform_i2c_0_scl_out),
    .i2c_0_scl_oe(platform_i2c_0_scl_oe),
    .i2c_0_sda_in(platform_i2c_0_sda_in),
    .i2c_0_sda_out(platform_i2c_0_sda_out),
    .i2c_0_sda_oe(platform_i2c_0_sda_oe),
    .artyA7MIGPorts_0_ddr3_addr(platform_artyA7MIGPorts_0_ddr3_addr),
    .artyA7MIGPorts_0_ddr3_ba(platform_artyA7MIGPorts_0_ddr3_ba),
    .artyA7MIGPorts_0_ddr3_ras_n(platform_artyA7MIGPorts_0_ddr3_ras_n),
    .artyA7MIGPorts_0_ddr3_cas_n(platform_artyA7MIGPorts_0_ddr3_cas_n),
    .artyA7MIGPorts_0_ddr3_we_n(platform_artyA7MIGPorts_0_ddr3_we_n),
    .artyA7MIGPorts_0_ddr3_reset_n(platform_artyA7MIGPorts_0_ddr3_reset_n),
    .artyA7MIGPorts_0_ddr3_ck_p(platform_artyA7MIGPorts_0_ddr3_ck_p),
    .artyA7MIGPorts_0_ddr3_ck_n(platform_artyA7MIGPorts_0_ddr3_ck_n),
    .artyA7MIGPorts_0_ddr3_cke(platform_artyA7MIGPorts_0_ddr3_cke),
    .artyA7MIGPorts_0_ddr3_cs_n(platform_artyA7MIGPorts_0_ddr3_cs_n),
    .artyA7MIGPorts_0_ddr3_dm(platform_artyA7MIGPorts_0_ddr3_dm),
    .artyA7MIGPorts_0_ddr3_odt(platform_artyA7MIGPorts_0_ddr3_odt),
    .artyA7MIGPorts_0_ddr3_dq(ddr_ddr3_dq),
    .artyA7MIGPorts_0_ddr3_dqs_n(ddr_ddr3_dqs_n),
    .artyA7MIGPorts_0_ddr3_dqs_p(ddr_ddr3_dqs_p),
    .artyA7MIGPorts_0_sys_clk_i(platform_artyA7MIGPorts_0_sys_clk_i),
    .artyA7MIGPorts_0_clk_ref_i(platform_artyA7MIGPorts_0_clk_ref_i),
    .artyA7MIGPorts_0_ui_clk(platform_artyA7MIGPorts_0_ui_clk),
    .artyA7MIGPorts_0_ui_clk_sync_rst(platform_artyA7MIGPorts_0_ui_clk_sync_rst),
    .artyA7MIGPorts_0_mmcm_locked(platform_artyA7MIGPorts_0_mmcm_locked),
    .artyA7MIGPorts_0_aresetn(platform_artyA7MIGPorts_0_aresetn),
    .artyA7MIGPorts_0_init_calib_complete(platform_artyA7MIGPorts_0_init_calib_complete),
    .artyA7MIGPorts_0_sys_rst(platform_artyA7MIGPorts_0_sys_rst),
    .spi_0_sck(platform_spi_0_sck),
    .spi_0_dq_0_i(platform_spi_0_dq_0_i),
    .spi_0_dq_0_o(platform_spi_0_dq_0_o),
    .spi_0_dq_0_ie(platform_spi_0_dq_0_ie),
    .spi_0_dq_0_oe(platform_spi_0_dq_0_oe),
    .spi_0_dq_1_i(platform_spi_0_dq_1_i),
    .spi_0_dq_1_o(platform_spi_0_dq_1_o),
    .spi_0_dq_1_ie(platform_spi_0_dq_1_ie),
    .spi_0_dq_1_oe(platform_spi_0_dq_1_oe),
    .spi_0_dq_2_i(platform_spi_0_dq_2_i),
    .spi_0_dq_2_o(platform_spi_0_dq_2_o),
    .spi_0_dq_2_ie(platform_spi_0_dq_2_ie),
    .spi_0_dq_2_oe(platform_spi_0_dq_2_oe),
    .spi_0_dq_3_i(platform_spi_0_dq_3_i),
    .spi_0_dq_3_o(platform_spi_0_dq_3_o),
    .spi_0_dq_3_ie(platform_spi_0_dq_3_ie),
    .spi_0_dq_3_oe(platform_spi_0_dq_3_oe),
    .spi_0_cs_0(platform_spi_0_cs_0),
    .otherclock(platform_otherclock)
  );
  IOBUF pad ( // @[Unisim.scala 271:23]
    .O(pad_O),
    .IO(led_0),
    .I(pad_I),
    .T(pad_T)
  );
  IOBUF pad_1 ( // @[Unisim.scala 271:23]
    .O(pad_1_O),
    .IO(led_1),
    .I(pad_1_I),
    .T(pad_1_T)
  );
  IOBUF pad_2 ( // @[Unisim.scala 271:23]
    .O(pad_2_O),
    .IO(led_2),
    .I(pad_2_I),
    .T(pad_2_T)
  );
  IOBUF pad_3 ( // @[Unisim.scala 271:23]
    .O(pad_3_O),
    .IO(led_3),
    .I(pad_3_I),
    .T(pad_3_T)
  );
  IOBUF pad_4 ( // @[Unisim.scala 271:23]
    .O(pad_4_O),
    .IO(sw_0),
    .I(pad_4_I),
    .T(pad_4_T)
  );
  IOBUF pad_5 ( // @[Unisim.scala 271:23]
    .O(pad_5_O),
    .IO(sw_1),
    .I(pad_5_I),
    .T(pad_5_T)
  );
  IOBUF pad_6 ( // @[Unisim.scala 271:23]
    .O(pad_6_O),
    .IO(sw_2),
    .I(pad_6_I),
    .T(pad_6_T)
  );
  IOBUF pad_7 ( // @[Unisim.scala 271:23]
    .O(pad_7_O),
    .IO(sw_3),
    .I(pad_7_I),
    .T(pad_7_T)
  );
  IOBUF platform_jtag_TDI_pad ( // @[Unisim.scala 289:21]
    .O(platform_jtag_TDI_pad_O),
    .IO(jd_4),
    .I(platform_jtag_TDI_pad_I),
    .T(platform_jtag_TDI_pad_T)
  );
  IOBUF platform_jtag_TMS_pad ( // @[Unisim.scala 289:21]
    .O(platform_jtag_TMS_pad_O),
    .IO(jd_5),
    .I(platform_jtag_TMS_pad_I),
    .T(platform_jtag_TMS_pad_T)
  );
  IOBUF platform_jtag_TCK_pad ( // @[Unisim.scala 289:21]
    .O(platform_jtag_TCK_pad_O),
    .IO(jd_2),
    .I(platform_jtag_TCK_pad_I),
    .T(platform_jtag_TCK_pad_T)
  );
  IOBUF pad_8 ( // @[Unisim.scala 271:23]
    .O(pad_8_O),
    .IO(jd_0),
    .I(pad_8_I),
    .T(pad_8_T)
  );
  IOBUF platform_jtag_TRSTn_pad ( // @[Unisim.scala 289:21]
    .O(platform_jtag_TRSTn_pad_O),
    .IO(jd_6),
    .I(platform_jtag_TRSTn_pad_I),
    .T(platform_jtag_TRSTn_pad_T)
  );
  PULLUP pullup_ ( // @[Unisim.scala 384:24]
    .O(jd_4)
  );
  PULLUP pullup_1 ( // @[Unisim.scala 384:24]
    .O(jd_5)
  );
  PULLUP pullup_2 ( // @[Unisim.scala 384:24]
    .O(jd_6)
  );
  IOBUF platform_uart_0_rxd_pad ( // @[Unisim.scala 289:21]
    .O(platform_uart_0_rxd_pad_O),
    .IO(uart_txd_in),
    .I(platform_uart_0_rxd_pad_I),
    .T(platform_uart_0_rxd_pad_T)
  );
  IOBUF pad_9 ( // @[Unisim.scala 281:21]
    .O(pad_9_O),
    .IO(uart_rxd_out),
    .I(pad_9_I),
    .T(pad_9_T)
  );
  SynchronizerShiftReg_w1_d3_inArtyA7Top platform_spi_0_dq_0_i_spi_dq_0_sync ( // @[ShiftReg.scala 45:23]
    .clock(platform_spi_0_dq_0_i_spi_dq_0_sync_clock),
    .io_d(platform_spi_0_dq_0_i_spi_dq_0_sync_io_d),
    .io_q(platform_spi_0_dq_0_i_spi_dq_0_sync_io_q)
  );
  SynchronizerShiftReg_w1_d3_inArtyA7Top platform_spi_0_dq_1_i_spi_dq_1_sync ( // @[ShiftReg.scala 45:23]
    .clock(platform_spi_0_dq_1_i_spi_dq_1_sync_clock),
    .io_d(platform_spi_0_dq_1_i_spi_dq_1_sync_io_d),
    .io_q(platform_spi_0_dq_1_i_spi_dq_1_sync_io_q)
  );
  SynchronizerShiftReg_w1_d3_inArtyA7Top platform_spi_0_dq_2_i_spi_dq_2_sync ( // @[ShiftReg.scala 45:23]
    .clock(platform_spi_0_dq_2_i_spi_dq_2_sync_clock),
    .io_d(platform_spi_0_dq_2_i_spi_dq_2_sync_io_d),
    .io_q(platform_spi_0_dq_2_i_spi_dq_2_sync_io_q)
  );
  SynchronizerShiftReg_w1_d3_inArtyA7Top platform_spi_0_dq_3_i_spi_dq_3_sync ( // @[ShiftReg.scala 45:23]
    .clock(platform_spi_0_dq_3_i_spi_dq_3_sync_clock),
    .io_d(platform_spi_0_dq_3_i_spi_dq_3_sync_io_d),
    .io_q(platform_spi_0_dq_3_i_spi_dq_3_sync_io_q)
  );
  IOBUF pad_10 ( // @[Unisim.scala 271:23]
    .O(pad_10_O),
    .IO(ja_0),
    .I(pad_10_I),
    .T(pad_10_T)
  );
  IOBUF pad_11 ( // @[Unisim.scala 271:23]
    .O(pad_11_O),
    .IO(ja_1),
    .I(pad_11_I),
    .T(pad_11_T)
  );
  IOBUF pad_12 ( // @[Unisim.scala 271:23]
    .O(pad_12_O),
    .IO(ja_2),
    .I(pad_12_I),
    .T(pad_12_T)
  );
  IOBUF pad_13 ( // @[Unisim.scala 271:23]
    .O(pad_13_O),
    .IO(ja_3),
    .I(pad_13_I),
    .T(pad_13_T)
  );
  IOBUF pad_14 ( // @[Unisim.scala 271:23]
    .O(pad_14_O),
    .IO(ja_4),
    .I(pad_14_I),
    .T(pad_14_T)
  );
  IOBUF pad_15 ( // @[Unisim.scala 271:23]
    .O(pad_15_O),
    .IO(ja_5),
    .I(pad_15_I),
    .T(pad_15_T)
  );
  SyncResetSynchronizerShiftReg_w1_d3_i1_inArtyA7Top platform_i2c_0_scl_in_i2c_scl_sync ( // @[ShiftReg.scala 45:23]
    .clock(platform_i2c_0_scl_in_i2c_scl_sync_clock),
    .reset(platform_i2c_0_scl_in_i2c_scl_sync_reset),
    .io_d(platform_i2c_0_scl_in_i2c_scl_sync_io_d),
    .io_q(platform_i2c_0_scl_in_i2c_scl_sync_io_q)
  );
  SyncResetSynchronizerShiftReg_w1_d3_i1_inArtyA7Top platform_i2c_0_sda_in_i2c_sda_sync ( // @[ShiftReg.scala 45:23]
    .clock(platform_i2c_0_sda_in_i2c_sda_sync_clock),
    .reset(platform_i2c_0_sda_in_i2c_sda_sync_reset),
    .io_d(platform_i2c_0_sda_in_i2c_sda_sync_io_d),
    .io_q(platform_i2c_0_sda_in_i2c_sda_sync_io_q)
  );
  IOBUF pad_16 ( // @[Unisim.scala 271:23]
    .O(pad_16_O),
    .IO(ck_io_0),
    .I(pad_16_I),
    .T(pad_16_T)
  );
  IOBUF pad_17 ( // @[Unisim.scala 271:23]
    .O(pad_17_O),
    .IO(ck_io_1),
    .I(pad_17_I),
    .T(pad_17_T)
  );
  ResetCatchAndSync_d3_inArtyA7Top platform_artyA7MIGPorts_0_sys_rst_catcher ( // @[ResetCatchAndSync.scala 39:28]
    .clock(platform_artyA7MIGPorts_0_sys_rst_catcher_clock),
    .reset(platform_artyA7MIGPorts_0_sys_rst_catcher_reset),
    .io_sync_reset(platform_artyA7MIGPorts_0_sys_rst_catcher_io_sync_reset)
  );
  ResetCatchAndSync_d3_inArtyA7Top reset_catcher ( // @[ResetCatchAndSync.scala 39:28]
    .clock(reset_catcher_clock),
    .reset(reset_catcher_reset),
    .io_sync_reset(reset_catcher_io_sync_reset)
  );
  assign ddr_ddr3_addr = platform_artyA7MIGPorts_0_ddr3_addr; // @[artya7.scala 132:11]
  assign ddr_ddr3_ba = platform_artyA7MIGPorts_0_ddr3_ba; // @[artya7.scala 132:11]
  assign ddr_ddr3_ras_n = platform_artyA7MIGPorts_0_ddr3_ras_n; // @[artya7.scala 132:11]
  assign ddr_ddr3_cas_n = platform_artyA7MIGPorts_0_ddr3_cas_n; // @[artya7.scala 132:11]
  assign ddr_ddr3_we_n = platform_artyA7MIGPorts_0_ddr3_we_n; // @[artya7.scala 132:11]
  assign ddr_ddr3_reset_n = platform_artyA7MIGPorts_0_ddr3_reset_n; // @[artya7.scala 132:11]
  assign ddr_ddr3_ck_p = platform_artyA7MIGPorts_0_ddr3_ck_p; // @[artya7.scala 132:11]
  assign ddr_ddr3_ck_n = platform_artyA7MIGPorts_0_ddr3_ck_n; // @[artya7.scala 132:11]
  assign ddr_ddr3_cke = platform_artyA7MIGPorts_0_ddr3_cke; // @[artya7.scala 132:11]
  assign ddr_ddr3_cs_n = platform_artyA7MIGPorts_0_ddr3_cs_n; // @[artya7.scala 132:11]
  assign ddr_ddr3_dm = platform_artyA7MIGPorts_0_ddr3_dm; // @[artya7.scala 132:11]
  assign ddr_ddr3_odt = platform_artyA7MIGPorts_0_ddr3_odt; // @[artya7.scala 132:11]
  assign pll_clk_in1 = CLK100MHZ; // @[artya7.scala 35:18]
  assign pll_reset = ~ck_rst; // @[artya7.scala 36:19]
  assign platform_clock = pll_clk_out1;
  assign platform_reset = reset | platform_ndreset; // @[artya7.scala 45:28]
  assign platform_jtag_TRSTn = platform_jtag_TRSTn_pad_O; // @[artya7.scala 68:28]
  assign platform_jtag_TCK = platform_jtag_TCK_pad_O; // @[artya7.scala 61:32]
  assign platform_jtag_TMS = platform_jtag_TMS_pad_O; // @[artya7.scala 60:16]
  assign platform_jtag_TDI = platform_jtag_TDI_pad_O; // @[artya7.scala 59:16]
  assign platform_gpio_0_pins_0_i_ival = pad_O & base_pin_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_0_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_gpio_0_pins_1_i_ival = pad_1_O & base_pin_1_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_1_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_gpio_0_pins_2_i_ival = pad_2_O & base_pin_2_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_2_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_gpio_0_pins_3_i_ival = pad_3_O & base_pin_3_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_3_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_gpio_0_pins_4_i_ival = pad_4_O & base_pin_4_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_4_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_gpio_0_pins_5_i_ival = pad_5_O & base_pin_5_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_5_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_gpio_0_pins_6_i_ival = pad_6_O & base_pin_6_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_6_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_gpio_0_pins_7_i_ival = pad_7_O & base_pin_7_o_ie; // @[Unisim.scala 274:31]
  assign platform_gpio_0_pins_7_i_po = 1'h0; // @[PinCtrl.scala 120:14]
  assign platform_uart_0_rxd = platform_uart_0_rxd_pad_O; // @[artya7.scala 76:16]
  assign platform_i2c_0_scl_in = platform_i2c_0_scl_in_i2c_scl_sync_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign platform_i2c_0_sda_in = platform_i2c_0_sda_in_i2c_sda_sync_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign platform_artyA7MIGPorts_0_sys_clk_i = pll_clk_out2; // @[artya7.scala 134:44]
  assign platform_artyA7MIGPorts_0_clk_ref_i = pll_clk_out3; // @[artya7.scala 135:44]
  assign platform_artyA7MIGPorts_0_aresetn = pll_locked; // @[artya7.scala 136:19]
  assign platform_artyA7MIGPorts_0_sys_rst = platform_artyA7MIGPorts_0_sys_rst_catcher_io_sync_reset; // @[artya7.scala 137:19]
  assign platform_spi_0_dq_0_i = platform_spi_0_dq_0_i_spi_dq_0_sync_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign platform_spi_0_dq_1_i = platform_spi_0_dq_1_i_spi_dq_1_sync_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign platform_spi_0_dq_2_i = platform_spi_0_dq_2_i_spi_dq_2_sync_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign platform_spi_0_dq_3_i = platform_spi_0_dq_3_i_spi_dq_3_sync_io_q; // @[ShiftReg.scala 48:{24,24}]
  assign platform_otherclock = 1'h0; // @[artya7.scala 142:36]
  assign pad_I = platform_gpio_0_pins_0_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_T = ~base_pin_o_oe; // @[Unisim.scala 273:19]
  assign pad_1_I = platform_gpio_0_pins_1_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_1_T = ~base_pin_1_o_oe; // @[Unisim.scala 273:19]
  assign pad_2_I = platform_gpio_0_pins_2_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_2_T = ~base_pin_2_o_oe; // @[Unisim.scala 273:19]
  assign pad_3_I = platform_gpio_0_pins_3_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_3_T = ~base_pin_3_o_oe; // @[Unisim.scala 273:19]
  assign pad_4_I = platform_gpio_0_pins_4_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_4_T = ~base_pin_4_o_oe; // @[Unisim.scala 273:19]
  assign pad_5_I = platform_gpio_0_pins_5_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_5_T = ~base_pin_5_o_oe; // @[Unisim.scala 273:19]
  assign pad_6_I = platform_gpio_0_pins_6_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_6_T = ~base_pin_6_o_oe; // @[Unisim.scala 273:19]
  assign pad_7_I = platform_gpio_0_pins_7_o_oval; // @[PinCtrl.scala 119:24 120:14]
  assign pad_7_T = ~base_pin_7_o_oe; // @[Unisim.scala 273:19]
  assign platform_jtag_TDI_pad_I = 1'h0; // @[Unisim.scala 290:14]
  assign platform_jtag_TDI_pad_T = 1'h1; // @[Unisim.scala 291:14]
  assign platform_jtag_TMS_pad_I = 1'h0; // @[Unisim.scala 290:14]
  assign platform_jtag_TMS_pad_T = 1'h1; // @[Unisim.scala 291:14]
  assign platform_jtag_TCK_pad_I = 1'h0; // @[Unisim.scala 290:14]
  assign platform_jtag_TCK_pad_T = 1'h1; // @[Unisim.scala 291:14]
  assign pad_8_I = platform_jtag_TDO_data; // @[artya7.scala 62:29 64:26]
  assign pad_8_T = ~TDO_as_base_o_oe; // @[Unisim.scala 273:19]
  assign platform_jtag_TRSTn_pad_I = 1'h0; // @[Unisim.scala 290:14]
  assign platform_jtag_TRSTn_pad_T = 1'h1; // @[Unisim.scala 291:14]
  assign platform_uart_0_rxd_pad_I = 1'h0; // @[Unisim.scala 290:14]
  assign platform_uart_0_rxd_pad_T = 1'h1; // @[Unisim.scala 291:14]
  assign pad_9_I = platform_uart_0_txd; // @[Unisim.scala 282:14]
  assign pad_9_T = 1'h0; // @[Unisim.scala 283:14]
  assign platform_spi_0_dq_0_i_spi_dq_0_sync_clock = pll_clk_out1;
  assign platform_spi_0_dq_0_i_spi_dq_0_sync_io_d = pad_11_O & spi_dq_0_o_ie; // @[Unisim.scala 274:31]
  assign platform_spi_0_dq_1_i_spi_dq_1_sync_clock = pll_clk_out1;
  assign platform_spi_0_dq_1_i_spi_dq_1_sync_io_d = pad_12_O & spi_dq_1_o_ie; // @[Unisim.scala 274:31]
  assign platform_spi_0_dq_2_i_spi_dq_2_sync_clock = pll_clk_out1;
  assign platform_spi_0_dq_2_i_spi_dq_2_sync_io_d = pad_14_O & spi_dq_2_o_ie; // @[Unisim.scala 274:31]
  assign platform_spi_0_dq_3_i_spi_dq_3_sync_clock = pll_clk_out1;
  assign platform_spi_0_dq_3_i_spi_dq_3_sync_io_d = pad_15_O & spi_dq_3_o_ie; // @[Unisim.scala 274:31]
  assign pad_10_I = platform_spi_0_cs_0; // @[PinCtrl.scala 60:17 artya7.scala 82:21]
  assign pad_10_T = 1'h0; // @[Unisim.scala 273:19]
  assign pad_11_I = platform_spi_0_dq_0_o; // @[PinCtrl.scala 60:17 artya7.scala 82:21]
  assign pad_11_T = ~spi_dq_0_o_oe; // @[Unisim.scala 273:19]
  assign pad_12_I = platform_spi_0_dq_1_o; // @[PinCtrl.scala 60:17 artya7.scala 82:21]
  assign pad_12_T = ~spi_dq_1_o_oe; // @[Unisim.scala 273:19]
  assign pad_13_I = platform_spi_0_sck; // @[PinCtrl.scala 60:17 artya7.scala 82:21]
  assign pad_13_T = 1'h0; // @[Unisim.scala 273:19]
  assign pad_14_I = platform_spi_0_dq_2_o; // @[PinCtrl.scala 60:17 artya7.scala 82:21]
  assign pad_14_T = ~spi_dq_2_o_oe; // @[Unisim.scala 273:19]
  assign pad_15_I = platform_spi_0_dq_3_o; // @[PinCtrl.scala 60:17 artya7.scala 82:21]
  assign pad_15_T = ~spi_dq_3_o_oe; // @[Unisim.scala 273:19]
  assign platform_i2c_0_scl_in_i2c_scl_sync_clock = pll_clk_out1;
  assign platform_i2c_0_scl_in_i2c_scl_sync_reset = reset_catcher_io_sync_reset; // @[artya7.scala 118:47]
  assign platform_i2c_0_scl_in_i2c_scl_sync_io_d = pad_16_O; // @[Unisim.scala 274:31]
  assign platform_i2c_0_sda_in_i2c_sda_sync_clock = pll_clk_out1;
  assign platform_i2c_0_sda_in_i2c_sda_sync_reset = reset_catcher_io_sync_reset; // @[artya7.scala 118:47]
  assign platform_i2c_0_sda_in_i2c_sda_sync_io_d = pad_17_O; // @[Unisim.scala 274:31]
  assign pad_16_I = platform_i2c_0_scl_out; // @[artya7.scala 115:21 PinCtrl.scala 60:17]
  assign pad_16_T = ~i2c_scl_o_oe; // @[Unisim.scala 273:19]
  assign pad_17_I = platform_i2c_0_sda_out; // @[artya7.scala 115:21 PinCtrl.scala 60:17]
  assign pad_17_T = ~i2c_sda_o_oe; // @[Unisim.scala 273:19]
  assign platform_artyA7MIGPorts_0_sys_rst_catcher_clock = pll_clk_out2;
  assign platform_artyA7MIGPorts_0_sys_rst_catcher_reset = ~pll_locked; // @[artya7.scala 137:61]
  assign reset_catcher_clock = pll_clk_out1;
  assign reset_catcher_reset = platform_artyA7MIGPorts_0_ui_clk_sync_rst;
endmodule

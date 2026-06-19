circuit ArtyA7Top :
  extmodule pll :
    input clk_in1 : Clock
    output clk_out1 : Clock
    output clk_out2 : Clock
    output clk_out3 : Clock
    input reset : UInt<1>
    output locked : UInt<1>
    defname = pll

  module NonSyncResetSynchronizerPrimitiveShiftReg_d3_inArtyA7Top :
    input clock : Clock
    input io_d : UInt<1>
    output io_q : UInt<1>

    reg sync_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sync_0) @[SynchronizerReg.scala 51:66]
    reg sync_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sync_1) @[SynchronizerReg.scala 51:66]
    reg sync_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sync_2) @[SynchronizerReg.scala 51:66]
    io_q <= sync_0 @[SynchronizerReg.scala 59:8]
    sync_0 <= sync_1 @[SynchronizerReg.scala 57:10]
    sync_1 <= sync_2 @[SynchronizerReg.scala 57:10]
    sync_2 <= io_d @[SynchronizerReg.scala 54:22]

  module SynchronizerShiftReg_w1_d3_inArtyA7Top :
    input clock : Clock
    input io_d : UInt<1>
    output io_q : UInt<1>

    inst output_chain of NonSyncResetSynchronizerPrimitiveShiftReg_d3_inArtyA7Top @[ShiftReg.scala 45:23]
    io_q <= output_chain.io_q @[ShiftReg.scala 48:{24,24}]
    output_chain.clock <= clock
    output_chain.io_d <= io_d @[SynchronizerReg.scala 173:39]

  module AsyncResetSynchronizerPrimitiveShiftReg_d3_i0_inArtyA7Top :
    input clock : Clock
    input reset : AsyncReset
    output io_q : UInt<1>

    reg sync_0 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[SynchronizerReg.scala 51:87]
    reg sync_1 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[SynchronizerReg.scala 51:87]
    reg sync_2 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[SynchronizerReg.scala 51:87]
    io_q <= sync_0 @[SynchronizerReg.scala 59:8]
    sync_0 <= sync_1 @[SynchronizerReg.scala 51:{87,87} 57:10]
    sync_1 <= sync_2 @[SynchronizerReg.scala 51:{87,87} 57:10]
    sync_2 <= UInt<1>("h1") @[SynchronizerReg.scala 54:22]

  module AsyncResetSynchronizerShiftReg_w1_d3_i0_inArtyA7Top :
    input clock : Clock
    input reset : UInt<1>
    output io_q : UInt<1>

    inst output_chain of AsyncResetSynchronizerPrimitiveShiftReg_d3_i0_inArtyA7Top @[ShiftReg.scala 45:23]
    io_q <= output_chain.io_q @[ShiftReg.scala 48:{24,24}]
    output_chain.clock <= clock
    output_chain.reset <= asAsyncReset(reset) @[SynchronizerReg.scala 86:21]

  extmodule RVCSystem :
    input clock : Clock
    input reset : UInt<1>
    output ndreset : UInt<1>
    input jtag_TRSTn : UInt<1>
    input jtag_TCK : Clock
    input jtag_TMS : UInt<1>
    input jtag_TDI : UInt<1>
    output jtag_TDO_data : UInt<1>
    output jtag_TDO_driven : UInt<1>
    input gpio_0_pins_0_i_ival : UInt<1>
    input gpio_0_pins_0_i_po : UInt<1>
    output gpio_0_pins_0_o_oval : UInt<1>
    output gpio_0_pins_0_o_oe : UInt<1>
    output gpio_0_pins_0_o_ie : UInt<1>
    output gpio_0_pins_0_o_pue : UInt<1>
    output gpio_0_pins_0_o_ds : UInt<1>
    output gpio_0_pins_0_o_ps : UInt<1>
    output gpio_0_pins_0_o_ds1 : UInt<1>
    output gpio_0_pins_0_o_poe : UInt<1>
    input gpio_0_pins_1_i_ival : UInt<1>
    input gpio_0_pins_1_i_po : UInt<1>
    output gpio_0_pins_1_o_oval : UInt<1>
    output gpio_0_pins_1_o_oe : UInt<1>
    output gpio_0_pins_1_o_ie : UInt<1>
    output gpio_0_pins_1_o_pue : UInt<1>
    output gpio_0_pins_1_o_ds : UInt<1>
    output gpio_0_pins_1_o_ps : UInt<1>
    output gpio_0_pins_1_o_ds1 : UInt<1>
    output gpio_0_pins_1_o_poe : UInt<1>
    input gpio_0_pins_2_i_ival : UInt<1>
    input gpio_0_pins_2_i_po : UInt<1>
    output gpio_0_pins_2_o_oval : UInt<1>
    output gpio_0_pins_2_o_oe : UInt<1>
    output gpio_0_pins_2_o_ie : UInt<1>
    output gpio_0_pins_2_o_pue : UInt<1>
    output gpio_0_pins_2_o_ds : UInt<1>
    output gpio_0_pins_2_o_ps : UInt<1>
    output gpio_0_pins_2_o_ds1 : UInt<1>
    output gpio_0_pins_2_o_poe : UInt<1>
    input gpio_0_pins_3_i_ival : UInt<1>
    input gpio_0_pins_3_i_po : UInt<1>
    output gpio_0_pins_3_o_oval : UInt<1>
    output gpio_0_pins_3_o_oe : UInt<1>
    output gpio_0_pins_3_o_ie : UInt<1>
    output gpio_0_pins_3_o_pue : UInt<1>
    output gpio_0_pins_3_o_ds : UInt<1>
    output gpio_0_pins_3_o_ps : UInt<1>
    output gpio_0_pins_3_o_ds1 : UInt<1>
    output gpio_0_pins_3_o_poe : UInt<1>
    input gpio_0_pins_4_i_ival : UInt<1>
    input gpio_0_pins_4_i_po : UInt<1>
    output gpio_0_pins_4_o_oval : UInt<1>
    output gpio_0_pins_4_o_oe : UInt<1>
    output gpio_0_pins_4_o_ie : UInt<1>
    output gpio_0_pins_4_o_pue : UInt<1>
    output gpio_0_pins_4_o_ds : UInt<1>
    output gpio_0_pins_4_o_ps : UInt<1>
    output gpio_0_pins_4_o_ds1 : UInt<1>
    output gpio_0_pins_4_o_poe : UInt<1>
    input gpio_0_pins_5_i_ival : UInt<1>
    input gpio_0_pins_5_i_po : UInt<1>
    output gpio_0_pins_5_o_oval : UInt<1>
    output gpio_0_pins_5_o_oe : UInt<1>
    output gpio_0_pins_5_o_ie : UInt<1>
    output gpio_0_pins_5_o_pue : UInt<1>
    output gpio_0_pins_5_o_ds : UInt<1>
    output gpio_0_pins_5_o_ps : UInt<1>
    output gpio_0_pins_5_o_ds1 : UInt<1>
    output gpio_0_pins_5_o_poe : UInt<1>
    input gpio_0_pins_6_i_ival : UInt<1>
    input gpio_0_pins_6_i_po : UInt<1>
    output gpio_0_pins_6_o_oval : UInt<1>
    output gpio_0_pins_6_o_oe : UInt<1>
    output gpio_0_pins_6_o_ie : UInt<1>
    output gpio_0_pins_6_o_pue : UInt<1>
    output gpio_0_pins_6_o_ds : UInt<1>
    output gpio_0_pins_6_o_ps : UInt<1>
    output gpio_0_pins_6_o_ds1 : UInt<1>
    output gpio_0_pins_6_o_poe : UInt<1>
    input gpio_0_pins_7_i_ival : UInt<1>
    input gpio_0_pins_7_i_po : UInt<1>
    output gpio_0_pins_7_o_oval : UInt<1>
    output gpio_0_pins_7_o_oe : UInt<1>
    output gpio_0_pins_7_o_ie : UInt<1>
    output gpio_0_pins_7_o_pue : UInt<1>
    output gpio_0_pins_7_o_ds : UInt<1>
    output gpio_0_pins_7_o_ps : UInt<1>
    output gpio_0_pins_7_o_ds1 : UInt<1>
    output gpio_0_pins_7_o_poe : UInt<1>
    output uart_0_txd : UInt<1>
    input uart_0_rxd : UInt<1>
    input i2c_0_scl_in : UInt<1>
    output i2c_0_scl_out : UInt<1>
    output i2c_0_scl_oe : UInt<1>
    input i2c_0_sda_in : UInt<1>
    output i2c_0_sda_out : UInt<1>
    output i2c_0_sda_oe : UInt<1>
    output artyA7MIGPorts_0_ddr3_addr : UInt<14>
    output artyA7MIGPorts_0_ddr3_ba : UInt<3>
    output artyA7MIGPorts_0_ddr3_ras_n : UInt<1>
    output artyA7MIGPorts_0_ddr3_cas_n : UInt<1>
    output artyA7MIGPorts_0_ddr3_we_n : UInt<1>
    output artyA7MIGPorts_0_ddr3_reset_n : UInt<1>
    output artyA7MIGPorts_0_ddr3_ck_p : UInt<1>
    output artyA7MIGPorts_0_ddr3_ck_n : UInt<1>
    output artyA7MIGPorts_0_ddr3_cke : UInt<1>
    output artyA7MIGPorts_0_ddr3_cs_n : UInt<1>
    output artyA7MIGPorts_0_ddr3_dm : UInt<2>
    output artyA7MIGPorts_0_ddr3_odt : UInt<1>
    output artyA7MIGPorts_0_ddr3_dq : Analog<16>
    output artyA7MIGPorts_0_ddr3_dqs_n : Analog<2>
    output artyA7MIGPorts_0_ddr3_dqs_p : Analog<2>
    input artyA7MIGPorts_0_sys_clk_i : UInt<1>
    input artyA7MIGPorts_0_clk_ref_i : UInt<1>
    output artyA7MIGPorts_0_ui_clk : Clock
    output artyA7MIGPorts_0_ui_clk_sync_rst : UInt<1>
    output artyA7MIGPorts_0_mmcm_locked : UInt<1>
    input artyA7MIGPorts_0_aresetn : UInt<1>
    output artyA7MIGPorts_0_init_calib_complete : UInt<1>
    input artyA7MIGPorts_0_sys_rst : UInt<1>
    output spi_0_sck : UInt<1>
    input spi_0_dq_0_i : UInt<1>
    output spi_0_dq_0_o : UInt<1>
    output spi_0_dq_0_ie : UInt<1>
    output spi_0_dq_0_oe : UInt<1>
    input spi_0_dq_1_i : UInt<1>
    output spi_0_dq_1_o : UInt<1>
    output spi_0_dq_1_ie : UInt<1>
    output spi_0_dq_1_oe : UInt<1>
    input spi_0_dq_2_i : UInt<1>
    output spi_0_dq_2_o : UInt<1>
    output spi_0_dq_2_ie : UInt<1>
    output spi_0_dq_2_oe : UInt<1>
    input spi_0_dq_3_i : UInt<1>
    output spi_0_dq_3_o : UInt<1>
    output spi_0_dq_3_ie : UInt<1>
    output spi_0_dq_3_oe : UInt<1>
    output spi_0_cs_0 : UInt<1>
    input otherclock : Clock
    defname = RVCSystem

  extmodule IOBUF :
    output O : UInt<1>
    output IO : Analog<1>
    input I : UInt<1>
    input T : UInt<1>
    defname = IOBUF

  extmodule PULLUP :
    output O : Analog<1>
    defname = PULLUP

  module SyncResetSynchronizerPrimitiveShiftReg_d3_i1_inArtyA7Top :
    input clock : Clock
    input reset : UInt<1>
    input io_d : UInt<1>
    output io_q : UInt<1>

    reg sync_0 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sync_0) @[SynchronizerReg.scala 51:87]
    reg sync_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sync_1) @[SynchronizerReg.scala 51:87]
    reg sync_2 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), sync_2) @[SynchronizerReg.scala 51:87]
    io_q <= sync_0 @[SynchronizerReg.scala 59:8]
    sync_0 <= or(reset, sync_1) @[SynchronizerReg.scala 51:{87,87} 57:10]
    sync_1 <= or(reset, sync_2) @[SynchronizerReg.scala 51:{87,87} 57:10]
    sync_2 <= or(reset, io_d) @[SynchronizerReg.scala 51:{87,87} 54:14]

  module SyncResetSynchronizerShiftReg_w1_d3_i1_inArtyA7Top :
    input clock : Clock
    input reset : UInt<1>
    input io_d : UInt<1>
    output io_q : UInt<1>

    inst output_chain of SyncResetSynchronizerPrimitiveShiftReg_d3_i1_inArtyA7Top @[ShiftReg.scala 45:23]
    io_q <= output_chain.io_q @[ShiftReg.scala 48:{24,24}]
    output_chain.clock <= clock
    output_chain.reset <= reset @[SynchronizerReg.scala 118:21]
    output_chain.io_d <= io_d @[SynchronizerReg.scala 119:41]

  module ResetCatchAndSync_d3_inArtyA7Top :
    input clock : Clock
    input reset : UInt<1>
    output io_sync_reset : UInt<1>

    inst io_sync_reset_chain of AsyncResetSynchronizerShiftReg_w1_d3_i0_inArtyA7Top @[ShiftReg.scala 45:23]
    node _io_sync_reset_WIRE = io_sync_reset_chain.io_q @[ShiftReg.scala 48:{24,24}]
    io_sync_reset <= not(_io_sync_reset_WIRE) @[ResetCatchAndSync.scala 29:7]
    io_sync_reset_chain.clock <= clock
    io_sync_reset_chain.reset <= reset @[ResetCatchAndSync.scala 26:27]

  module ArtyA7Top :
    input CLK100MHZ : Clock
    input ck_rst : UInt<1>
    output led_0 : Analog<1>
    output led_1 : Analog<1>
    output led_2 : Analog<1>
    output led_3 : Analog<1>
    output led0_r : Analog<1>
    output led0_g : Analog<1>
    output led0_b : Analog<1>
    output led1_r : Analog<1>
    output led1_g : Analog<1>
    output led1_b : Analog<1>
    output led2_r : Analog<1>
    output led2_g : Analog<1>
    output led2_b : Analog<1>
    output sw_0 : Analog<1>
    output sw_1 : Analog<1>
    output sw_2 : Analog<1>
    output sw_3 : Analog<1>
    output btn_0 : Analog<1>
    output btn_1 : Analog<1>
    output btn_2 : Analog<1>
    output btn_3 : Analog<1>
    output qspi_cs : Analog<1>
    output qspi_sck : Analog<1>
    output qspi_dq_0 : Analog<1>
    output qspi_dq_1 : Analog<1>
    output qspi_dq_2 : Analog<1>
    output qspi_dq_3 : Analog<1>
    output uart_rxd_out : Analog<1>
    output uart_txd_in : Analog<1>
    output ja_0 : Analog<1>
    output ja_1 : Analog<1>
    output ja_2 : Analog<1>
    output ja_3 : Analog<1>
    output ja_4 : Analog<1>
    output ja_5 : Analog<1>
    output ja_6 : Analog<1>
    output ja_7 : Analog<1>
    output jb_0 : Analog<1>
    output jb_1 : Analog<1>
    output jb_2 : Analog<1>
    output jb_3 : Analog<1>
    output jb_4 : Analog<1>
    output jb_5 : Analog<1>
    output jb_6 : Analog<1>
    output jb_7 : Analog<1>
    output jc_0 : Analog<1>
    output jc_1 : Analog<1>
    output jc_2 : Analog<1>
    output jc_3 : Analog<1>
    output jc_4 : Analog<1>
    output jc_5 : Analog<1>
    output jc_6 : Analog<1>
    output jc_7 : Analog<1>
    output jd_0 : Analog<1>
    output jd_1 : Analog<1>
    output jd_2 : Analog<1>
    output jd_3 : Analog<1>
    output jd_4 : Analog<1>
    output jd_5 : Analog<1>
    output jd_6 : Analog<1>
    output jd_7 : Analog<1>
    output ck_io_0 : Analog<1>
    output ck_io_1 : Analog<1>
    output ck_io_2 : Analog<1>
    output ck_io_3 : Analog<1>
    output ck_io_4 : Analog<1>
    output ck_io_5 : Analog<1>
    output ck_io_6 : Analog<1>
    output ck_io_7 : Analog<1>
    output ck_io_8 : Analog<1>
    output ck_io_9 : Analog<1>
    output ck_io_10 : Analog<1>
    output ck_io_11 : Analog<1>
    output ck_io_12 : Analog<1>
    output ck_io_13 : Analog<1>
    output ck_io_14 : Analog<1>
    output ck_io_15 : Analog<1>
    output ck_io_16 : Analog<1>
    output ck_io_17 : Analog<1>
    output ck_io_18 : Analog<1>
    output ck_io_19 : Analog<1>
    output ck_miso : Analog<1>
    output ck_mosi : Analog<1>
    output ck_ss : Analog<1>
    output ck_sck : Analog<1>
    output ddr_ddr3_addr : UInt<14>
    output ddr_ddr3_ba : UInt<3>
    output ddr_ddr3_ras_n : UInt<1>
    output ddr_ddr3_cas_n : UInt<1>
    output ddr_ddr3_we_n : UInt<1>
    output ddr_ddr3_reset_n : UInt<1>
    output ddr_ddr3_ck_p : UInt<1>
    output ddr_ddr3_ck_n : UInt<1>
    output ddr_ddr3_cke : UInt<1>
    output ddr_ddr3_cs_n : UInt<1>
    output ddr_ddr3_dm : UInt<2>
    output ddr_ddr3_odt : UInt<1>
    output ddr_ddr3_dq : Analog<16>
    output ddr_ddr3_dqs_n : Analog<2>
    output ddr_ddr3_dqs_p : Analog<2>

    inst pll of pll @[artya7.scala 34:19]
    inst platform of RVCSystem @[artya7.scala 44:45]
    inst pad of IOBUF @[Unisim.scala 271:23]
    inst pad_1 of IOBUF @[Unisim.scala 271:23]
    inst pad_2 of IOBUF @[Unisim.scala 271:23]
    inst pad_3 of IOBUF @[Unisim.scala 271:23]
    inst pad_4 of IOBUF @[Unisim.scala 271:23]
    inst pad_5 of IOBUF @[Unisim.scala 271:23]
    inst pad_6 of IOBUF @[Unisim.scala 271:23]
    inst pad_7 of IOBUF @[Unisim.scala 271:23]
    inst platform_jtag_TDI_pad of IOBUF @[Unisim.scala 289:21]
    inst platform_jtag_TMS_pad of IOBUF @[Unisim.scala 289:21]
    inst platform_jtag_TCK_pad of IOBUF @[Unisim.scala 289:21]
    inst pad_8 of IOBUF @[Unisim.scala 271:23]
    inst platform_jtag_TRSTn_pad of IOBUF @[Unisim.scala 289:21]
    inst pullup of PULLUP @[Unisim.scala 384:24]
    inst pullup_1 of PULLUP @[Unisim.scala 384:24]
    inst pullup_2 of PULLUP @[Unisim.scala 384:24]
    inst platform_uart_0_rxd_pad of IOBUF @[Unisim.scala 289:21]
    inst pad_9 of IOBUF @[Unisim.scala 281:21]
    inst platform_spi_0_dq_0_i_spi_dq_0_sync of SynchronizerShiftReg_w1_d3_inArtyA7Top @[ShiftReg.scala 45:23]
    inst platform_spi_0_dq_1_i_spi_dq_1_sync of SynchronizerShiftReg_w1_d3_inArtyA7Top @[ShiftReg.scala 45:23]
    inst platform_spi_0_dq_2_i_spi_dq_2_sync of SynchronizerShiftReg_w1_d3_inArtyA7Top @[ShiftReg.scala 45:23]
    inst platform_spi_0_dq_3_i_spi_dq_3_sync of SynchronizerShiftReg_w1_d3_inArtyA7Top @[ShiftReg.scala 45:23]
    inst pad_10 of IOBUF @[Unisim.scala 271:23]
    inst pad_11 of IOBUF @[Unisim.scala 271:23]
    inst pad_12 of IOBUF @[Unisim.scala 271:23]
    inst pad_13 of IOBUF @[Unisim.scala 271:23]
    inst pad_14 of IOBUF @[Unisim.scala 271:23]
    inst pad_15 of IOBUF @[Unisim.scala 271:23]
    inst platform_i2c_0_scl_in_i2c_scl_sync of SyncResetSynchronizerShiftReg_w1_d3_i1_inArtyA7Top @[ShiftReg.scala 45:23]
    inst platform_i2c_0_sda_in_i2c_sda_sync of SyncResetSynchronizerShiftReg_w1_d3_i1_inArtyA7Top @[ShiftReg.scala 45:23]
    inst pad_16 of IOBUF @[Unisim.scala 271:23]
    inst pad_17 of IOBUF @[Unisim.scala 271:23]
    inst platform_artyA7MIGPorts_0_sys_rst_catcher of ResetCatchAndSync_d3_inArtyA7Top @[ResetCatchAndSync.scala 39:28]
    inst reset_catcher of ResetCatchAndSync_d3_inArtyA7Top @[ResetCatchAndSync.scala 39:28]
    node reset = reset_catcher.io_sync_reset
    node base_pin_o_oe = platform.gpio_0_pins_0_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_o_ie = platform.gpio_0_pins_0_o_ie @[PinCtrl.scala 119:24 120:14]
    node base_pin_1_o_oe = platform.gpio_0_pins_1_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_1_o_ie = platform.gpio_0_pins_1_o_ie @[PinCtrl.scala 119:24 120:14]
    node base_pin_2_o_oe = platform.gpio_0_pins_2_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_2_o_ie = platform.gpio_0_pins_2_o_ie @[PinCtrl.scala 119:24 120:14]
    node base_pin_3_o_oe = platform.gpio_0_pins_3_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_3_o_ie = platform.gpio_0_pins_3_o_ie @[PinCtrl.scala 119:24 120:14]
    node base_pin_4_o_oe = platform.gpio_0_pins_4_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_4_o_ie = platform.gpio_0_pins_4_o_ie @[PinCtrl.scala 119:24 120:14]
    node base_pin_5_o_oe = platform.gpio_0_pins_5_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_5_o_ie = platform.gpio_0_pins_5_o_ie @[PinCtrl.scala 119:24 120:14]
    node base_pin_6_o_oe = platform.gpio_0_pins_6_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_6_o_ie = platform.gpio_0_pins_6_o_ie @[PinCtrl.scala 119:24 120:14]
    node base_pin_7_o_oe = platform.gpio_0_pins_7_o_oe @[PinCtrl.scala 119:24 120:14]
    node base_pin_7_o_ie = platform.gpio_0_pins_7_o_ie @[PinCtrl.scala 119:24 120:14]
    node TDO_as_base_o_oe = platform.jtag_TDO_driven @[artya7.scala 62:29 63:24]
    node spi_dq_0_o_ie = not(platform.spi_0_dq_0_oe) @[SPIPins.scala 30:19]
    node spi_dq_1_o_ie = not(platform.spi_0_dq_1_oe) @[SPIPins.scala 30:19]
    node spi_dq_2_o_ie = not(platform.spi_0_dq_2_oe) @[SPIPins.scala 30:19]
    node spi_dq_3_o_ie = not(platform.spi_0_dq_3_oe) @[SPIPins.scala 30:19]
    node spi_dq_0_o_oe = platform.spi_0_dq_0_oe @[SPIPins.scala 29:16 artya7.scala 82:21]
    node spi_dq_1_o_oe = platform.spi_0_dq_1_oe @[SPIPins.scala 29:16 artya7.scala 82:21]
    node spi_dq_2_o_oe = platform.spi_0_dq_2_oe @[SPIPins.scala 29:16 artya7.scala 82:21]
    node spi_dq_3_o_oe = platform.spi_0_dq_3_oe @[SPIPins.scala 29:16 artya7.scala 82:21]
    node i2c_scl_o_oe = platform.i2c_0_scl_oe @[artya7.scala 115:21 I2CPins.scala 22:21]
    node i2c_sda_o_oe = platform.i2c_0_sda_oe @[artya7.scala 115:21 I2CPins.scala 27:21]
    ddr_ddr3_addr <= platform.artyA7MIGPorts_0_ddr3_addr @[artya7.scala 132:11]
    ddr_ddr3_ba <= platform.artyA7MIGPorts_0_ddr3_ba @[artya7.scala 132:11]
    ddr_ddr3_ras_n <= platform.artyA7MIGPorts_0_ddr3_ras_n @[artya7.scala 132:11]
    ddr_ddr3_cas_n <= platform.artyA7MIGPorts_0_ddr3_cas_n @[artya7.scala 132:11]
    ddr_ddr3_we_n <= platform.artyA7MIGPorts_0_ddr3_we_n @[artya7.scala 132:11]
    ddr_ddr3_reset_n <= platform.artyA7MIGPorts_0_ddr3_reset_n @[artya7.scala 132:11]
    ddr_ddr3_ck_p <= platform.artyA7MIGPorts_0_ddr3_ck_p @[artya7.scala 132:11]
    ddr_ddr3_ck_n <= platform.artyA7MIGPorts_0_ddr3_ck_n @[artya7.scala 132:11]
    ddr_ddr3_cke <= platform.artyA7MIGPorts_0_ddr3_cke @[artya7.scala 132:11]
    ddr_ddr3_cs_n <= platform.artyA7MIGPorts_0_ddr3_cs_n @[artya7.scala 132:11]
    ddr_ddr3_dm <= platform.artyA7MIGPorts_0_ddr3_dm @[artya7.scala 132:11]
    ddr_ddr3_odt <= platform.artyA7MIGPorts_0_ddr3_odt @[artya7.scala 132:11]
    pll.clk_in1 <= CLK100MHZ @[artya7.scala 35:18]
    pll.reset <= not(ck_rst) @[artya7.scala 36:19]
    platform.clock <= pll.clk_out1
    platform.reset <= or(reset, platform.ndreset) @[artya7.scala 45:28]
    platform.jtag_TRSTn <= platform_jtag_TRSTn_pad.O @[artya7.scala 68:28]
    platform.jtag_TCK <= asClock(platform_jtag_TCK_pad.O) @[artya7.scala 61:32]
    platform.jtag_TMS <= platform_jtag_TMS_pad.O @[artya7.scala 60:16]
    platform.jtag_TDI <= platform_jtag_TDI_pad.O @[artya7.scala 59:16]
    platform.gpio_0_pins_0_i_ival <= and(pad.O, base_pin_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_0_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.gpio_0_pins_1_i_ival <= and(pad_1.O, base_pin_1_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_1_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.gpio_0_pins_2_i_ival <= and(pad_2.O, base_pin_2_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_2_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.gpio_0_pins_3_i_ival <= and(pad_3.O, base_pin_3_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_3_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.gpio_0_pins_4_i_ival <= and(pad_4.O, base_pin_4_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_4_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.gpio_0_pins_5_i_ival <= and(pad_5.O, base_pin_5_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_5_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.gpio_0_pins_6_i_ival <= and(pad_6.O, base_pin_6_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_6_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.gpio_0_pins_7_i_ival <= and(pad_7.O, base_pin_7_o_ie) @[Unisim.scala 274:31]
    platform.gpio_0_pins_7_i_po <= UInt<1>("h0") @[PinCtrl.scala 120:14]
    platform.uart_0_rxd <= platform_uart_0_rxd_pad.O @[artya7.scala 76:16]
    platform.i2c_0_scl_in <= platform_i2c_0_scl_in_i2c_scl_sync.io_q @[ShiftReg.scala 48:{24,24}]
    platform.i2c_0_sda_in <= platform_i2c_0_sda_in_i2c_sda_sync.io_q @[ShiftReg.scala 48:{24,24}]
    platform.artyA7MIGPorts_0_sys_clk_i <= asUInt(pll.clk_out2) @[artya7.scala 134:44]
    platform.artyA7MIGPorts_0_clk_ref_i <= asUInt(pll.clk_out3) @[artya7.scala 135:44]
    platform.artyA7MIGPorts_0_aresetn <= pll.locked @[artya7.scala 136:19]
    platform.artyA7MIGPorts_0_sys_rst <= platform_artyA7MIGPorts_0_sys_rst_catcher.io_sync_reset @[artya7.scala 137:19]
    platform.spi_0_dq_0_i <= platform_spi_0_dq_0_i_spi_dq_0_sync.io_q @[ShiftReg.scala 48:{24,24}]
    platform.spi_0_dq_1_i <= platform_spi_0_dq_1_i_spi_dq_1_sync.io_q @[ShiftReg.scala 48:{24,24}]
    platform.spi_0_dq_2_i <= platform_spi_0_dq_2_i_spi_dq_2_sync.io_q @[ShiftReg.scala 48:{24,24}]
    platform.spi_0_dq_3_i <= platform_spi_0_dq_3_i_spi_dq_3_sync.io_q @[ShiftReg.scala 48:{24,24}]
    platform.otherclock <= asClock(UInt<1>("h0")) @[artya7.scala 142:36]
    pad.I <= platform.gpio_0_pins_0_o_oval @[PinCtrl.scala 119:24 120:14]
    pad.T <= not(base_pin_o_oe) @[Unisim.scala 273:19]
    pad_1.I <= platform.gpio_0_pins_1_o_oval @[PinCtrl.scala 119:24 120:14]
    pad_1.T <= not(base_pin_1_o_oe) @[Unisim.scala 273:19]
    pad_2.I <= platform.gpio_0_pins_2_o_oval @[PinCtrl.scala 119:24 120:14]
    pad_2.T <= not(base_pin_2_o_oe) @[Unisim.scala 273:19]
    pad_3.I <= platform.gpio_0_pins_3_o_oval @[PinCtrl.scala 119:24 120:14]
    pad_3.T <= not(base_pin_3_o_oe) @[Unisim.scala 273:19]
    pad_4.I <= platform.gpio_0_pins_4_o_oval @[PinCtrl.scala 119:24 120:14]
    pad_4.T <= not(base_pin_4_o_oe) @[Unisim.scala 273:19]
    pad_5.I <= platform.gpio_0_pins_5_o_oval @[PinCtrl.scala 119:24 120:14]
    pad_5.T <= not(base_pin_5_o_oe) @[Unisim.scala 273:19]
    pad_6.I <= platform.gpio_0_pins_6_o_oval @[PinCtrl.scala 119:24 120:14]
    pad_6.T <= not(base_pin_6_o_oe) @[Unisim.scala 273:19]
    pad_7.I <= platform.gpio_0_pins_7_o_oval @[PinCtrl.scala 119:24 120:14]
    pad_7.T <= not(base_pin_7_o_oe) @[Unisim.scala 273:19]
    platform_jtag_TDI_pad.I <= UInt<1>("h0") @[Unisim.scala 290:14]
    platform_jtag_TDI_pad.T <= UInt<1>("h1") @[Unisim.scala 291:14]
    platform_jtag_TMS_pad.I <= UInt<1>("h0") @[Unisim.scala 290:14]
    platform_jtag_TMS_pad.T <= UInt<1>("h1") @[Unisim.scala 291:14]
    platform_jtag_TCK_pad.I <= UInt<1>("h0") @[Unisim.scala 290:14]
    platform_jtag_TCK_pad.T <= UInt<1>("h1") @[Unisim.scala 291:14]
    pad_8.I <= platform.jtag_TDO_data @[artya7.scala 62:29 64:26]
    pad_8.T <= not(TDO_as_base_o_oe) @[Unisim.scala 273:19]
    platform_jtag_TRSTn_pad.I <= UInt<1>("h0") @[Unisim.scala 290:14]
    platform_jtag_TRSTn_pad.T <= UInt<1>("h1") @[Unisim.scala 291:14]
    platform_uart_0_rxd_pad.I <= UInt<1>("h0") @[Unisim.scala 290:14]
    platform_uart_0_rxd_pad.T <= UInt<1>("h1") @[Unisim.scala 291:14]
    pad_9.I <= platform.uart_0_txd @[Unisim.scala 282:14]
    pad_9.T <= UInt<1>("h0") @[Unisim.scala 283:14]
    platform_spi_0_dq_0_i_spi_dq_0_sync.clock <= pll.clk_out1
    platform_spi_0_dq_0_i_spi_dq_0_sync.io_d <= and(pad_11.O, spi_dq_0_o_ie) @[Unisim.scala 274:31]
    platform_spi_0_dq_1_i_spi_dq_1_sync.clock <= pll.clk_out1
    platform_spi_0_dq_1_i_spi_dq_1_sync.io_d <= and(pad_12.O, spi_dq_1_o_ie) @[Unisim.scala 274:31]
    platform_spi_0_dq_2_i_spi_dq_2_sync.clock <= pll.clk_out1
    platform_spi_0_dq_2_i_spi_dq_2_sync.io_d <= and(pad_14.O, spi_dq_2_o_ie) @[Unisim.scala 274:31]
    platform_spi_0_dq_3_i_spi_dq_3_sync.clock <= pll.clk_out1
    platform_spi_0_dq_3_i_spi_dq_3_sync.io_d <= and(pad_15.O, spi_dq_3_o_ie) @[Unisim.scala 274:31]
    pad_10.I <= platform.spi_0_cs_0 @[PinCtrl.scala 60:17 artya7.scala 82:21]
    pad_10.T <= UInt<1>("h0") @[Unisim.scala 273:19]
    pad_11.I <= platform.spi_0_dq_0_o @[PinCtrl.scala 60:17 artya7.scala 82:21]
    pad_11.T <= not(spi_dq_0_o_oe) @[Unisim.scala 273:19]
    pad_12.I <= platform.spi_0_dq_1_o @[PinCtrl.scala 60:17 artya7.scala 82:21]
    pad_12.T <= not(spi_dq_1_o_oe) @[Unisim.scala 273:19]
    pad_13.I <= platform.spi_0_sck @[PinCtrl.scala 60:17 artya7.scala 82:21]
    pad_13.T <= UInt<1>("h0") @[Unisim.scala 273:19]
    pad_14.I <= platform.spi_0_dq_2_o @[PinCtrl.scala 60:17 artya7.scala 82:21]
    pad_14.T <= not(spi_dq_2_o_oe) @[Unisim.scala 273:19]
    pad_15.I <= platform.spi_0_dq_3_o @[PinCtrl.scala 60:17 artya7.scala 82:21]
    pad_15.T <= not(spi_dq_3_o_oe) @[Unisim.scala 273:19]
    platform_i2c_0_scl_in_i2c_scl_sync.clock <= pll.clk_out1
    platform_i2c_0_scl_in_i2c_scl_sync.reset <= reset_catcher.io_sync_reset @[artya7.scala 118:47]
    platform_i2c_0_scl_in_i2c_scl_sync.io_d <= pad_16.O @[Unisim.scala 274:31]
    platform_i2c_0_sda_in_i2c_sda_sync.clock <= pll.clk_out1
    platform_i2c_0_sda_in_i2c_sda_sync.reset <= reset_catcher.io_sync_reset @[artya7.scala 118:47]
    platform_i2c_0_sda_in_i2c_sda_sync.io_d <= pad_17.O @[Unisim.scala 274:31]
    pad_16.I <= platform.i2c_0_scl_out @[artya7.scala 115:21 PinCtrl.scala 60:17]
    pad_16.T <= not(i2c_scl_o_oe) @[Unisim.scala 273:19]
    pad_17.I <= platform.i2c_0_sda_out @[artya7.scala 115:21 PinCtrl.scala 60:17]
    pad_17.T <= not(i2c_sda_o_oe) @[Unisim.scala 273:19]
    platform_artyA7MIGPorts_0_sys_rst_catcher.clock <= pll.clk_out2
    platform_artyA7MIGPorts_0_sys_rst_catcher.reset <= not(pll.locked) @[artya7.scala 137:61]
    reset_catcher.clock <= pll.clk_out1
    reset_catcher.reset <= platform.artyA7MIGPorts_0_ui_clk_sync_rst
    attach (pad.IO, led_0)
    attach (pad_1.IO, led_1)
    attach (pad_2.IO, led_2)
    attach (pad_3.IO, led_3)
    attach (pad_4.IO, sw_0)
    attach (pad_5.IO, sw_1)
    attach (pad_6.IO, sw_2)
    attach (pad_7.IO, sw_3)
    attach (platform_jtag_TDI_pad.IO, jd_4, pullup.O)
    attach (platform_jtag_TMS_pad.IO, jd_5, pullup_1.O)
    attach (platform_jtag_TCK_pad.IO, jd_2)
    attach (pad_8.IO, jd_0)
    attach (platform_jtag_TRSTn_pad.IO, jd_6, pullup_2.O)
    attach (platform_uart_0_rxd_pad.IO, uart_txd_in)
    attach (pad_9.IO, uart_rxd_out)
    attach (pad_10.IO, ja_0)
    attach (pad_11.IO, ja_1)
    attach (pad_12.IO, ja_2)
    attach (pad_13.IO, ja_3)
    attach (pad_14.IO, ja_4)
    attach (pad_15.IO, ja_5)
    attach (pad_16.IO, ck_io_0)
    attach (pad_17.IO, ck_io_1)
    attach (ddr_ddr3_dq, platform.artyA7MIGPorts_0_ddr3_dq)
    attach (ddr_ddr3_dqs_n, platform.artyA7MIGPorts_0_ddr3_dqs_n)
    attach (ddr_ddr3_dqs_p, platform.artyA7MIGPorts_0_ddr3_dqs_p)

  extmodule plusarg_reader :
    output out : UInt<32>
    defname = plusarg_reader
    parameter FORMAT = "tilelink_timeout=%d"
    parameter DEFAULT = 0
    parameter WIDTH = 32

  extmodule plusarg_reader_58 :
    output out : UInt<32>
    defname = plusarg_reader
    parameter FORMAT = "max_core_cycles=%d"
    parameter DEFAULT = 0
    parameter WIDTH = 32

  extmodule plusarg_reader_83 :
    output out : UInt<32>
    defname = plusarg_reader
    parameter FORMAT = "uart_tx=%d"
    parameter DEFAULT = 1
    parameter WIDTH = 32

  extmodule arty100tmig :
    output ddr3_addr : UInt<14>
    output ddr3_ba : UInt<3>
    output ddr3_ras_n : UInt<1>
    output ddr3_cas_n : UInt<1>
    output ddr3_we_n : UInt<1>
    output ddr3_reset_n : UInt<1>
    output ddr3_ck_p : UInt<1>
    output ddr3_ck_n : UInt<1>
    output ddr3_cke : UInt<1>
    output ddr3_cs_n : UInt<1>
    output ddr3_dm : UInt<2>
    output ddr3_odt : UInt<1>
    output ddr3_dq : Analog<16>
    output ddr3_dqs_n : Analog<2>
    output ddr3_dqs_p : Analog<2>
    input sys_clk_i : UInt<1>
    input clk_ref_i : UInt<1>
    output ui_clk : Clock
    output ui_clk_sync_rst : UInt<1>
    output mmcm_locked : UInt<1>
    input aresetn : UInt<1>
    output init_calib_complete : UInt<1>
    input sys_rst : UInt<1>
    input app_sr_req : UInt<1>
    input app_ref_req : UInt<1>
    input app_zq_req : UInt<1>
    output app_sr_active : UInt<1>
    output app_ref_ack : UInt<1>
    output app_zq_ack : UInt<1>
    input s_axi_awid : UInt<4>
    input s_axi_awaddr : UInt<30>
    input s_axi_awlen : UInt<8>
    input s_axi_awsize : UInt<3>
    input s_axi_awburst : UInt<2>
    input s_axi_awlock : UInt<1>
    input s_axi_awcache : UInt<4>
    input s_axi_awprot : UInt<3>
    input s_axi_awqos : UInt<4>
    input s_axi_awvalid : UInt<1>
    output s_axi_awready : UInt<1>
    input s_axi_wdata : UInt<64>
    input s_axi_wstrb : UInt<8>
    input s_axi_wlast : UInt<1>
    input s_axi_wvalid : UInt<1>
    output s_axi_wready : UInt<1>
    input s_axi_bready : UInt<1>
    output s_axi_bid : UInt<4>
    output s_axi_bresp : UInt<2>
    output s_axi_bvalid : UInt<1>
    input s_axi_arid : UInt<4>
    input s_axi_araddr : UInt<30>
    input s_axi_arlen : UInt<8>
    input s_axi_arsize : UInt<3>
    input s_axi_arburst : UInt<2>
    input s_axi_arlock : UInt<1>
    input s_axi_arcache : UInt<4>
    input s_axi_arprot : UInt<3>
    input s_axi_arqos : UInt<4>
    input s_axi_arvalid : UInt<1>
    output s_axi_arready : UInt<1>
    input s_axi_rready : UInt<1>
    output s_axi_rid : UInt<4>
    output s_axi_rdata : UInt<64>
    output s_axi_rresp : UInt<2>
    output s_axi_rlast : UInt<1>
    output s_axi_rvalid : UInt<1>
    output device_temp : UInt<12>
    defname = arty100tmig

  extmodule MKV_CRYPTO_TOP :
    input clk : Clock
    input rst : UInt<1>
    input start : UInt<1>
    input key_master : UInt<256>
    output done_key_debug : UInt<1>
    input sel_crypt : UInt<1>
    input data_in : UInt<128>
    output done : UInt<1>
    output data_out : UInt<128>
    defname = MKV_CRYPTO_TOP

  extmodule MyBootROM :
    input clock : Clock
    input address : UInt<12>
    input oe : UInt<1>
    input me : UInt<1>
    output q : UInt<32>
    defname = MyBootROM

  extmodule data_arrays_0_ext :
    input RW0_addr : UInt<8>
    input RW0_en : UInt<1>
    input RW0_clk : Clock
    input RW0_wmode : UInt<1>
    input RW0_wdata : UInt<32>
    output RW0_rdata : UInt<32>
    input RW0_wmask : UInt<4>
    defname = data_arrays_0_ext

  extmodule tag_array_ext :
    input RW0_addr : UInt<4>
    input RW0_en : UInt<1>
    input RW0_clk : Clock
    input RW0_wmode : UInt<1>
    input RW0_wdata : UInt<24>
    output RW0_rdata : UInt<24>
    defname = tag_array_ext

  extmodule tag_array_0_ext :
    input RW0_addr : UInt<4>
    input RW0_en : UInt<1>
    input RW0_clk : Clock
    input RW0_wmode : UInt<1>
    input RW0_wdata : UInt<23>
    output RW0_rdata : UInt<23>
    input RW0_wmask : UInt<1>
    defname = tag_array_0_ext

  extmodule data_arrays_0_0_ext :
    input RW0_addr : UInt<8>
    input RW0_en : UInt<1>
    input RW0_clk : Clock
    input RW0_wmode : UInt<1>
    input RW0_wdata : UInt<32>
    output RW0_rdata : UInt<32>
    input RW0_wmask : UInt<1>
    defname = data_arrays_0_0_ext

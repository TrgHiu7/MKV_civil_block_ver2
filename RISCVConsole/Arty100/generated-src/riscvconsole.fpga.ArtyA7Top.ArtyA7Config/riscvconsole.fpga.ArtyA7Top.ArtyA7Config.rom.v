// This file created by /home/tronghieu/RISCVConsole/hardware/vlsi_rom_gen_fpga

module MyBootROM(
  input clock,
  input oe,
  input me,
  input [11:0] address,
  output [31:0] q
);
  reg [31:0] out;
  reg [31:0] rom [0:4095];


  initial begin: init_and_load
    integer i;
    // 256 is the maximum length of $readmemh filename supported by Verilator
    reg [255*8-1:0] path;
`ifdef RANDOMIZE
  `ifdef RANDOMIZE_MEM_INIT
    for (i = 0; i < 4096; i = i + 1) begin
      rom[i] = {1{$random}};
    end
  `endif
`endif
    $readmemh("/home/tronghieu/RISCVConsole/fpga/ArtyA7100T/generated-src/riscvconsole.fpga.ArtyA7Top.ArtyA7Config/sdboot.hex", rom);
  end


  always @(posedge clock) begin
    if (me) begin
      out <= rom[address];
    end
  end

  assign q = oe ? out : 32'bZ;

endmodule


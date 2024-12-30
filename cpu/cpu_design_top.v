`include "cpu_design_cpu.v"
`include "cpu_design_imem.v"
`include "cpu_design_dmem.v"

module top(input  clk, reset );

  
	//internal wires
	wire [31:0] PC, Instr, ReadData;
    wire  [31:0] WriteData, DataAdr;
	wire  MemWrite;
  
	// instantiate cpu and memories
	cpu cpu(clk, reset, PC, Instr, MemWrite, DataAdr,WriteData, ReadData);
	imem imem(PC, Instr);
	dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData);
  
endmodule
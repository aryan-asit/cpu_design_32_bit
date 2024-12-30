`include "cpu_design_extender.v"
`include "cpu_design_alu.v"
`include "cpu_design_regfile.v"
`include "cpu_design_mux.v"
`include "cpu_design_flop2.v"
`include "cpu_design_adder.v"

module datapath(input clk,reset,
input [1:0] Regsrc,
input Regwrite,
input [1:0] ImmSrc,
input ALUSrc,
input [1:0] ALUControl,
input MemtoReg,
input PCSrc,
output reg [3:0] ALUFlags,
output reg [31:0] PC,
input [31:0] Instr,
output reg [31:0] ALUResult, WriteData,
input [31:0] ReadData);

wire [31:0] PCNext, PCPlus4, PCPlus8;
wire [31:0] ExtImm, SrcA, SrcB,Result;
wire [3:0] RA1, RA2;

//pc logic 
    mux2 #(32) pcmux(.y(PVNext),.d0(PCPlus4),.d1(Result),.s(PCSrc));
    flopr #(32) pcreg(clk, reset, PCNext, PC);//#(32) i have doubt
    adder #(32) pcadd1(PC,32'b100,PCPlus4);//#(32) i have doubt
    adder #(32) pcadd2(PCPlus4,32'b100,PCPlus8);//#(32) i have doubt

//register file logic
    mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
    mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], Regsrc[1], RA2);
    regfile rf(clk,RegWrite, RA1,RA2, Instr[15:12], Result,PCPlus8,SrcA, WriteData);
    mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
    extend ext(Instr[23:0], Immsrc, ExtImm);

//ALU logic
    mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
    ALU alu (SrcA, SrcB, ALUResult, ALUFlags);

endmodule
module dmem(input clk,we,
            input [31:0] a,wd,
            output reg [31:0] rd);

reg [31:0] RAM[63:0]; // 64 location of each 32 bits
assign rd = RAM[a[31:2]]; //word aligned

always@(posedge clk)
    if (we) RAM[a[31:2]] <= wd; // <= non blocking assign.
endmodule
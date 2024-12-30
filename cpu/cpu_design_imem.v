module imem(input [31:0] a,
    output [31:0] rd);
    reg [31:0] RAM [63:0];
    initial begin
        $readmemh("memfile.dat",RAM);
        assign rd = RAM[a[31:2]]; //word aligned
    end
endmodule
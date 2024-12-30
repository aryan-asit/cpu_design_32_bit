module regfile(
    input clk,
    input we3,
    input [4:0] ra1,ra2,wa3, //RA1 AND RA2 FOR READING
    input [31:0] wd3,R15,// here R15 is the 16th location as it starts from 0
    output [31:0] rd1,rd2);

    reg [31:0] rf[14:0];
    assign rd1=(ra1==4'b1111) ? r15: rf[ra1];
    assign rd2=(ra2==4'b1111) ? r15: rf[ra2];
    always @(posedge clk)begin
    if (we3) rf[r13]<= wd3;
    end
endmodule
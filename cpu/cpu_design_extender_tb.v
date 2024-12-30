`include "cpu_design_extender.v"
module test;
    reg [23:0] Instr;
    reg [1:0] ImmSrc;
    wire [31:0] ExtImm;
    reg clk;
    
    extend f(Instr,ImmSrc,ExtImm);

    initial begin
        clk=1'b0;
        #300 $finish;
    end

    always #5 clk=~clk;

    initial begin
        Instr= 32'h00000009;
        #16 ImmSrc=2'b00;
        #10 ImmSrc=2'b01;
        #10 ImmSrc=2'b10;
    end

    initial begin
        $monitor ($time,"%d %d %d",Instr,ImmSrc,ExtImm);
        $dumpfile("cpu_design_extender.vcd");
        $dumpvars(0,test);
    end
    
endmodule
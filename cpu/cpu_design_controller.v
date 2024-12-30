`include "cpu_design_flop.v"
module condlogic (input logic clk,reset,
    input [3:0] cond,
    input [3:0] ALUFlags,
    input [1:0] FlagW,
    input PCS,RegW,MemW,
    output reg PCSrc,RegWrite,MemWrite);
    

    //internal wires
    wire [1:0] FlagWrite;
    wire [3:0] Flags;
    reg condEx;

    flopenr #(.WIDTH(2)) flagreg1(clk,reset,flagWrite[1],ALUFlags[3:2],Flags[3:2]);
    flopenr #(.WIDTH(2)) flagreg0(clk,reset,flagWrite[0],ALUFlags[1:0],Flags[1:0]);
    // write controls are conditional

    condcheck cc(Cond, Flags, CondEx);
    assign FlagWrite = FlagW & {2{condEx}};
    assign RegWrite = RegW & CondEx;
    assign MemWrite = MemW & CondEx;
    assign PCSrc = PCS & CondEx;

endmodule

module condcheck (input [3:0] cond,
    input [3:0] Flags,
    output reg CondEx);
    wire neg,zero,carry,overflow,ge;
    assign {neg,zero,carry,overflow} = Flags;
    //assign ge = (neg == overflow);
    assign ge= ~(neg^overflow);
    always@(*)
        case(cond)
        4'b0000: CondEx=zero; //EQ  ~ Equal
        4'b0001: CondEx=~zero; //NE ~Not equal 
        4'b0010: CondEx=carry; //CS ~carry 
        4'b0011: CondEx=~carry; //CC ~Not carry 
        4'b0100: CondEx=neg; //MI ~Negative
        4'b0101: CondEx=~neg; //PL ~positive
        4'b0110: CondEx=overflow; //VS ~overflow
        4'b0111: CondEx=~overflow; //Vc ~Not overflow
        4'b1000: CondEx=carry &~zero; //HI ~unsigned higher
        4'b1001: CondEx=~(carry &~zero); //LS ~unsigned lower
        4'b1010: CondEx=ge; //GE ~signed greater than or equal
        4'b1011: CondEx=~ge; //LT ~signed less than
        4'b1100: CondEx=~zero & ge; //GT ~signed greater than
        4'b1101: CondEx=~(~zero & ge); //LE ~signed less than or equal zero
        4'b1110: CondEx=1`b1; //Always 1
        default: CondEx=1`bx; //undefined
        endcase
endmodule
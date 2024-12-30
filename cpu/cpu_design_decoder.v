module decoder (
    input [1:0] Op,
    input [5:0] Funct,
    input [3:0] Rd,
    output reg [1:0] FlagW,
    output reg PCS,RegW,MemW,
    output reg MemtoReg,ALUSrc,
    output reg [1:0] ImmSrc,RegSrc,ALUControl
);
    //internal wires
    reg Branch,ALUOp;
    reg [9:0] controls;

    assign {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp}=controls;//concatinating all the ports to control

    always @(*) begin
        casex (Op)
            2'b00:if (Funct[5]) controls = 10'b0001001001; //data processing immediate
                  else controls=10'b0000001001; //data processing register
            2'b01:if (Funct[0]) controls= 10'b0101011000;//LDR
                  else controls=10'b0011010100;//STR
            2'b10:controls=10'b1001100010;//B
            default: controls=10'bx;
        endcase
    end

    //ALU Decoder
    always@(*)begin
        if (ALUOp)begin
            case(Funct[4:1])
                4'b0100:ALUControl=2'b00;//ADD
                4'b0010:ALUControl=2'b01;//SUB
                4'b0000:ALUControl=2'b10;//AND 
                4'b1100:ALUControl=2'b11;//ORR
                default: ALUControl=2'bxx;//dontcare
            endcase
            //update flags if s bits is set (carry and overflow)
            FlagW[1] = Funct[0];
            FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01); 
        end

        else begin
            ALUControl=2'b00; // add for non-dataprocessing inst
            FlagW=2'b00;//don't update flags
        end
    end

assign PCS = ((RD == 4'b1111) & RegW) | Branch;
endmodule
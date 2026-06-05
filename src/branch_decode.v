module branch_decode (
    input [2:0] funct3E,
    input zeroE,
    input ALUResultE_0, //bit 0 of ALUResult for SLT since for SLT,only one bit result that is zero-extended
    input BranchE, JumpE,JalrE,
    input [31:0] ReadData1E,immExtendedE,PCE,
    output PCSrcE,
    output [31:0] PCTargetE
);

    reg branchTaken;
    always@(*) begin
        case(funct3E)
            3'b000: branchTaken = zeroE;
            3'b001: branchTaken = ~zeroE;
            3'b100: branchTaken = ALUResultE_0;
            3'b101: branchTaken = ~ALUResultE_0;
            3'b110: branchTaken = ALUResultE_0;
            3'b111: branchTaken = ~ALUResultE_0;
            default: branchTaken = 1'b0;
        endcase
    end
    assign PCSrcE = (BranchE && branchTaken)||JumpE;
    assign PCTargetE = JalrE?(ReadData1E+immExtendedE) : (PCE+immExtendedE);
    
endmodule

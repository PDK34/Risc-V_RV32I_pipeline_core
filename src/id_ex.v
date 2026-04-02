module id_ex (
    input clk,rst,flush,
    input [31:0] ReadData1D,ReadData2D,
    input [31:0] PCD, PCPlus4D,
    input [31:0] immExtendedD, 
    input [4:0] RdD,Rs1D,Rs2D,
    input [2:0] ALUControlD,
    input ALUSrcD,JumpD,BranchD,RegWriteD,MemWriteD,
    input [1:0]ResultSrcD,
    output reg [31:0] ReadData1E,ReadData2E,
    output reg [31:0] PCE, PCPlus4E,
    output reg [31:0] immExtendedE, 
    output reg [4:0] RdE,Rs1E,Rs2E,
    output reg [2:0] ALUControlE,
    output reg ALUSrcE,JumpE,BranchE,RegWriteE,MemWriteE,
    output reg [1:0]ResultSrcE ,

    input [2:0] funct3D,
    output reg [2:0] funct3E
);
    always@(posedge clk)begin
        if(rst)begin
            ReadData1E <= 32'b0; ReadData2E <= 32'b0;
            PCE<=32'b0; PCPlus4E<=32'b0; immExtendedE<=32'b0;
            RdE<=5'b0; Rs2E<=5'b0; Rs1E<=5'b0;  ALUControlE<=3'b0;
            ALUSrcE<=1'b0; JumpE <= 1'b0; BranchE<=1'b0; RegWriteE<=1'b0; MemWriteE<=1'b0; 
            ResultSrcE<=2'b0; funct3E <= 3'b0;   
        end
        else if(flush)begin
            ReadData1E <= 32'b0; ReadData2E <= 32'b0;
            PCE<=32'b0; PCPlus4E<=32'b0; immExtendedE<=32'b0;
            RdE<=5'b0; Rs2E<=5'b0; Rs1E<=5'b0;  ALUControlE<=3'b0;
            ALUSrcE<=1'b0; JumpE <= 1'b0; BranchE<=1'b0; RegWriteE<=1'b0; MemWriteE<=1'b0; 
            ResultSrcE<=2'b0; funct3E <= 3'b0;    
        end
        else begin
            ReadData1E <= ReadData1D; ReadData2E <= ReadData2D;
            PCE<=PCD; PCPlus4E<=PCPlus4D; immExtendedE<=immExtendedD;
            RdE<=RdD; Rs2E<=Rs2D; Rs1E<=Rs1D;  ALUControlE<=ALUControlD;
            ALUSrcE<=ALUSrcD; JumpE <= JumpD; BranchE<=BranchD; RegWriteE<=RegWriteD; MemWriteE<=MemWriteD; 
            ResultSrcE<=ResultSrcD; funct3E <= funct3D;   
        end
    end
  
endmodule

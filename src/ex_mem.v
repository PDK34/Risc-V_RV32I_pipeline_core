module ex_mem (
    input clk,rst,
    input [31:0] ALUResultE,
    input [1:0] ResultSrcE,
    input RegWriteE,MemWriteE,
    input [31:0] writeDataE,
    input [31:0] PCPlus4E,
    input [4:0] RdE,
    
    output reg [31:0] ALUResultM,
    output reg [1:0] ResultSrcM,
    output reg RegWriteM,MemWriteM,
    output reg [31:0] writeDataM,
    output reg [31:0] PCPlus4M,
    output reg [4:0] RdM
);

always @(posedge clk) begin
    if(rst)begin
        ALUResultM <= 32'b0; ResultSrcM<=2'b0;
        RegWriteM<=1'b0; MemWriteM<=1'b0;
        writeDataM<=32'b0; PCPlus4M<=32'b0;
        RdM <= 32'b0;
    end
    else begin
        ALUResultM <= ALUResultE; ResultSrcM<=ResultSrcE;
        RegWriteM<=RegWriteE; MemWriteM<=MemWriteE;
        writeDataM<=writeDataE; PCPlus4M<=PCPlus4E;
        RdM <= RdE;
    end
end
    
endmodule

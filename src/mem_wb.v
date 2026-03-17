module mem_wb (
    input clk,rst,
    input [1:0] ResultSrcM,
    input RegWriteM,
    input [31:0] ALUResultM,
    input [31:0] memReadDataM,
    input [31:0] PCPlus4M,
    input [4:0] RdM,

    output reg [1:0] ResultSrcW,
    output reg RegWriteW,
    output reg [31:0] ALUResultW,
    output reg [31:0] memReadDataW,
    output reg [31:0] PCPlus4W,
    output reg [4:0] RdW
);
    always @(posedge clk) begin
        if (rst) begin
            ResultSrcW<=2'b0; RegWriteW<=1'b0;
            ALUResultW<=32'b0; memReadDataW<=32'b0; PCPlus4W<=32'b0;
            RdW<=5'b0;
        end
        else begin 
            ResultSrcW<=ResultSrcM; RegWriteW<=RegWriteM;
            ALUResultW<=ALUResultM; memReadDataW<=memReadDataM; PCPlus4W<=PCPlus4M;
            RdW<=RdM;
        end
    end
endmodule

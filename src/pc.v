
module pc(
    input clk,enable,rst,
    input PCSrcE,
    input [31:0] PCTargetE,
    output reg [31:0] PCF,
    output [31:0] PCPlus4F
    );

    wire [31:0] PCFnext;
    assign PCPlus4F = PCF + 32'd4;

    assign PCFnext = (PCSrcE == 1'b0)? PCPlus4F : PCTargetE;

    always@(posedge clk)begin
        
        if(rst)begin
            PCF <= 32'b0;
        end
        
        else begin
            if(enable)begin
                PCF <= PCFnext;
            end

        end
    end

endmodule

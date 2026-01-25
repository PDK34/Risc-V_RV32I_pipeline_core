module if_id (
    input clk,rst,enable,flush,
    input [31:0] instrF,PCF,PCPlus4F,
    output reg [31:0] instrD , PCD , PCPlus4D
);
    always @(posedge clk) begin
        if (rst) begin
            instrD <= 32'b0;
            PCPlus4D <= 32'b0;
            PCD<= 32'b0;
        end

        else if (flush) begin
            instrD <= 32'b0;
            PCPlus4D <= 32'b0;
            PCD<= 32'b0;
        end
        else begin
            if(enable)begin
                instrD <= instrF;
                PCD <= PCF;
                PCPlus4D <= PCPlus4F;
            end
        end
    end
endmodule

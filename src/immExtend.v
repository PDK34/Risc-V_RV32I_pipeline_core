module immExtend (
    input [2:0] immSrc,
    input [31:0] instrD,
    output reg [31:0] immExtendedD
);
    always @(*) begin
        case (immSrc)
            3'd0 : immExtendedD = {{20{instrD[31]}} , instrD[31:20]}; //I-type
            3'd1 : immExtendedD = {{20{instrD[31]}} , instrD[31:25] , instrD[11:7]}; //Store-type
            3'd2 : immExtendedD = {{20{instrD[31]}} , instrD[7] , instrD[30:25] , instrD[11:8] , 1'b0}; //B-type
            3'd3 : immExtendedD = {{12{instrD[31]}} , instrD[19:12] , instrD[20] , instrD[30:21] , 1'b0}; //J-type
            3'd4 : immExtendedD = {instrD[31:12],12'b0} ; //U-type
            default: immExtendedD = 32'b0;
        endcase
    end
    
endmodule

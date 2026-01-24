module alu (
    input [31:0] srcAE,srcBE,
    input [2:0] ALUcontrolE,
    output reg [31:0] ALUResultE,
    output zeroE
);

    localparam ADD = 3'd1,
               SUB = 3'd2,
               AND = 3'd3,
               OR  = 3'd4,
               SLT = 3'd5;

    always@(*)begin
        ALUResultE = 32'b0;
        case(ALUcontrolE)
            ADD : ALUResultE = srcAE + srcBE;
            SUB : ALUResultE = srcAE - srcBE;
            AND : ALUResultE = srcAE & srcBE;
            OR  : ALUResultE = srcAE | srcBE;
            SLT : ALUResultE = ($signed(srcAE) < $signed(srcBE)) ? 32'd1 : 32'd0;      
        
    end
    assign zeroE = (ALUResultE == 32'd0)? 1'b1 : 1'b0;
    
endmodule

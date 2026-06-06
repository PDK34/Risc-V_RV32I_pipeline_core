module alu (
    input [31:0] srcAE,srcBE,
    input [3:0] ALUcontrolE,
    output reg [31:0] ALUResultE,
    output zeroE
);

    localparam ADD = 4'd0,
               SUB = 4'd1,
               AND = 4'd2,
               OR  = 4'd3,
               SLT = 4'd4,
               XOR = 4'd5,
               SLL = 4'd6,
               SRL = 4'd7,
               SRA = 4'd8,
               SLTU = 4'd9;
               
    wire signed [31:0] srcAE_signed = srcAE;

    always@(*)begin
        ALUResultE = 32'b0;
        case(ALUcontrolE)
            ADD : ALUResultE = srcAE + srcBE;
            SUB : ALUResultE = srcAE - srcBE;
            AND : ALUResultE = srcAE & srcBE;
            OR  : ALUResultE = srcAE | srcBE;
            SLT : ALUResultE = ($signed(srcAE) < $signed(srcBE)) ? 32'd1 : 32'd0;
            XOR : ALUResultE = srcAE^srcBE;
            SLL : ALUResultE = srcAE << srcBE[4:0];
            SRL : ALUResultE = srcAE >> srcBE[4:0];
            SRA : ALUResultE = srcAE_signed >>> srcBE[4:0];
            SLTU : ALUResultE = srcAE < srcBE ? 32'd1 : 32'd0;
        endcase
    end
    assign zeroE = (ALUResultE == 32'd0)? 1'b1 : 1'b0;
    
endmodule

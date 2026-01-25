`timescale 1ns/1ps

module alu_tb;

    reg [31:0] srcAE,srcBE;
    reg [2:0] ALUcontrolE;
    wire [31:0] ALUResultE;
    wire zeroE;

    alu dut(
        .srcAE(srcAE),
        .srcBE(srcBE),
        .ALUcontrolE(ALUcontrolE),
        .ALUResultE(ALUResultE),
        .zeroE(zeroE)
    );

    initial begin
        srcAE = 32'b0; srcBE = 32'b0;
        ALUcontrolE = 3'b0;

        #10
        srcAE = 32'd10; srcBE = 32'd5; //ADD
        #10 ALUcontrolE = 3'd1;  //SUB

        #10 ALUcontrolE = 3'd2;  //AND
        #10 ALUcontrolE = 3'd3;  //OR
        #10 ALUcontrolE = 3'd4;  //SLT(signed)
        #10 srcAE = -32'd1; ALUcontrolE = 3'd4; //SLT 
        #10 srcAE = 32'd8; srcBE = 32'd8; ALUcontrolE = 3'd1; //Zero check

        #10 $stop;

    end

endmodule


`timescale 1ns/1ps

module hazard_unit_tb;

    reg [4:0] Rs1E,Rs2E,RdM,RdW,RdE,Rs1D,Rs2D;
    reg RegWriteM,RegWriteW;
    reg [1:0] ResultSrcE;
    reg PCSrcE;

    wire [1:0] forwardAE,forwardBE;
    wire StallF,StallD,FlushE,FlushD;

    hazard_unit dut(
        .Rs1E(Rs1E),.Rs2E(Rs2E),.RdM(RdM),.RdW(RdW),
        .RegWriteM(RegWriteM),.RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),.RdE(RdE),.Rs1D(Rs1D),.Rs2D(Rs2D),
        .PCSrcE(PCSrcE),
        .forwardAE(forwardAE),.forwardBE(forwardBE),
        .StallF(StallF),.StallD(StallD),.FlushE(FlushE),.FlushD(FlushD)
    );

    initial begin
        // init
        Rs1E=0;Rs2E=0;RdM=0;RdW=0;RdE=0;Rs1D=0;Rs2D=0;
        RegWriteM=0;RegWriteW=0;ResultSrcE=0;PCSrcE=0;
        #10;

        // MEM forward to A
        Rs1E=5'd3; RdM=5'd3; RegWriteM=1;
        #10; // expect forwardAE=2'b10

        // WB forward to A
        Rs1E=5'd3; RdM=5'd7; RdW=5'd3; RegWriteW=1;
        #10; // expect forwardAE=2'b01

        // no forward (x0)
        Rs1E=5'd0; RdM=5'd0; RegWriteM=1;
        #10; // expect forwardAE=2'b00

        // lw stall
        Rs1E=0;Rs2E=0;RdM=0;RdW=0;RegWriteM=0;RegWriteW=0;
        ResultSrcE=2'b01; RdE=5'd5; Rs1D=5'd5;
        #10; // expect StallF=1,StallD=1,FlushE=1

        // branch flush
        ResultSrcE=2'b00; RdE=0; Rs1D=0; PCSrcE=1;
        #10; // expect FlushD=1,FlushE=1

        #10 $finish;
    end

endmodule

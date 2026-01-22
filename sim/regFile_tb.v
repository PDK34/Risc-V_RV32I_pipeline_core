`timescale 1ns/1ps

module regFile_tb;

    reg clk, rst;
    reg [4:0] A1, A2, RdW;
    reg regWriteW;
    reg [31:0] resultW;
    wire [31:0] readData1D, readData2D;

    regFile dut (
        .clk(clk),
        .rst(rst),
        .A1(A1),
        .A2(A2),
        .regWriteW(regWriteW),
        .resultW(resultW),
        .RdW(RdW),
        .readData1D(readData1D),
        .readData2D(readData2D)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("regFile.vcd");
        $dumpvars(0, regFile_tb);


        clk = 0;
        rst = 1;
        regWriteW = 0;
        A1 = 0; A2 = 0; RdW = 0; resultW = 0;

        #10 rst = 0;

        // x5 = 42
        #5 regWriteW = 1; RdW = 5; resultW = 32'd42;
        #10 regWriteW = 0;

        // read x5
        #5 A1 = 5; A2 = 0;

        //Writing to x0 (ignored)
        #5 regWriteW = 1; RdW = 0; resultW = 32'd99;
        #10 regWriteW = 0;

        #10 $finish;
    end

endmodule

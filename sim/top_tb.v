`timescale 1ns/1ps

module top_tb;

    reg clk, rst;

    top dut(
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    // access internals
    wire [31:0] x1  = dut.u_regfile.regs[1];
    wire [31:0] x2  = dut.u_regfile.regs[2];
    wire [31:0] x3  = dut.u_regfile.regs[3];
    wire [31:0] x4  = dut.u_regfile.regs[4];
    wire [31:0] x5  = dut.u_regfile.regs[5];
    wire [31:0] x6  = dut.u_regfile.regs[6];
    wire [31:0] x7  = dut.u_regfile.regs[7];
    wire [31:0] x8  = dut.u_regfile.regs[8];
    wire [31:0] x9  = dut.u_regfile.regs[9];
    wire [31:0] x10 = dut.u_regfile.regs[10];
    wire [31:0] x11 = dut.u_regfile.regs[11];
    wire [31:0] x12 = dut.u_regfile.regs[12];
    wire [31:0] x13 = dut.u_regfile.regs[13];
    wire [31:0] x14 = dut.u_regfile.regs[14];
    wire [31:0] x15 = dut.u_regfile.regs[15];

    task check;
        input [31:0] val, expected;
        input [63:0] name; // for display index
        begin
            if(val !== expected)
                $display("FAIL x%0d: got %0d expected %0d", name, val, expected);
            else
                $display("PASS x%0d: %0d", name, val);
        end
    endtask

    initial begin
        clk = 0; rst = 1;
        #12 rst = 0;

        // wait enough cycles for all instructions + pipeline drain
        // 19 instructions + 5 pipeline stages + stalls(~2) = ~30 cycles
        #300;

        $display("Register Check");
        check(x1,  32'd5,  1);
        check(x2,  32'd3,  2);
        check(x3,  32'd8,  3);
        check(x4,  32'd3,  4);
        check(x5,  32'd1,  5);
        check(x6,  32'd11, 6);
        check(x7,  32'd1,  7);
        check(x8,  32'd8,  8);
        check(x9,  32'd13, 9);
        check(x10, 32'd5,  10);
        check(x11, 32'd8,  11);
        check(x12, 32'd1,  12);
        check(x13, 32'd5,  13);
        check(x14, 32'd0,  14); // branch flush check
        check(x15, 32'd2,  15);

        $display("Memory Check");
        if(dut.u_dmem.dataMem[0] !== 32'd8)
            $display("FAIL mem[0]: got %0d expected 8", dut.u_dmem.dataMem[0]);
        else
            $display("PASS mem[0]: 8");

        if(dut.u_dmem.dataMem[1] !== 32'd5)
            $display("FAIL mem[1]: got %0d expected 5", dut.u_dmem.dataMem[1]);
        else
            $display("PASS mem[1]: 5");

        $finish;
    end

endmodule

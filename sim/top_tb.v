`timescale 1ns/1ps

module top_tb;

    reg clk, rst;

    top dut(.clk(clk), .rst(rst));

    always #5 clk = ~clk;

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
    wire [31:0] x16 = dut.u_regfile.regs[16];
    wire [31:0] x17 = dut.u_regfile.regs[17];
    wire [31:0] x18 = dut.u_regfile.regs[18];
    wire [31:0] x19 = dut.u_regfile.regs[19];
    wire [31:0] x20 = dut.u_regfile.regs[20];
    wire [31:0] x21 = dut.u_regfile.regs[21];
    wire [31:0] x22 = dut.u_regfile.regs[22];
    wire [31:0] x23 = dut.u_regfile.regs[23];
    wire [31:0] x24 = dut.u_regfile.regs[24];
    wire [31:0] x25 = dut.u_regfile.regs[25];
    wire [31:0] x26 = dut.u_regfile.regs[26];
    wire [31:0] x27 = dut.u_regfile.regs[27];
    wire [31:0] x28 = dut.u_regfile.regs[28];
    wire [31:0] x29 = dut.u_regfile.regs[29];
    wire [31:0] x30 = dut.u_regfile.regs[30];
    wire [31:0] x31 = dut.u_regfile.regs[31];

    task check;
        input [31:0] val, expected;
        input [63:0] regnum;
        begin
            if(val !== expected)
                $display("FAIL x%0d: got %0d expected %0d", regnum, $signed(val), $signed(expected));
            else
                $display("PASS x%0d: %0d", regnum, $signed(val));
        end
    endtask

    initial begin
        clk = 0; rst = 1;
        #12 rst = 0;
        $monitor("t=%0t x31=%0d PCF=%0d FlushE=%b FlushD=%b",
          $time, $signed(dut.u_regfile.regs[31]), dut.PCF, dut.FlushE, dut.FlushD);
        $monitor("t=%0t PCF=%0d FlushE=%b FlushD=%b StallF=%b StallD=%b",
          $time, dut.PCF, dut.FlushE, dut.FlushD, dut.StallF, dut.StallD);


        // ~35 instructions + stalls + pipeline drain
        #800;

        $display("---- Register Check ----");
        check(x1,  32'd5,   1);
        check(x2,  32'd3,   2);
        check(x3,  32'd8,   3);
        check(x4,  32'd3,   4);
        check(x5,  32'd1,   5);
        check(x6,  32'd11,  6);
        check(x7,  32'd1,   7);
        check(x8,  32'd8,   8);
        check(x9,  32'd13,  9);
        check(x10, 32'd5,   10);
        check(x11, 32'd8,   11);
        check(x12, 32'd1,   12);
        check(x13, 32'd5,   13);
        check(x14, 32'd0,   14);
        check(x15, 32'd2,   15);
        check(x16, -32'd1,  16);
        check(x17, 32'd1,   17);
        check(x18, -32'd2,  18);
        check(x19, 32'd8,   19);
        check(x20, 32'd5,   20);
        check(x21, 32'd13,  21);
        check(x22, 32'd5,   22);
        check(x23, 32'd5,   23);
        check(x24, 32'd0,   24);
        check(x25, 32'd7,   25);
        check(x26, 32'd4,  26);
        check(x27, 32'd3,  27);
        check(x28, 32'd6,  28);
        check(x29, 32'd9,  29);
        check(x31, 32'd1,  31);

        $display("---- Memory Check ----");
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

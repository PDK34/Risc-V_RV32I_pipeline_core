`timescale 1ns/1ps

module new_instr_tb;

    reg clk, rst;
    top dut(.clk(clk), .rst(rst));
    always #5 clk = ~clk;

    // register access
    wire [31:0] x1  = dut.u_regfile.regs[1];
    wire [31:0] x2  = dut.u_regfile.regs[2];
    wire [31:0] x3  = dut.u_regfile.regs[3];
    wire [31:0] x4  = dut.u_regfile.regs[4];
    wire [31:0] x5  = dut.u_regfile.regs[5];
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

    integer auipc_pc;

    initial begin
        clk = 0; rst = 1;
        #12 rst = 0;
        //$monitor("t=%0t srcAE=%0d srcBE=%0d ALUCtrl=%0d ALUResult=%0d",
            //  $time, dut.srcAE, dut.srcBE, dut.ALUControlE, dut.ALUResultE);
          $monitor("t=%0t PCF=%0d x30=%0d x31=%0d PCSrcE=%b JalrE=%b PCTargetE=%0d",
          $time, dut.PCF, dut.u_regfile.regs[30], 
          dut.u_regfile.regs[31], dut.PCSrcE, dut.JalrE, dut.PCTargetE);
        #2000;

        $display("---- XOR/XORI ----");
        check(x3,  32'd6,   3);
        check(x4,  32'd6,   4);

        $display("---- SHIFTS ----");
        check(x8,  32'd32,  8);
        check(x9,  32'd2,   9);
        check(x10, 32'd2,   10);
        check(x12, -32'd2,  12);
        check(x13, 32'd32,  13);
        check(x14, 32'd2,   14);
        check(x15, -32'd2,  15);

        $display("---- SLT/SLTU ----");
        check(x17, 32'd1,   17);
        check(x18, 32'd0,   18);
        check(x19, 32'd1,   19);

        $display("---- LUI ----");
        check(x20, 32'h1000, 20);

        $display("---- AUIPC ----");
        // x21 = PC of auipc instruction + 0x1000
        // auipc is instruction 20 (0-indexed), PC = 20*4 = 80
        check(x21, 32'd80 + 32'h1000, 21);

        $display("---- BLTU/BGEU ----");
        check(x22, 32'd5,   22);
        check(x23, 32'd7,   23);

        $display("---- SB/LB/LBU ----");
        check(x25, -32'd85, 25);  // lb sign extended 0xAB
        check(x26, 32'd171, 26);  // lbu zero extended 0xAB

        $display("---- SH/LH/LHU ----");
        check(x28, 32'd127, 28);
        check(x29, 32'd127, 29);

        $display("---- JAL ----");
        check(x30, 32'd168, 30);  // verify auipc+addi computed correctly
        check(x31, 32'd55,  31);  // verify jalr jumped to target

        $display("---- Memory ----");
        if(dut.u_dmem.dataMem[2][7:0] !== 8'hAB)
            $display("FAIL mem byte: got %h expected AB", dut.u_dmem.dataMem[2][7:0]);
        else
            $display("PASS mem byte: AB");

        if(dut.u_dmem.dataMem[3][15:0] !== 16'h007F)
            $display("FAIL mem half: got %h expected 007F", dut.u_dmem.dataMem[3][15:0]);
        else
            $display("PASS mem half: 007F");

        $finish;
    end
endmodule

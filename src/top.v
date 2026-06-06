module top(
    input clk, rst
);

    //Fetch
    wire [31:0] PCF, PCPlus4F, instrF;

    //Decode
    wire [31:0] instrD, PCD, PCPlus4D;
    wire [31:0] ReadData1D, ReadData2D, immExtendedD;
    wire [4:0]  RdD, Rs1D, Rs2D;
    wire [3:0]  ALUControlD;
    wire [2:0] immSrc; 
    wire [1:0]  ResultSrcD;
    wire        ALUSrcD, BranchD, JumpD, RegWriteD, MemWriteD;
    wire [2:0] funct3E,funct3M;
    wire isLuiD,isLuiE;

    //Execute
    wire [31:0] ReadData1E, ReadData2E, PCE, PCPlus4E, immExtendedE;
    wire [4:0]  RdE, Rs1E, Rs2E;
    wire [3:0]  ALUControlE;
    wire [1:0]  ResultSrcE, forwardAE, forwardBE;
    wire        ALUSrcE, BranchE, JumpE, RegWriteE, MemWriteE;
    wire [31:0] srcAE, srcBE, srcBE_pre, ALUResultE, writeDataE;
    wire        zeroE, PCSrcE;
    wire [31:0] PCTargetE;
    wire [31:0] upperImmResultE;
    //Memory
    wire [31:0] ALUResultM, writeDataM, PCPlus4M, memReadDataM;
    wire [4:0]  RdM;
    wire [1:0]  ResultSrcM;
    wire        RegWriteM, MemWriteM;
    wire [31:0] upperImmResultM;
    //Writeback
    wire [31:0] ALUResultW, memReadDataW, PCPlus4W, resultW;
    wire [4:0]  RdW;
    wire [1:0]  ResultSrcW;
    wire        RegWriteW;
    wire [31:0] upperImmResultW;
    //Hazard_signals
    wire StallF, StallD, FlushE, FlushD;

    // FETCH
    pc u_pc(
        .clk(clk), .rst(rst), .enable(~StallF),
        .PCSrcE(PCSrcE), .PCTargetE(PCTargetE),
        .PCF(PCF), .PCPlus4F(PCPlus4F)
    );

    imem u_imem(
        .PCF(PCF),
        .instructionF(instrF)
    );

    if_id u_if_id(
        .clk(clk), .rst(rst), .enable(~StallD), .flush(FlushD),
        .instrF(instrF), .PCF(PCF), .PCPlus4F(PCPlus4F),
        .instrD(instrD), .PCD(PCD), .PCPlus4D(PCPlus4D)
    );

    // DECODE
    control_signal u_ctrl(
        .opcode(instrD[6:0]),
        .funct3(instrD[14:12]),
        .f7_5(instrD[30]),
        .immSrc(immSrc),
        .ALUcontrolD(ALUControlD),
        .jump(JumpD), .branch(BranchD),
        .aluSrcBD(ALUSrcD), .memWriteD(MemWriteD), .regWriteD(RegWriteD),
        .resultSrcD(ResultSrcD),.isLuiD(isLuiD)
    );

    regFile u_regfile(
        .clk(clk), .rst(rst),
        .A1(instrD[19:15]), .A2(instrD[24:20]),
        .regWriteW(RegWriteW), .resultW(resultW), .RdW(RdW),
        .readData1D(ReadData1D), .readData2D(ReadData2D)
    );

    immExtend u_immext(
        .immSrc(immSrc),
        .instrD(instrD),
        .immExtendedD(immExtendedD)
    );

    assign RdD  = instrD[11:7];
    assign Rs1D = instrD[19:15];
    assign Rs2D = instrD[24:20];

    wire JalrE;
    id_ex u_id_ex(
        .clk(clk), .rst(rst), .flush(FlushE),
        .ReadData1D(ReadData1D), .ReadData2D(ReadData2D),
        .PCD(PCD), .PCPlus4D(PCPlus4D),
        .immExtendedD(immExtendedD),
        .RdD(RdD), .Rs1D(Rs1D), .Rs2D(Rs2D),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD), .JumpD(JumpD), .BranchD(BranchD),
        .RegWriteD(RegWriteD), .MemWriteD(MemWriteD),
        .ResultSrcD(ResultSrcD),
        .ReadData1E(ReadData1E), .ReadData2E(ReadData2E),
        .PCE(PCE), .PCPlus4E(PCPlus4E),
        .immExtendedE(immExtendedE),
        .RdE(RdE), .Rs1E(Rs1E), .Rs2E(Rs2E),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE), .JumpE(JumpE), .BranchE(BranchE),
        .RegWriteE(RegWriteE), .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),.funct3D(instrD[14:12]),
        .funct3E(funct3E) ,.jalrD(instrD[6:0] == 7'b1100111),.jalrE(JalrE),.isLuiD(isLuiD),.isLuiE(isLuiE)
    );

    // EXECUTE
    mux3_1 u_fwdA(
        .a(ReadData1E), .b(resultW), .c(ALUResultM),
        .sel(forwardAE), .out(srcAE)
    );

    mux3_1 u_fwdB(
        .a(ReadData2E), .b(resultW), .c(ALUResultM),
        .sel(forwardBE), .out(srcBE_pre)
    );

    mux2_1 u_alusrc(
        .a(srcBE_pre), .b(immExtendedE),
        .sel(ALUSrcE), .y(srcBE)
    );

    assign writeDataE = srcBE_pre;
    assign upperImmResultE = isLuiE ? immExtendedE : (PCE + immExtendedE) ;

    alu u_alu(
        .srcAE(srcAE), .srcBE(srcBE),
        .ALUcontrolE(ALUControlE),
        .ALUResultE(ALUResultE), .zeroE(zeroE)
    );
    wire [31:0] forwardResultE = (ResultSrcE == 2'b11) ? upperImmResultE : ALUResultE;

    
    branch_decode u_branch_decoder(
        .funct3E(funct3E),
        .zeroE(zeroE),
        .ALUResultE_0(ALUResultE[0]),
        .BranchE(BranchE),
        .PCSrcE(PCSrcE),
        .JumpE(JumpE),
        .JalrE(JalrE),
        .srcAE(srcAE),.immExtendedE(immExtendedE),.PCE(PCE),.PCTargetE(PCTargetE)
    );


    ex_mem u_ex_mem(
        .clk(clk), .rst(rst), .funct3E(funct3E),.funct3M(funct3M),
        .ALUResultE(forwardResultE), .ResultSrcE(ResultSrcE),
        .RegWriteE(RegWriteE), .MemWriteE(MemWriteE),
        .writeDataE(writeDataE), .PCPlus4E(PCPlus4E), .RdE(RdE),
        .ALUResultM(ALUResultM), .ResultSrcM(ResultSrcM),
        .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
        .writeDataM(writeDataM), .PCPlus4M(PCPlus4M), .RdM(RdM) ,.upperImmResultE(upperImmResultE) ,.upperImmResultM(upperImmResultM)
    );

    // MEMORY
    dmem u_dmem(
        .clk(clk), .writeEnableM(MemWriteM),.funct3M(funct3M),
        .addrM(ALUResultM), .writeDataM(writeDataM),
        .rdDataM(memReadDataM)
    );

    mem_wb u_mem_wb(
        .clk(clk), .rst(rst),
        .ResultSrcM(ResultSrcM), .RegWriteM(RegWriteM),
        .ALUResultM(ALUResultM), .memReadDataM(memReadDataM),
        .PCPlus4M(PCPlus4M), .RdM(RdM),
        .ResultSrcW(ResultSrcW), .RegWriteW(RegWriteW),
        .ALUResultW(ALUResultW), .memReadDataW(memReadDataW),
        .PCPlus4W(PCPlus4W), .RdW(RdW),.upperImmResultM(upperImmResultM),.upperImmResultW(upperImmResultW)
    );


    // WRITEBACK
    mux4_1 u_result(
        .a(ALUResultW), .b(memReadDataW), .c(PCPlus4W),.d(upperImmResultW),
        .sel(ResultSrcW), .out(resultW)
    );

    // HAZARD
    hazard_unit u_hazard(
        .Rs1E(Rs1E), .Rs2E(Rs2E), .RdM(RdM), .RdW(RdW),
        .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE), .RdE(RdE),
        .Rs1D(Rs1D), .Rs2D(Rs2D),
        .PCSrcE(PCSrcE),
        .forwardAE(forwardAE), .forwardBE(forwardBE),
        .StallF(StallF), .StallD(StallD),
        .FlushE(FlushE), .FlushD(FlushD)
    );

endmodule

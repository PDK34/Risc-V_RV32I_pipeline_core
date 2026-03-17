module hazard_unit (
    input [4:0] Rs1E,Rs2E,RdM,RdW,
    input RegWriteM,RegWriteW,

    input [1:0] ResultSrcE,
    input [4:0] RdE,Rs1D,Rs2D


    output reg [1:0] forwardAE,forwardBE
);
    always@(*)begin
        if((Rs1E == RdM)&RegWriteM&(Rs1E!=5'd0)) forwardAE = 2'b10;
        else if((Rs1E == RdW)&RegWriteW&(Rs1E!=5'd0)) forwardAE = 2'b01;
        else forwardAE = 2'b00;

        
        if((Rs2E == RdM)&RegWriteM&(Rs2E!=5'd0)) forwardBE = 2'b10;
        else if((Rs2E == RdW)&RegWriteW&(Rs2E!=5'd0)) forwardBE = 2'b01;
        else forwardBE = 2'b00;
    end

    always@(*) begin
        
    end
endmodule

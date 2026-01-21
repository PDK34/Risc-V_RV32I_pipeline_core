module regFile(
    input clk,rst,
    input [4:0] A1,A2,
    input regWriteW,
    input [31:0] resultW, //Data to be written into destination reg, from writeBack stage
    input [4:0] RdW, //Destination register address, from writeBack stage
    output [31:0] readData1D,readData2D
    );
    reg [31:0] regs [31:0]; 

    assign readData1D = (A1 == 5'b0)? 32'b0 : regs[A1];
    assign readData2D = (A2 == 5'b0)? 32'b0 : regs[A2];

    integer i;
    always@(posedge clk)begin
        if(rst)begin
            for (i = 0; i<32 ;i=i+1 ) begin
                regs[i] <= 32'b0;
            end
        end
        else    begin
            if(RdW!=5'b0 && regWriteW)begin
                regs[RdW] <= resultW;
            end
        end
    end


endmodule

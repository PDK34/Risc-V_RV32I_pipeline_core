module dmem (
    input clk,
    input writeEnableM,
    input [31:0] addrM,
    input [31:0] writeDataM , 
    output [31:0] rdDataM
);
    reg [31:0] dataMem [0:255]; //Word-aligned data memory(256 x 32 bit words)

    wire[7:0] word_addr = addrM[9:2];

    assign rdDataM = dataMem[word_addr];

    always @(posedge clk) begin
        if(writeEnableM)begin
            dataMem[word_addr] <= writeDataM;
        end
    end


endmodule

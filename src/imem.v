module imem (
    input [31:0] PCF,
    output [31:0] instructionF
    );

    reg [31:0] instrMem [0:255]; //Word-aligned imem with 1KB capacity

    wire [7:0] word_address;
    assign word_address = PCF [9:2]; 

    assign instructionF = instrMem[word_address]; 

    integer i;
    initial begin
        for (i = 0; i<256 ; i= i+1 ) begin
            instrMem[i] = 32'b0; //Initialize memory locations 
            
        end
        $readmemh("new_instr_tests.hex",instrMem); //Read test program
    end

    
     

endmodule

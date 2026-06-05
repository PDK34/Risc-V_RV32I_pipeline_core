module control_signal (
    input [6:0] opcode,
    input [2:0] funct3,
    input f7_5,  //5th bit of func7
    output reg [2:0] immSrc,
    output reg [3:0] ALUcontrolD,
    output reg jump,branch,
    output reg aluSrcBD,memWriteD,regWriteD,
    output reg [1:0] resultSrcD,
    output reg isLuiD
);
    localparam ADD = 4'd0 ,SUB = 4'd1 ,AND = 4'd2 ,OR = 4'd3 ,SLT = 4'd4,
               XOR = 4'd5, SLL = 4'd6 , SRL = 4'd7, SRA = 4'd8, SLTU = 4'd9;

    always@(*)begin
        immSrc = 3'd0;
        ALUcontrolD = ADD;
        jump = 1'd0;
        branch = 1'd0;
        aluSrcBD = 1'd0;
        memWriteD = 1'd0;
        regWriteD = 1'd0;
        resultSrcD = 2'd0;
        isLuiD = 1'd0;
        case (opcode)
            7'b0110011 : begin  //R-type
                aluSrcBD = 1'd0;
                regWriteD = 1'd1;
                resultSrcD = 2'd0;
                case (funct3)
                    3'b000 : begin
                        if(f7_5) ALUcontrolD = SUB;
                        else ALUcontrolD = ADD;
                    end 
                    3'b001 : begin
                        ALUcontrolD =  SLL;
                    end
                    3'b010 : begin
                        ALUcontrolD = SLT;
                    end
                    3'b011 : begin
                        ALUcontrolD = SLTU;
                    end
                    3'b100 : begin
                        ALUcontrolD =  XOR;
                    end
                    3'b101 : begin
                        if(f7_5) ALUcontrolD =  SRA;
                        else ALUcontrolD = SRL;
                    end
                    3'b110 : begin
                        ALUcontrolD = OR;
                    end
                    
                    3'b111 : begin
                        ALUcontrolD = AND;
                    end

                    
                    default: ALUcontrolD = ADD;
                endcase  
            end

            7'b0010011 : begin  //I-type
                aluSrcBD = 1'd1;
                regWriteD = 1'd1;
                resultSrcD = 2'd0;
                case (funct3)
                    3'b000 : begin
                        ALUcontrolD = ADD;
                    end 

                    3'b001 : begin
                        ALUcontrolD =  SLL;
                    end
                    3'b010 : begin
                        ALUcontrolD = SLT;
                    end
                    3'b011 : begin
                        ALUcontrolD = SLTU;
                    end
                    3'b100 : begin
                        ALUcontrolD =  XOR;
                    end
                    3'b101 : begin
                        if(f7_5) ALUcontrolD =  SRA;
                        else ALUcontrolD = SRL;
                    end
                    3'b110 : begin
                        ALUcontrolD = OR;
                    end
                    
                    3'b111 : begin
                        ALUcontrolD = AND;
                    end
                    default: ALUcontrolD = ADD;
                endcase  
            end

            7'b0000011 : begin //Load type
                immSrc = 3'd0;
                aluSrcBD = 1'd1;
                memWriteD = 1'd0;
                regWriteD = 1'd1;
                resultSrcD = 2'd1;
                case(funct3)
                3'b010 : ALUcontrolD = ADD;
                default : ALUcontrolD = ADD;
                endcase
            end

            7'b0100011 : begin //Store type
                immSrc = 3'd1;
                aluSrcBD = 1'd1;
                memWriteD = 1'd1;
                regWriteD = 1'd0;
                case(funct3)
                3'b010 : ALUcontrolD = ADD;
                default : ALUcontrolD = ADD;
                endcase
            end     

            7'b1100011 : begin   //Branch type
                immSrc = 3'd2;
                aluSrcBD = 1'd0;
                memWriteD = 1'd0;
                regWriteD = 1'd0;
                branch = 1'd1;
                case (funct3)
                    3'b000 : ALUcontrolD = SUB; // beq
                    3'b001 : ALUcontrolD = SUB; // bne
                    3'b100 : ALUcontrolD = SLT; // blt
                    3'b101 : ALUcontrolD = SLT; // bge
                    3'b110 : ALUcontrolD = SLTU; // bltu  
                    3'b111 : ALUcontrolD = SLTU; // bgeu

                    default: ALUcontrolD = ADD;
                endcase
            end
            7'b1101111 : begin //JAL
                immSrc = 3'd3;
                regWriteD = 1'b1;
                resultSrcD = 2'b10;
                jump = 1'b1;
            end

            7'b1100111 : begin //JALR
                immSrc = 3'd0;
                regWriteD = 1'b1;
                resultSrcD = 2'b10;
                jump = 1'b1;
            end

            7'b0110111: begin //LUI
                immSrc = 3'd4;
                regWriteD = 1'b1;
                resultSrcD = 2'b11;
                isLuiD = 1'd1;
            end

            7'b0010111: begin //AUIPC
                immSrc = 3'd4;
                regWriteD = 1'b1;
                resultSrcD = 2'b11;
            end

        endcase   
    end


endmodule

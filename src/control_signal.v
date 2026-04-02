module control_signal (
    input [6:0] opcode,
    input [2:0] funct3,
    input f7_5,  //5th bit of func7
    output reg [1:0] immSrc,
    output reg [2:0] ALUcontrolD,
    output reg jump,branch,
    output reg aluSrcBD,memWriteD,regWriteD,
    output reg [1:0] resultSrcD
);
    localparam ADD = 3'd0 ,SUB = 3'd1 ,AND = 3'd2 ,OR = 3'd3 ,SLT = 3'd4;

    always@(*)begin
        immSrc = 2'd0;
        ALUcontrolD = ADD;
        jump = 1'd0;
        branch = 1'd0;
        aluSrcBD = 1'd0;
        memWriteD = 1'd0;
        regWriteD = 1'd0;
        resultSrcD = 2'd0;
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

                    3'b010 : begin
                        ALUcontrolD = SLT;
                    end

                    3'b111 : begin
                        ALUcontrolD = AND;
                    end

                    3'b110 : begin
                        ALUcontrolD = OR;
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

                    3'b010 : begin
                        ALUcontrolD = SLT;
                    end

                    3'b111 : begin
                        ALUcontrolD = AND;
                    end

                    3'b110 : begin
                        ALUcontrolD = OR;
                    end
                    default: ALUcontrolD = ADD;
                endcase  
            end

            7'b0000011 : begin //Load type
                immSrc = 2'd0;
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
                immSrc = 2'd1;
                aluSrcBD = 1'd1;
                memWriteD = 1'd1;
                regWriteD = 1'd0;
                case(funct3)
                3'b010 : ALUcontrolD = ADD;
                default : ALUcontrolD = ADD;
                endcase
            end     

            7'b1100011 : begin
                immSrc = 2'd2;
                aluSrcBD = 1'd0;
                memWriteD = 1'd0;
                regWriteD = 1'd0;
                branch = 1'd1;
                case (funct3)
                    3'b000 : ALUcontrolD = SUB; // beq
                    3'b001 : ALUcontrolD = SUB; // bne
                    3'b100 : ALUcontrolD = SLT; // blt
                    3'b101 : ALUcontrolD = SLT; // bge
                    default: ALUcontrolD = ADD;
                endcase
            end       
        endcase   
    end


endmodule

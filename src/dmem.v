module dmem (
    input clk,
    input writeEnableM,
    input [2:0] funct3M,
    input [31:0] addrM,
    input [31:0] writeDataM , 
    output reg [31:0] rdDataM
);
    reg [31:0] dataMem [0:255]; //Word-aligned data memory(256 x 32 bit words)

    wire[7:0] word_addr = addrM[9:2];
    wire [1:0] byte_off  = addrM[1:0];  // byte offset within word

    //load
    always@(*) begin
        case(funct3M)
            3'b000: begin // lb
                case(byte_off)
                    2'b00: rdDataM = {{24{dataMem[word_addr][7]}},  dataMem[word_addr][7:0]};
                    2'b01: rdDataM = {{24{dataMem[word_addr][15]}}, dataMem[word_addr][15:8]};
                    2'b10: rdDataM = {{24{dataMem[word_addr][23]}}, dataMem[word_addr][23:16]};
                    2'b11: rdDataM = {{24{dataMem[word_addr][31]}}, dataMem[word_addr][31:24]};
                endcase
            end
            3'b001: begin // lh
                case(byte_off)
                    2'b00: rdDataM = {{16{dataMem[word_addr][15]}}, dataMem[word_addr][15:0]};
                    2'b10: rdDataM = {{16{dataMem[word_addr][31]}}, dataMem[word_addr][31:16]};
                    default: rdDataM = 32'b0;
                endcase
            end
            3'b010: rdDataM = dataMem[word_addr]; // lw
            3'b100: begin // lbu
                case(byte_off)
                    2'b00: rdDataM = {24'b0, dataMem[word_addr][7:0]};
                    2'b01: rdDataM = {24'b0, dataMem[word_addr][15:8]};
                    2'b10: rdDataM = {24'b0, dataMem[word_addr][23:16]};
                    2'b11: rdDataM = {24'b0, dataMem[word_addr][31:24]};
                endcase
            end
            3'b101: begin // lhu
                case(byte_off)
                    2'b00: rdDataM = {16'b0, dataMem[word_addr][15:0]};
                    2'b10: rdDataM = {16'b0, dataMem[word_addr][31:16]};
                    default: rdDataM = 32'b0;
                endcase
            end
            default: rdDataM = dataMem[word_addr];
        endcase
    end

    //store
    always@(posedge clk) begin
        if(writeEnableM) begin
            case(funct3M)
                3'b000: begin // sb
                    case(byte_off)
                        2'b00: dataMem[word_addr][7:0]   <= writeDataM[7:0];
                        2'b01: dataMem[word_addr][15:8]  <= writeDataM[7:0];
                        2'b10: dataMem[word_addr][23:16] <= writeDataM[7:0];
                        2'b11: dataMem[word_addr][31:24] <= writeDataM[7:0];
                    endcase
                end
                3'b001: begin // sh
                    case(byte_off)
                        2'b00: dataMem[word_addr][15:0]  <= writeDataM[15:0];
                        2'b10: dataMem[word_addr][31:16] <= writeDataM[15:0];
                        default: ; 
                    endcase
                end
                3'b010: dataMem[word_addr] <= writeDataM; // sw
                default: dataMem[word_addr] <= writeDataM;
            endcase
        end
    end



endmodule

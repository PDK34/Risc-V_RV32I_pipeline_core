module mux3_1 (
    input [31:0] a,b,c,
    input [1:0] sel,
    output [31:0] y
);
    assign y = (sel == 2'd0) ? a :
                 (sel == 2'd1) ? b :
                 (sel == 2'd2) ? c ;
                                 
endmodule

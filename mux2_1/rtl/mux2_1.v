module mux2_1
(
    input wire	[1:0] in1,
    input wire [1:0] in2,
    input wire sel,
    
    output reg [1:0] out 
);
always@(*)
    if(sel == 1'b1)
        out = in1;
    else
        out = in2;
/*
assign out = (sel == 1'b1) ? in1:in2;
always@(*)
    case(sel)
        1'b1: out = in1;
        1'b0: out = in2;
        default: out = in1;//不能列举所有情况，加default
    endcase
*/



endmodule      
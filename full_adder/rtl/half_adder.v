module half_adder
(
    input wire in1,
    input wire in2,
    
    output wire sum,
    output wire count
    
);

assign {count, sum} = in1 + in2;

endmodule
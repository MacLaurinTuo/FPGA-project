module  freq_meter(

    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,



    output  wire    shcp        ,
    output  wire    stcp        ,
    output  wire    ds          ,
    output  wire    oe          

);

wire     [31:0]  freq;
wire             locked_sig;
wire             clk_test;        


clk_test_gen	clk_test_gen_inst (
	.areset ( ~sys_rst_n ),
	.inclk0 ( sys_clk    ),
	.c0     ( clk_test    ),
	.locked ( locked_sig )
	);

freq_meter_ctrl freq_meter_ctrl_inst
(
    .sys_clk     (sys_clk   ),
    .sys_rst_n   (sys_rst_n ),
    .clk_test    (clk_test  ),

    .freq        (freq      )

);

seg_595_dynamic seg_595_dynamic_inst
(
    .sys_clk     (sys_clk   ),   
    .sys_rst_n   (sys_rst_n ),   
    .data        (freq/1000 ),   
    .point       (6'b001000 ),
    .sign        (1'b0      ),
    .seg_en      (1'b1      ),
                  
    .shcp        (shcp      ),
    .stcp        (stcp      ),
    .ds          (ds        ),
    .oe          (oe        )
   
);





endmodule
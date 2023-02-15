module  pll(

    input   wire    sys_clk      ,
    
    output  wire    clk_mul_2    ,
    output  wire    clk_div_2    ,
    output  wire    clk_phase_90 ,
    output  wire    clk_ducle_20 ,
    output  wire    locked      

);


pll_ip	pll_ip_inst (

	.inclk0 ( sys_clk      ),
	.c0     ( clk_mul_2    ),
	.c1     ( clk_div_2    ),
	.c2     ( clk_phase_90 ),
	.c3     ( clk_ducle_20 ),
	.locked ( locked       )
);

endmodule
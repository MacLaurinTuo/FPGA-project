`timescale 1ns/1ns
module  tb_pll();

reg     sys_clk      ;
                 
wire    clk_mul_2    ;
wire    clk_div_2    ;
wire    clk_phase_90 ;
wire    clk_ducle_20 ;
wire    locked       ;

initial sys_clk = 1'b1;

always #10 sys_clk = ~sys_clk;

pll   pll_inst(

    .sys_clk      (sys_clk     ),
   
    .clk_mul_2    (clk_mul_2   ),
    .clk_div_2    (clk_div_2   ),
    .clk_phase_90 (clk_phase_90),
    .clk_ducle_20 (clk_ducle_20),
    .locked       (locked      )

);


endmodule
`timescale  1ns/1ns

module  tb_bcd_8421();

reg              sys_clk     ;
reg              sys_rst_n   ;
reg      [19:0]  data        ;
                        
wire     [3:0]   unit        ;
wire     [3:0]   ten         ;
wire     [3:0]   hun         ;
wire     [3:0]   tho         ;
wire     [3:0]   t_tho       ;
wire     [3:0]   h_hun       ;

initial begin
    sys_clk    = 1'b1;
    sys_rst_n <= 1'b0;
    data      <= 20'd987665;    
    #20
    sys_rst_n <= 1'b1;
    #3000
    data      <= 20'd5478;
    #3000
    data      <= 20'd321;
    #3000
    data      <= 20'd78;

end


always #10 sys_clk = ~sys_clk;



bcd_8421    bcd_8421_inst
(
 
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .data        (data     ),
   
    .unit        (unit     ),
    .ten         (ten      ),
    .hun         (hun      ),
    .tho         (tho      ),
    .t_tho       (t_tho    ),
    .h_hun       (h_hun    )

 );
 



endmodule
`timescale 1ns/1ns
module  tb_bcd_8421();

    
reg              sys_clk      ;
reg              sys_rst_n    ;
reg    [19:0]    data         ;

wire     [3:0]   unit       ;
wire     [3:0]   ten        ;
wire     [3:0]   hun        ;
wire     [3:0]   tho        ;
wire     [3:0]   t_tho      ;
wire     [3:0]   h_tho      ;
    
initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    data <= 20'd987360;
    #20
    sys_rst_n <= 1'b1;
    #1000
    data <= 20'd125479;
    #1000
    data <= 20'd45162;
    #1000
    data <= 20'd2874;
    #1000
    data <= 20'd489;

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
    .h_tho       (h_tho    )
    
);


endmodule
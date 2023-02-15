`timescale  1ns/1ns

module  tb_tft_colorbar();

reg             sys_clk     ;
reg             sys_rst_n   ;
                 
wire    [15:0]  rgb         ;
wire            hsync       ;
wire            vsync       ;
wire            tft_clk     ;
wire            tft_bl      ;
wire            tft_de      ;


initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #20
    sys_rst_n <= 1'b1;

end

always #10 sys_clk = ~sys_clk;

tft_colorbar    tft_colorbar_inst
(

    .sys_clk    (sys_clk  ),    
    .sys_rst_n  (sys_rst_n), 

    .rgb        (rgb      ),   
    .hsync      (hsync    ),   
    .vsync      (vsync    ),   
    .tft_clk    (tft_clk  ),
    .tft_bl     (tft_bl   ),
    .tft_de     (tft_de   )
);

endmodule
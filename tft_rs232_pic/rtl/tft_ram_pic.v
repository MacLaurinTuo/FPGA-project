module  tft_ram_pic(

    input   wire             sys_clk    ,    
    input   wire             sys_rst_n  ,
    input   wire             rx         ,
    
    output  wire     [7:0]   rgb        ,   
    output  wire             hsync      ,   
    output  wire             vsync      ,   
    output  wire             tft_clk    ,
    output  wire             tft_bl     ,
    output  wire             tft_de     
);

wire    clk_9m  ;
wire    clk_50m ;
wire    locked  ;
wire    rst_n   ;
wire    im_flag ;

wire    [9:0]   pix_x;
wire    [9:0]   pix_y;
wire    [7:0]   pix_data;
wire    [7:0]   im_data ;

assign  rst_n = sys_rst_n && locked;

tft_ctrl    tft_ctrl_inst
(

    .tft_clk_9m (clk_9m    ),
    .sys_rst_n  (rst_n     ),
    .pix_data   (pix_data  ),
                 
    .rgb        (rgb       ),   
    .hsync      (hsync     ),   
    .vsync      (vsync     ),   
    .pix_x      (pix_x     ),
    .pix_y      (pix_y     ),
    .tft_clk    (tft_clk   ),
    .tft_bl     (tft_bl    ),
    .tft_de     (tft_de    )
);

tft_pic     tft_pic_inst
(
    .tft_clk     (clk_9m  ),
    .sys_clk     (clk_50m ),
    .sys_rst_n   (rst_n   ),
    .pi_flag     (im_flag ),
    .pi_data     (im_data ),
    .pix_x       (pix_x   ),
    .pix_y       (pix_y   ),
    
    .pix_data    (pix_data)

);

uart_rx     uart_rx_inst
(
    .sys_clk     (clk_50m  ),
    .sys_rst_n   (rst_n    ),
    .rx          (rx       ),
   
    .po_data     (im_data  ),
    .po_flag     (im_flag  )

);

vga_clk	    vga_clk_inst 
(
	.areset ( ~sys_rst_n ),
	.inclk0 ( sys_clk    ),
    
	.c0     ( clk_9m     ),
	.c1     ( clk_50m    ),
	.locked ( locked     )
);


endmodule
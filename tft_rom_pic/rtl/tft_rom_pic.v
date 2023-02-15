module  tft_rom_pic(

    input   wire            sys_clk     ,    
    input   wire            sys_rst_n   , 
    
    output  wire     [15:0]  rgb        ,   
    output  wire             hsync      ,   
    output  wire             vsync      ,   
    output  wire             tft_clk    ,
    output  wire             tft_bl     ,
    output  wire             tft_de     
);

wire    tft_clk_9m;
wire    rst_n;
wire    locked;
wire    [9:0]   pix_x;
wire    [9:0]   pix_y;
wire    [15:0]  pix_data;

assign  rst_n = sys_rst_n && locked;

tft_ctrl    tft_ctrl_inst
(

    .tft_clk_9m (tft_clk_9m),
    .sys_rst_n  (sys_rst_n ),
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

tft_pic tft_pic_inst
(
    .tft_clk     (tft_clk_9m  ),
    .sys_rst_n   (rst_n    ),
    .pix_x       (pix_x    ),
    .pix_y       (pix_y    ),
    
    .pix_data    (pix_data )
);

vga_clk vga_clk_inst 
(
	.areset ( ~sys_rst_n ),
	.inclk0 ( sys_clk    ),
    
	.c0     ( tft_clk_9m ),
	.locked ( locked     )
);


endmodule
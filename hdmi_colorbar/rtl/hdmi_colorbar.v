module  hdmi_colorbar(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
            
    output  wire            ddc_scl     ,
    output  wire            ddc_sda     ,  
    output  wire            tmds_clk_p  ,    
    output  wire            tmds_clk_n  , 
    output  wire    [2:0]   tmds_data_p ,   
    output  wire    [2:0]   tmds_data_n   
    
);


wire     vga_clk ;
wire     clk_5x  ;
wire     locked  ;
wire     rst_n   ;
wire     rgb_valid;
wire     [9:0]    pix_x     ;
wire     [9:0]    pix_y     ;
wire     [15:0]   pix_data  ;
wire     [15:0]   rgb       ;
wire              hsync     ;
wire              vsync     ;

assign rst_n = (sys_rst_n & locked);
assign ddc_scl = 1'b1;
assign ddc_sda = 1'b1;


clk_gen	clk_gen_inst 
(
	.areset ( ~sys_rst_n ),
	.inclk0 ( sys_clk    ),
	.c0     ( vga_clk    ),
	.c1     ( clk_5x     ),
	.locked ( locked     )
);

vga_pic vga_pic_inst
(
    .vga_clk     ( vga_clk  ),
    .sys_rst_n   ( rst_n    ),
    .pix_x       ( pix_x    ),
    .pix_y       ( pix_y    ),
                   
    .pix_data    ( pix_data )

);

vga_ctrl    vga_ctrl_isnt
(

    .vga_clk     ( vga_clk   ),
    .sys_rst_n   ( rst_n     ),
    .pix_data    ( pix_data  ),
                             
    .rgb         ( rgb       ),   
    .hsync       ( hsync     ),   
    .vsync       ( vsync     ),   
    .pix_x       ( pix_x     ),
    .pix_y       ( pix_y     ),
    .rgb_valid   ( rgb_valid )
    
);

hdmi_ctrl   hdmi_ctrl_inst
(

    .vga_clk     ( vga_clk    ),
    .clk_5x      ( clk_5x     ),
    .sys_rst_n   ( rst_n      ),
    .hsync       ( hsync      ),
    .vsync       ( vsync      ),
    .de          ( rgb_valid  ),
    .rgb_red     ( {rgb[15:11],3'd0} ),
    .rgb_green   ( {rgb[10:5],2'd0} ),
    .rgb_blue    ( {rgb[4:0],3'd0} ),
  
    .hdmi_clk_p  ( tmds_clk_p ),   
    .hdmi_clk_n  ( tmds_clk_n ),    
    .hdmi_r_p    ( tmds_data_p[2] ),    
    .hdmi_g_p    ( tmds_data_p[1] ),    
    .hdmi_b_p    ( tmds_data_p[0] ),    
    .hdmi_r_n    ( tmds_data_n[2] ),    
    .hdmi_g_n    ( tmds_data_n[1] ),    
    .hdmi_b_n    ( tmds_data_n[0] )     

);


endmodule
module  hdmi_ctrl(

    input   wire            vga_clk     ,
    input   wire            clk_5x      ,
    input   wire            sys_rst_n   ,
    input   wire            hsync       ,
    input   wire            vsync       ,
    input   wire            de          ,
    input   wire    [7:0]   rgb_red     ,
    input   wire    [7:0]   rgb_green   ,
    input   wire    [7:0]   rgb_blue    ,
    
    output  wire            hdmi_r_p    ,    
    output  wire            hdmi_g_p    ,    
    output  wire            hdmi_b_p    ,    
    output  wire            hdmi_clk_p  ,    
    output  wire            hdmi_r_n    ,    
    output  wire            hdmi_g_n    ,    
    output  wire            hdmi_b_n    ,    
    output  wire            hdmi_clk_n       

);

wire    [9:0]   red;
wire    [9:0]   green;
wire    [9:0]   blue;
wire    [9:0]   red1;


encode encode_inst1
(

    .vga_clk     ( vga_clk   ),
    .sys_rst_n   ( sys_rst_n ),
    .c0          ( hsync     ),
    .c1          ( vsync     ),
    .de          ( de        ),
    .data_in     ( rgb_red   ),
 
    .data_out    ( red       )

);

encode encode_inst2
(

    .vga_clk     ( vga_clk   ),
    .sys_rst_n   ( sys_rst_n ),
    .c0          ( hsync     ),
    .c1          ( vsync     ),
    .de          ( de        ),
    .data_in     ( rgb_green ),
 
    .data_out    ( green     )

);

encode  encode_inst3
(

    .vga_clk     ( vga_clk   ),
    .sys_rst_n   ( sys_rst_n ),
    .c0          ( hsync     ),
    .c1          ( vsync     ),
    .de          ( de        ),
    .data_in     ( rgb_blue  ),
 
    .data_out    ( blue      )

);

par_to_ser  par_to_ser_inst1
(

    .clk_5x      ( clk_5x   ),
    .par_data    ( red      ),
  
    .ser_data_p  ( hdmi_r_p ),
    .ser_data_n  ( hdmi_r_n )

);

par_to_ser  par_to_ser_inst2
(

    .clk_5x      ( clk_5x   ),
    .par_data    ( green    ),
  
    .ser_data_p  ( hdmi_g_p ),
    .ser_data_n  ( hdmi_g_n )

);

par_to_ser  par_to_ser_inst3
(

    .clk_5x      ( clk_5x   ),
    .par_data    ( blue     ),
  
    .ser_data_p  ( hdmi_b_p ),
    .ser_data_n  ( hdmi_b_n )

);

par_to_ser  par_to_ser_inst4
(

    .clk_5x      ( clk_5x   ),
    .par_data    ( 10'b11111_00000 ),
  
    .ser_data_p  ( hdmi_clk_p ),
    .ser_data_n  ( hdmi_clk_n )

);

endmodule
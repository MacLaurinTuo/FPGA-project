module  tft_ctrl(

    input   wire             tft_clk_9m ,
    input   wire             sys_rst_n  ,
    input   wire     [7:0]   pix_data   ,
    
    output  wire     [7:0]   rgb        ,   
    output  wire             hsync      ,   
    output  wire             vsync      ,   
    output  wire     [9:0]   pix_x      ,
    output  wire     [9:0]   pix_y      ,
    output  wire             tft_clk    ,
    output  wire             tft_bl     ,
    output  wire             tft_de     
);

parameter   H_SYNC   =   10'd41 ,
            H_BACK   =   10'd02 ,
            H_VALID  =   10'd480,
            H_FRONT  =   10'd02 ,
            H_TOTAL  =   10'd525;

parameter   V_SYNC   =   10'd10 ,
            V_BACK   =   10'd02 ,
            V_VALID  =   10'd272,
            V_FRONT  =   10'd02 ,
            V_TOTAL  =   10'd286;

reg     [9:0]   cnt_h;
reg     [9:0]   cnt_v;
wire            rgb_valid;

assign  tft_clk = tft_clk_9m;
assign  tft_de  = rgb_valid ;
assign  tft_bl  = sys_rst_n ;

always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_h <= 10'd0;
    else    if(cnt_h == H_TOTAL - 1)
        cnt_h <= 10'd0;
    else
        cnt_h <= cnt_h + 1'b1;

always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)    
        cnt_v <= 10'd0;
    else    if((cnt_h == H_TOTAL - 1) && (cnt_v == V_TOTAL - 1))
        cnt_v <= 10'd0;
    else    if(cnt_h == H_TOTAL - 1)
        cnt_v <= cnt_v +1'b1;

assign  hsync = (cnt_h < H_SYNC)? 1'b1:1'b0;
assign  vsync = (cnt_v < V_SYNC)? 1'b1:1'b0;

assign  rgb_valid = ((cnt_h >= H_SYNC + H_BACK ) && (cnt_h <= H_TOTAL - H_FRONT  - 1'b1)
                     && (cnt_v >= V_SYNC + V_BACK ) && (cnt_v <= V_TOTAL - V_FRONT - 1'b1))
                    ? 1'b1 : 1'b0;

                
assign  pix_x = (rgb_valid == 1'b1)? (cnt_h - (H_SYNC + H_BACK )) : 10'h3ff;
assign  pix_y = (rgb_valid == 1'b1)? (cnt_v - (V_SYNC + V_BACK )) : 10'h3ff;

assign  rgb   = (rgb_valid == 1'b1)? pix_data : 8'd0;

endmodule
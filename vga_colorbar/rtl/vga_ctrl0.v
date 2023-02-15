module  vga_ctrl
(
    input   wire            vga_clk     ,
    input   wire            sys_rst_n   ,
    input   wire    [15:0]  pix_data    ,
    
    output  wire    [15:0]  rgb         ,
    output  wire            hsync       ,
    output  wire            vsync       ,
    output  wire    [9:0]   pix_x       ,
    output  wire    [9:0]   pix_y       

);

reg     [9:0]   cnt_h;  
reg     [9:0]   cnt_v;  
wire             rgb_valid;

parameter   H_SYNC  =   10'd96  ,
            H_BACK  =   10'd40  ,
            H_LEFT  =   10'd8   ,
            H_VALID =   10'd640 ,
            H_RIGHT =   10'd8   ,
            H_FRONT =   10'd8   ,
            H_TOTAL =   10'd800 ;

parameter   V_SYNC  =   10'd2   ,
            V_BACK  =   10'd25  ,
            V_LEFT  =   10'd8   ,
            V_VALID =   10'd480 ,
            V_RIGHT =   10'd8   ,
            V_FRONT =   10'd2   ,
            V_TOTAL =   10'd525 ;

always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            cnt_h <= 10'd0;
        else    if(cnt_h == H_TOTAL - 1)
            cnt_h <= 10'd0;
        else
            cnt_h <= cnt_h + 1'b1;

always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            cnt_v <= 10'd0;
        else    if((cnt_v == V_TOTAL - 1) && (cnt_h == H_TOTAL - 1))
            cnt_v <= 10'd0;
        else    if(cnt_v == V_TOTAL - 1)
            cnt_v <= cnt_v + 1'b1;
        else
            cnt_v <= cnt_v;
            
assign  rgb_valid = ((cnt_h >= H_SYNC + H_BACK + H_LEFT) &&
                      (cnt_h < H_SYNC + H_BACK + H_LEFT + H_VALID) &&
                      (cnt_v >= V_SYNC + V_BACK + V_LEFT) &&
                      (cnt_h < V_SYNC + V_BACK + V_LEFT + V_VALID))
                      ? 1'b1 : 1'b0;

assign  hsync = (cnt_h <= H_SYNC - 1) ? 1'b1 : 1'b0;

assign  vsync = (cnt_h <= V_SYNC - 1) ? 1'b1 : 1'b0;

assign  pix_x = (rgb_valid == 1'b1) ? (cnt_h - (H_SYNC + H_BACK + H_LEFT)) : 1'b0;

assign  pix_y = (rgb_valid == 1'b1) ? (cnt_v - (V_SYNC + V_BACK + V_LEFT)) : 1'b0;

assign  rgb   = (rgb_valid == 1'b1) ? pix_data : 16'h000;
always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            hsync <= 1'b0;
        else    if(cnt_h <= 95)
            hsync <= 1'b1;
        else
            hsync <= 1'b0;
          
always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            vsync <= 1'b0;
        else    if(cnt_v <= 1)
            vsync <= 1'b1;
        else
            vsync <= 1'b0;

always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)
            rpg_valid <= 1'b0;
        else    if((cnt_h >= 144 && cnt_h <= 783) &&
                    (cnt_v >= 35 && cnt_v <= 514))
            rpg_valid <= 1'b1;
        else
            rpg_valid <= 1'b0;
            
always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)           
            pix_x <= 1'b0;
        else    if(rpg_valid == 1'b1)
            pix_x <= cnt_h - 144;
        else    
            pix_x <= 1'b0;
            
always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)             
            pix_y <= 1'b0;
        else    if(rpg_valid == 1'b1)
            pix_y <= cnt_v - 35;
        else
            pix_y <= 1'b0;

always@(posedge vga_clk or negedge sys_rst_n)
        if(sys_rst_n == 1'b0)               
            rgb <= 16'd0;
        else    if(rpg_valid == 1'b1)
            rgb <= pix_data;
        else
            rgb <= 16'd0;

endmodule
`timescale  1ns/1ns

module  tb_vga_ctrl();

reg             sys_clk     ;
wire            vga_clk     ;
reg             sys_rst_n   ;
wire     [15:0]  pix_data   ;
                          
wire    [15:0]  rgb         ;
wire            hsync       ;
wire            vsync       ;
wire    [9:0]   pix_x       ;
wire    [9:0]   pix_y       ;


initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #20
    sys_rst_n <= 1'b1;

end

always #10 sys_clk = ~sys_clk;

wire    locked;
wire    rst_n;
assign rst_n = (sys_rst_n && locked); 

/* always@(posedge vga_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        pix_data <= 16'h0000;
    else    if((pix_x >= 10'd0 && pix_x <= 10'd639) &&
               (pix_y >= 10'd0 && pix_y <= 10'd479))
               //模拟数据产上的条件是使用两个坐标信号，坐标信号没问题，
               // 而由于时序逻辑中pix_data会滞后条件一个时钟周期
               // 所以为了保证数据信号与有效标志信号同步，需要将坐标超前一个时钟周期
        pix_data <= 16'hffff;
    else
        pix_data <= 16'h0000; */

clk_gen	clk_gen_inst 
(
	.areset ( ~sys_rst_n ),
	.inclk0 ( sys_clk    ),
	.c0     ( vga_clk    ),
	.locked ( locked     )
);

vga_ctrl vga_ctrl_inst
(
    .vga_clk     (vga_clk  ),
    .sys_rst_n   (rst_n    ),
    .pix_data    (pix_data ),
   
    .rgb         (rgb      ),
    .hsync       (hsync    ),
    .vsync       (vsync    ),
    .pix_x       (pix_x    ),
    .pix_y       (pix_y    )

);
vga_pic vga_pic_inst
(
    .vga_clk     (vga_clk),
    .sys_rst_n   (rst_n),
    .pix_x       (pix_x),
    .pix_y       (pix_y),
    
    .pix_data    (pix_data)

);


endmodule
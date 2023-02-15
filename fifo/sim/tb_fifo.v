`timescale  1ns/1ns
module  tb_fifo();

reg             sys_clk     ;
reg             sys_rst_n   ;
reg             wr_reg      ;
reg             rd_reg      ;
reg    [7:0]    pi_data     ;
                  
wire            full        ;
wire            empty       ;
wire    [7:0]   usedw       ;
wire    [7:0]   po_data     ;

reg     [1:0]   cnt         ;

initial begin

    sys_clk = 1'b1;
    sys_rst_n   <= 1'b0;
    
    #20
    sys_rst_n   <= 1'b1;

end

always  #10 sys_clk = ~sys_clk;

//计数从0—3的计数器，用于产生输出数据间的间隔
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt <= 2'd0;
    else    if(cnt == 2'd3)
        cnt <= 2'd0;
    else
        cnt <= cnt + 1'b1;
//写请求信号        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_reg <= 1'b0;
    else    if((cnt == 2'd0) && (rd_reg == 1'b0))
        wr_reg <= 1'b1;
    else
        wr_reg <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        pi_data <= 8'd0;
    //pi_data的值从0 到 256循环
    else    if((pi_data == 8'd255) && (wr_reg == 1'b1))
        pi_data <= 8'd0;
    else    if(wr_reg == 1'b1)
        pi_data <= pi_data + 1'b1;  //每个wr_reg有效时产生一个数据
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        rd_reg <= 1'b0;
    else    if(full == 1'b1)
        rd_reg <= 1'b1;     //每当数据存满时，开始读数据
    else    if(empty == 1'b1)
        rd_reg <= 1'b0;
        



fifo    fifo_inst
(
    .sys_clk     (sys_clk),
    .wr_reg      (wr_reg ),
    .rd_reg      (rd_reg ),
    .pi_data     (pi_data),
    
    .full        (full   ),      
    .empty       (empty  ),      
    .usedw       (usedw  ),      
    .po_data     (po_data)      

);



endmodule
module key_filter
#(
    parameter CNT_MAX = 20'd999_999
)
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    input   wire    key_in      ,
    
    output  reg     key_flag    

);

reg [19:0]  cnt_20ms;//计数器

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_20ms <= 20'b0;
    else if(key_in == 1'b1)//高电平清零
        cnt_20ms <= 20'b0;
    else if(cnt_20ms == CNT_MAX && key_in == 1'b0)//保持在最高值
        cnt_20ms <= cnt_20ms;
    else                   //低电平计数
        cnt_20ms <= cnt_20ms + 20'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        key_flag <= 1'b0;
    else if(cnt_20ms == CNT_MAX - 20'b1)//倒数第二大值处翻转
        key_flag <= 1'b1;
    else
        key_flag <= 1'b0;
        
endmodule
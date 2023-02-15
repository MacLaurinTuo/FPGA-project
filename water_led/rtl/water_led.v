module water_led
#(
    parameter   CNT_MAX = 25'd24_999_999

)
(
    input   wire    sys_clk     ，
    input   wire    sys_rst_n   ,
    
    output  wire    [3:0]    led_out     

);

reg [24:0]  cnt;
reg         cnt_flag;
reg [3:0]   led_out_reg;
//计数器，计0.5s，即计24_999_999个周期变化
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt <= 1'b0;
    else if(cnt == CNT_MAX)
        cnt <= 1'b0;
    else
        cnt <= cnt + 1'b1;

//计数器:计满0.5s标志信号
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_flag <= 1'b0;
    else if(cnt == CNT_MAX - 1)
        cnt_flag <= 1'b1;
    else
        cnt_flag <= 1'b0;
    //由系统时钟上升沿和计数标志信号来改变状态
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)//复位信号复位
        led_out_reg <= 4'b0001;
    else if(cnt_flag == 1'b1 && led_out_reg == 4'b1000)//达到最值复位
        led_out_reg <= 4'b0001;
    else if(cnt_flag == 1'b1)
        led_out_reg <= led_out_reg << 1;
    else
        led_out_reg <= led_out_reg;

assign  led_out = ~led_out_reg ;




endmodule
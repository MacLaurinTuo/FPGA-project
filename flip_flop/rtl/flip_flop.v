module flip_flop
(
    input wire sys_clk,
    input wire sys_rst_n,
    input wire key_in,
    
    output reg led_out
);
//同步复位
// always@(posedge sys_clk)
always@(posedge sys_clk or negedge sys_rst_n)
//always中的敏感列表检测到sys_clk上升沿时执行下面的语句
    if(sys_rst_n == 1'b0)
        led_out <= 1'b0;
    else
        led_out <= key_in;
        
endmodule
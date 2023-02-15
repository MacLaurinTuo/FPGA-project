/* module counter

#(
    parameter   CNT_MAX = 25'd24_999_999  //参数传递法：带有参数接口的模块，实例化时可更改参数

)
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    output  reg     led_out     
    
);
//参数定义
//parameter   CNT_MAX = 25'd24_999_999  即能写在内部，也能写在模块外部
//localparam   CNT_MAX = 25'd24_999_999  只能写在内部

reg [24:0] cnt;


always@(posedge sys_clk or negedge sys_rst_n)

    if(sys_rst_n == 1'b0)
        cnt <= 25'b0;
    else if(cnt == CNT_MAX)
        cnt <= 25'b0;
    else
        cnt <= cnt + 1'b1;
  
always@(posedge sys_clk or negedge sys_rst_n)
    
    if(sys_rst_n == 1'b0)
        led_out <= 1'b0;
    else if(cnt == CNT_MAX)
        led_out <= ~led_out;

endmodule   */

module counter

#(
    parameter   CNT_MAX = 25'd24_999_999

)
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    output  reg     led_out     
    
);

reg [24:0] cnt;
reg        cnt_flag;

always@(posedge sys_clk or negedge sys_rst_n)

    if(sys_rst_n == 1'b0)
        cnt <= 25'b0;
    else if(cnt == CNT_MAX)
        cnt <= 25'b0;
    else
        cnt <= cnt + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    
    if(sys_rst_n == 1'b0)
        cnt_flag <= 1'b0;
    else if(cnt == CNT_MAX - 1'b1)
        cnt_flag <= 1'b1;
    else
        cnt_flag <= 1'b0;
        
always@(posedge sys_clk or negedge sys_rst_n)
    
    if(sys_rst_n == 1'b0)
        led_out <= 1'b0;
    else if(cnt_flag == 1'b1)
        led_out <= ~led_out;
        
    else
        led_out <= led_out;


endmodule  
    
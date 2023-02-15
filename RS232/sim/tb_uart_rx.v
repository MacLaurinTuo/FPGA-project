`timescale  1ns/1ns 
module  tb_uart_rx();

reg     sys_clk     ; 
reg     sys_rst_n   ;
reg     rx          ;

wire     [7:0]   po_data;
wire             po_flag;


initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    rx <= 1'b1;
    #20
    sys_rst_n <= 1'b1;
end

always #10 sys_clk = ~sys_clk;

//模拟PC机的串口调试助手发送串行数据帧的过程
//模拟发送8次数据，分别为0~7
initial begin
    #200//空闲状态
    rx_bit(8'd0);
    rx_bit(8'd1);
    rx_bit(8'd2);
    rx_bit(8'd3);
    rx_bit(8'd4);
    rx_bit(8'd5);
    rx_bit(8'd6);
    rx_bit(8'd7);
    
    
end 


//定义一个名为rx_bit的任务，每次发送一帧的数据有10位
//data的值分别为0~7由i的值传进来

task rx_bit(
    //传递到任务中的参数，调用任务的时候从外部传进来一个8位的值
    input   [7:0]   data 
    
);
    integer i;  //定义一个常量
    //用for循环产生一帧数据，for括号中最后执行的内容只能写i = i + 1
    //不可以写i++
    for(i = 0; i < 10; i = i + 1) begin
        case(i)
            0: rx <= 1'b0;
            1: rx <= data[0];
            2: rx <= data[1];
            3: rx <= data[2];
            4: rx <= data[3];
            5: rx <= data[4]; 
            6: rx <= data[5];
            7: rx <= data[6];
            8: rx <= data[7];
            9: rx <= 1'b1;
        endcase
        #(5208*20); //每发送一位数据延时5208个时钟周期
    end 
endtask
    
    


uart_rx uart_rx_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .rx          (rx       ),
                  
    .po_data     (po_data  ),
    .po_flag     (po_flag  )

);





endmodule
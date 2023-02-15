`timescale 1ns/1ns 
module  tb_rom();

reg      sys_clk    ;
reg      sys_rst_n  ;
reg      key1       ;
reg      key2       ;
        
wire     ds         ;
wire     oe         ;
wire     shcp       ;
wire     stcp       ;

initial begin

    sys_clk      =  1'b1;
    sys_rst_n   <=  1'b0;
    key1        <=  1'b1;
    key2        <=  1'b1;
    
    #200     sys_rst_n <= 1'b1;
//按下key1    
    #70000  key1    <=  1'b0;//按下按键
    #20     key1    <=  1'b1;//模拟抖动
    #20     key1    <=  1'b0;//模拟抖动
    #20     key1    <=  1'b1;//模拟抖动
    #20     key1    <=  1'b0;//模拟抖动
    #200    key1    <=  1'b1;//松开按键
    #20     key1    <=  1'b0;//模拟抖动
    #20     key1    <=  1'b1;//模拟抖动
    #20     key1    <=  1'b0;//模拟抖动
    #20     key1    <=  1'b1;//模拟抖动

//按下key2    
    #20000  key2    <=  1'b0;//按下按键
    #20     key2    <=  1'b1;//模拟抖动
    #20     key2    <=  1'b0;//模拟抖动
    #20     key2    <=  1'b1;//模拟抖动
    #20     key2    <=  1'b0;//模拟抖动
    #200    key2    <=  1'b1;//松开按键
    #20     key2    <=  1'b0;//模拟抖动
    #20     key2    <=  1'b1;//模拟抖动
    #20     key2    <=  1'b0;//模拟抖动
    #20     key2    <=  1'b1;//模拟抖动  

//按下key2    
    #20000  key2    <=  1'b0;//按下按键
    #20     key2    <=  1'b1;//模拟抖动
    #20     key2    <=  1'b0;//模拟抖动
    #20     key2    <=  1'b1;//模拟抖动
    #20     key2    <=  1'b0;//模拟抖动
    #200    key2    <=  1'b1;//松开按键
    #20     key2    <=  1'b0;//模拟抖动
    #20     key2    <=  1'b1;//模拟抖动
    #20     key2    <=  1'b0;//模拟抖动
    #20     key2    <=  1'b1;//模拟抖动     
    
    
end

always #10 sys_clk = ~sys_clk;

defparam   rom_inst.key1_filter_inst.CNT_MAX = 20'd5;
defparam   rom_inst.key2_filter_inst.CNT_MAX = 20'd5;
defparam   rom_inst.rom_ctrl_inst.CNT_MAX = 20'd99;

rom     rom_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .key1        (key1     ),
    .key2        (key2     ),
    
    .ds          (ds       ),
    .oe          (oe       ),
    .shcp        (shcp     ),
    .stcp        (stcp     ) 

);




endmodule
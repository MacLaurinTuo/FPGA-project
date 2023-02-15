module touch_ctrl_led
(
   input    wire    sys_clk     ,
   input    wire    sys_rst_n   ,
   input    wire    touch_key   ,
   
   output   reg     led_out     

);

reg     touch_key_dly1;
reg     touch_key_dly2;
wire    touch_en;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        begin
            touch_key_dly1 <= 1'b1;
            touch_key_dly2 <= 1'b1;
        end 
    else if(touch_key == 1'b0)
        begin
            touch_key_dly1 <= 1'b0;
            touch_key_dly2 <= touch_key_dly1;
        end 
    else
        begin
            touch_key_dly1 <= 1'b1;
            touch_key_dly2 <= touch_key_dly1;
        end 
        
assign touch_en = (~touch_key_dly1) & (touch_key_dly2);

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        led_out <= 1'b1;
    else if(touch_en == 1'b1)
        led_out <= ~led_out;
        
        
//边沿检测

/* always@(posedge sys_clk or sys_rst_n)
    if(sys_rst_n == 1'b0)
        datareg <= 1'b0;
    else if(data == 1'b1)
        datareg <= 1'b1;
    else
        datareg <= 1'b0;
//上升沿
always@(posedge sys_clk or sys_rst_n)
    if(sys_rst_n == 1'b0)
        poedge <= 1'b0;
    else if((data) & (~datareg))
        poedge <= 1'b1;
    else
        poedge <= 1'b0;
        

    
//下降沿    
always@(posedge sys_clk or sys_rst_n)
    if(sys_rst_n == 1'b0)
        nedge <= 1'b0;
    else if((~data) & (datareg))
        nedge <= 1'b1;
    else
        nedge <= 1'b0; */









endmodule
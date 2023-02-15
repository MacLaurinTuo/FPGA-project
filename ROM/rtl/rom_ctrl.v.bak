module  rom_ctrl
#(
    parameter   CNT_MAX = 23'd9_999_999
    
)
(
    input   wire        sys_clk     ,
    input   wire        sys_rst_n   ,
    input   wire        key1_flag   ,
    input   wire        key2_flag   ,
    
    output  reg  [7:0]  addr

);

reg     addr_flag1;
reg     addr_flag2;
reg     [23:0]  cnt_200ms;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        addr_flag1 <= 1'b0;
    else    if(key2_flag == 1'b1)
        addr_flag1 <= 1'b0;
    else    if(key1_flag == 1'b1)
        addr_flag1 <= ~addr_flag1;
    else
        addr_flag1 <= addr_flag1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        addr_flag2 <= 1'b0;
    else    if(key1_flag == 1'b1)
        addr_flag2 <= 1'b0;
    else    if(key2_flag == 1'b1)
        addr_flag2 <= ~addr_flag2;
    else
        addr_flag2 <= addr_flag2;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)    
        cnt_200ms <= 23'd0;
    else    if(cnt_200ms == CNT_MAX || addr_flag1 == 1'b1 
                || addr_flag2 == 1'b1)
        cnt_200ms <= 1'b0;
    else
        cnt_200ms <= cnt_200ms + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)    
        addr <= 8'd0;
    else   if(cnt_200ms == CNT_MAX && addr == 8'd255)
        addr <= 8'd0;
    else    if(addr_flag1 == 1'b1)
        addr <= 8'd99;
    else    if(addr_flag2 == 1'b1)
        addr <= 8'd199;
    else    if(cnt_200ms == CNT_MAX)
        addr <= addr + 1'b1;
    
        
        
endmodule
`timescale  1ns/1ns
module  tb_rom_ctrl();
    
reg     sys_clk     ;
reg     sys_rst_n   ;
reg     key1_flag   ;
reg     key2_flag   ;
                       
wire    [7:0]   addr;

initial begin

    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    key1_flag <= 1'b0;
    key2_flag <= 1'b0;
    #20
    sys_rst_n <= 1'b1;
    #700000
    
    key1_flag <= 1'b1;
    #20
    key1_flag <= 1'b0;
    #200000
    key1_flag <= 1'b1;
    #20
    key1_flag <= 1'b0;
    #600000
 
    key2_flag <= 1'b1;
    #20
    key2_flag <= 1'b0;     
    #200000
    key2_flag <= 1'b1;
    #20
    key2_flag <= 1'b0;
    #600000    
 
    key1_flag <= 1'b1;
    #20
    key1_flag <= 1'b0;     
    #200000
    key2_flag <= 1'b1;
    #20
    key2_flag <= 1'b0;
    #200000
    key2_flag <= 1'b1;
    #20
    key2_flag <= 1'b0;     
      
    
end

always  #10 sys_clk = ~sys_clk;

rom_ctrl
#(
    .CNT_MAX(23'd99)
    
)
rom_ctrl_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .key1_flag   (key1_flag),
    .key2_flag   (key2_flag),
                  
    .addr        (addr     )

);



endmodule
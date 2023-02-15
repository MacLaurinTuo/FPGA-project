`timescale 1ns/1ns
module tb_seg_595_static();

reg    sys_clk     ;
reg    sys_rst_n   ;


wire     shcp ;  
wire     stcp ;  
wire     ds   ;  
wire     oe   ;  
  


initial begin
    sys_clk      = 1'b1;
    sys_rst_n   <= 1'b0;
    #20
    sys_rst_n   <= 1'b1; 

end

always #10 sys_clk = ~sys_clk;

defparam seg_595_static_inst.seg_static_inst.TIME_MAX = 100;


seg_595_static  seg_595_static_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
  
    .shcp        (shcp     ),
    .stcp        (stcp     ),
    .ds          (ds       ),
    .oe          (oe       )

);


endmodule
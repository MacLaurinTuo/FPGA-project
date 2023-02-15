module seg_595_static
(
    input   wire     sys_clk     ,
    input   wire     sys_rst_n   ,
    
    output  wire   shcp        ,  
    output  wire   stcp        ,
    output  wire   ds          ,
    output  wire   oe          
     
);

wire     [5:0]   sel;
wire     [7:0]   seg;


seg_static  seg_static_inst
(
    .sys_clk     (sys_clk),
    .sys_rst_n   (sys_rst_n),
    
    .sel         (sel),
    .seg         (seg)

);

hc595_ctrl  hc595_ctrl_inist
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .sel         (sel      ),
    .seg         (seg      ),
  
    .shcp        (shcp     ),
    .stcp        (stcp     ),
    .ds          (ds       ),
    .oe          (oe       )

);

endmodule
`timescale  1ns/1ns

module  tb_freq_meter();

reg    sys_clk     ;
reg    sys_rst_n   ;

                 

wire    shcp       ;
wire    stcp       ;
wire    ds         ;
wire    oe         ;

initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #20
    sys_rst_n <= 1'b1;

end
always #10 sys_clk = ~sys_clk;


defparam    freq_meter_inst.freq_meter_ctrl_inst.CNT_GATE_S_MAX = 28'd239;
defparam    freq_meter_inst.freq_meter_ctrl_inst.CNT_RISE_MAX = 28'd40;



freq_meter  freq_meter_inst
(

    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),

   
    .shcp        (shcp     ),
    .stcp        (stcp     ),
    .ds          (ds       ),
    .oe          (oe       )

);



endmodule
`timescale 1ns/1ns
module  tb_pingpang();

reg             sys_clk     ;
reg             sys_rst_n   ;

wire    [15:0]  data_out    ;

initial begin
    sys_clk    = 1'b1;
    sys_rst_n <= 1'b0;
    #200
    sys_rst_n <= 1'b1;
end

always #10 sys_clk = ~sys_clk;


pingpang    pingpang_inst
(
   .sys_clk     (sys_clk  ),
   .sys_rst_n   (sys_rst_n),

   .data_out    (data_out )
);

endmodule
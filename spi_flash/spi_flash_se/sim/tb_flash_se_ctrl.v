`timescale  1ns/1ns
module  tb_flash_se_ctrl();

reg      sys_clk     ;
reg      sys_rst_n   ;
reg      key         ;
 
wire     sck         ;
wire     cs_n        ;
wire     mosi        ;

initial begin
    sys_clk    = 1'b1;
    sys_rst_n <= 1'b0;
    key       <= 1'b0;
    #20
    sys_rst_n <= 1'b1;
    #100
    key       <= 1'b1;
    #20
    key       <= 1'b0;

end

always #10 sys_clk = ~sys_clk;

flash_se_ctrl   flash_se_ctrl_inst
(
   .sys_clk     (sys_clk  ),
   .sys_rst_n   (sys_rst_n),
   .key         (key      ),
 
   .sck         (sck      ),
   .cs_n        (cs_n     ),
   .mosi        (mosi     )

);


endmodule
`timescale  1ns/1ns
module  tb_flash_be_ctrl();

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

defparam memory.mem_access.initfile = "initmemory.txt"; // 使用初始化文件进行初始化
flash_be_ctrl   flash_be_ctrl_inst//模拟主设备
(
   .sys_clk     (sys_clk  ),
   .sys_rst_n   (sys_rst_n),
   .key         (key      ),
 
   .sck         (sck      ),
   .cs_n        (cs_n     ),
   .mosi        (mosi     )

);


m25p16  memory //模拟从设备
(
    .c          (sck        ), 
    .data_in    (mosi       ), 
    .s          (cs_n       ), 
    .w          (1'b1       ), //写保护，低电平有效
    .hold       (1'b1       ), //锁定，低电平有效
    .data_out   (           )
    
); 



endmodule
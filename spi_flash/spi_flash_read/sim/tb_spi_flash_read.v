`timescale  1ns/1ns

module  tb_spi_flash_read();


reg      sys_clk     ;
reg      sys_rst_n   ;
reg      pi_key      ;
wire     miso        ;
         
wire     sck         ;
wire     cs_n        ;
wire     mosi        ;
wire     tx          ;

initial begin
    
    sys_clk = 1'b1      ;
    sys_rst_n <= 1'b0   ;
    pi_key    <= 1'b0   ;
    #20
    sys_rst_n <= 1'b1   ;
    #100
    pi_key  <= 1'b1;
    #20 
    pi_key  <= 1'b0;

end



always #10 sys_clk = ~sys_clk; 

defparam memory.mem_access.initfile = "initmemory.txt"; // 使用初始化文件进行初始化



spi_flash_read  spi_flash_read_inst//模拟主设备
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .pi_key      (pi_key   ),
    .miso        (miso     ),
    
    .sck         (sck      ),
    .cs_n        (cs_n     ),
    .mosi        (mosi     ),
    .tx          (tx       )


);

m25p16  memory //模拟从设备
(
    .c          (sck        ), 
    .data_in    (mosi       ), 
    .s          (cs_n       ), 
    .w          (1'b1       ), //写保护，低电平有效
    .hold       (1'b1       ), //锁定，低电平有效
    .data_out   (miso       )
    
); 

endmodule
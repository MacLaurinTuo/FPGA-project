module  spi_flash
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    input   wire    pi_key      ,
    
    output  wire    sck         ,
    output  wire    cs_n        ,
    output  wire    mosi   


);


wire    key_flag;




flash_be_ctrl   flash_be_ctrl_inst
(
   .sys_clk     (sys_clk  ),
   .sys_rst_n   (sys_rst_n),
   .key         (key_flag ),
 
   .sck         (sck      ),
   .cs_n        (cs_n     ),
   .mosi        (mosi     )

);

key_filter      key_filter_inst

(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .key_in      (pi_key   ),
 
    .key_flag    (key_flag )

);



endmodule
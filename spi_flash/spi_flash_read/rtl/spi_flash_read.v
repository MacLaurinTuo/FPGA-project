module  spi_flash_read
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    input   wire    pi_key      ,
    input   wire    miso        ,
    
    output  wire    sck         ,
    output  wire    cs_n        ,
    output  wire    mosi        ,
    output  wire    tx


);


wire            key_flag    ;
wire            tx_flag     ;
wire    [7:0]   tx_data     ;

parameter   CNT_MAX     =   20'd9     ,//按键信号，计数器计数最大值
            UART_BPS    =   14'd9600        ,//比特率
            CLK_FREQ    =   26'd50_000_000  ,//时钟频率
            CNT_WAIT_MAX =  16'd59999       ;//读数据等待时间

key_filter      
#(
    .CNT_MAX     (CNT_MAX  )
)
key_filter_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .key_in      (pi_key   ),
 
    .key_flag    (key_flag )

);

flash_read_ctrl     
#(
    .CNT_WAIT_MAX   (CNT_WAIT_MAX)
)
flash_read_ctrl_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .key         (key_flag ),
    .miso        (miso     ),
  
    .sck         (sck      ),
    .cs_n        (cs_n     ),
    .mosi        (mosi     ),
    .tx_flag     (tx_flag  ),
    .tx_data     (tx_data  )

);

uart_tx     
#(
    .UART_BPS    (UART_BPS ),
    .CLK_FREQ    (CLK_FREQ )
)
uart_tx_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .pi_data     (tx_data  ),
    .pi_flag     (tx_flag  ),
   
    .tx          (tx       )

);




endmodule
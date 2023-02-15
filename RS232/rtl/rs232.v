module  rs232
#(
    parameter   UART_BPS = 'd9600,
    parameter   CLK_FREQ = 'd50_000_000

)
(

    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    input   wire    rx          ,

    output  wire    tx          

);


wire     [7:0]   po_data;
wire             po_flag;


uart_rx 
#(
    .UART_BPS(9600        ),
    .CLK_FREQ(50_000_000  )

) 
uart_rx_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .rx          (rx       ),
                  
    .po_data     (po_data  ),
    .po_flag     (po_flag  )

);

uart_tx
#(
    .UART_BPS(9600        ),
    .CLK_FREQ(50_000_000  )

) 
uart_tx_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .pi_data     (po_data  ),
    .pi_flag     (po_flag  ),
    
    .tx          (tx       )

);

endmodule
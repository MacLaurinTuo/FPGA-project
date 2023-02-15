module  fifo_sum(

    input   wire       sys_clk     ,
    input   wire       sys_rst_n   ,
    input   wire       rx          ,
    
    output  wire       tx          
    
);

wire    [7:0]   po_data ;
wire    [7:0]   po_data1;
wire            po_flag ;
wire            po_flag1;



uart_rx uart_rx_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .rx          (rx       ),
    
    .po_data     (po_data  ),
    .po_flag     (po_flag  )

);

uart_tx uart_tx_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .pi_data     (po_data1 ),
    .pi_flag     (po_flag1 ),
                  
    .tx          (tx       )

);

fifi_sum_ctrl fifi_sum_ctrl_inst
(

    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .pi_flag     (po_flag  ),
    .pi_data     (po_data  ),
   
    .po_flag     (po_flag1  ),
    .po_data     (po_data1  )

);


endmodule
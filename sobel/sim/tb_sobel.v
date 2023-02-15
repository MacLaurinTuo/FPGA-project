`timescale 1ns/1ns

module  tb_sobel();

reg              sys_clk    ;
reg              sys_rst_n  ;
reg              rx         ;
                            
wire     [15:0]  rgb        ;
wire             hsync      ;
wire             vsync      ;
wire             tft_clk    ;
wire             tft_bl     ;
wire             tft_de     ;
wire             tx         ;

reg     [7:0]   data_mem    [9999:0];

initial 
    $readmemh("E:/code/workspace_FPGA/sobel/matlab/data_logo.txt", data_mem);

initial begin

    sys_clk    = 1'b1;
    sys_rst_n <= 1'b0;
    #200
    sys_rst_n <= 1'b1;   

end

always #10 sys_clk = ~sys_clk;

initial begin

    rx <= 1'b1;
    #200
    rx_byte();
end

task    rx_byte();
    integer i;
    for(i = 0; i < 10000; i = i + 1)
        rx_bit(data_mem[i]);
endtask

task    rx_bit(input [7:0] data);
    integer j;
    for(j = 0; j < 10; j = j + 1)
    begin
        case(j)
            0   :   rx  <=  1'b0;
            1   :   rx  <=  data[0];
            2   :   rx  <=  data[1];
            3   :   rx  <=  data[2];
            4   :   rx  <=  data[3];
            5   :   rx  <=  data[4];
            6   :   rx  <=  data[5];
            7   :   rx  <=  data[6];
            8   :   rx  <=  data[7];
            9   :   rx  <=  1'b1;
        endcase
        #1040;       
    end
endtask

defparam    sobel_inst.uart_rx_inst.CLK_FREQ = 'd50_0000;
defparam    sobel_inst.uart_tx_inst.CLK_FREQ = 'd50_0000;



sobel   sobel_inst
(
    .sys_clk    (sys_clk  ),    
    .sys_rst_n  (sys_rst_n),    
    .rx         (rx       ),    
   
    .rgb        (rgb      ),   
    .hsync      (hsync    ),   
    .vsync      (vsync    ),   
    .tft_clk    (tft_clk  ),
    .tft_bl     (tft_bl   ),
    .tft_de     (tft_de   ),    
    .tx         (tx       )
);



endmodule
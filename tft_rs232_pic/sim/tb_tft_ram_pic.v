`timescale  1ns/1ns

module  tb_tft_ram_pic();


reg             sys_clk   ;
reg             sys_rst_n ;
reg             rx        ;
                 
wire            hsync     ;
wire            vsync     ;
wire    [7:0]   rgb       ;
wire            tft_clk   ;
wire            tft_bl    ;
wire            tft_de    ;

reg     [7:0]   data_mem    [255:0]    ;

initial
    $readmemh("E:/code/workspace_FPGA/tft_rs232_pic/matlab/data_test.txt", data_mem);

initial begin
    sys_clk    = 1'b1;
    sys_rst_n <= 1'b0;
    #100
    sys_rst_n <= 1'b1;
end

always #10 sys_clk = ~sys_clk;

initial begin

    rx  <=  1'b1;
    #200
    rx_byte();
end

task    rx_byte();
    integer j;
    for(j = 0; j < 256; j = j+1)
        rx_bit(data_mem[j]);      
endtask

task    rx_bit(input [7:0] data);
    integer i;
    for(i = 0; i < 10; i = i+1)
    begin
        case(i)
            0   :   rx  <=  1'b0    ;
            1   :   rx  <=  data[0] ;
            2   :   rx  <=  data[1] ;
            3   :   rx  <=  data[2] ;
            4   :   rx  <=  data[3] ;
            5   :   rx  <=  data[4] ;
            6   :   rx  <=  data[5] ;
            7   :   rx  <=  data[6] ;
            8   :   rx  <=  data[7] ;
            9   :   rx  <=  1'b1    ;
        endcase
        #(5208*20);
    end
endtask


tft_ram_pic     tft_ram_pic_inst
(
    .sys_clk    (sys_clk  ),    
    .sys_rst_n  (sys_rst_n),
    .rx         (rx       ),
    
    .rgb        (rgb      ),   
    .hsync      (hsync    ),   
    .vsync      (vsync    ),   
    .tft_clk    (tft_clk  ),
    .tft_bl     (tft_bl   ),
    .tft_de     (tft_de   )
);


endmodule
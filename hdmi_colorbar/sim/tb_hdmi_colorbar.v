`timescale  1ns/1ns

module  tb_hdmi_colorbar();

reg             sys_clk     ;
reg             sys_rst_n   ;
                      
wire            ddc_scl     ;
wire            ddc_sda     ; 
wire            tmds_clk_p  ; 
wire            tmds_clk_n  ; 
wire    [2:0]   tmds_data_p ; 
wire    [2:0]   tmds_data_n ; 

initial begin
    sys_clk    = 1'b1;
    sys_rst_n <= 1'b0;
    #200
    sys_rst_n <= 1'b1;

end

always #10 sys_clk = ~sys_clk;

hdmi_colorbar   hdmi_colorbar_inst
(

    .sys_clk     ( sys_clk     ),
    .sys_rst_n   ( sys_rst_n   ),
                               
    .ddc_scl     ( ddc_scl     ),
    .ddc_sda     ( ddc_sda     ),  
    .tmds_clk_p  ( tmds_clk_p  ),    
    .tmds_clk_n  ( tmds_clk_n  ), 
    .tmds_data_p ( tmds_data_p ),   
    .tmds_data_n ( tmds_data_n )  
    
);

endmodule
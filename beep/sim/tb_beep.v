`timescale 1ns/1ns
module tb_beep();

reg     sys_clk     ;
reg     sys_rst_n   ;
                    
wire    beep        ;

initial begin

    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #20
    sys_rst_n <= 1'b1;

end

always #10 sys_clk = ~sys_clk;

beep
#(
    .TIME_500MS(25'd600),
    .DO        (18'd150),
    .RE        (18'd100),
    .MI        (18'd50),
    .FA        (18'd25),
    .SO        (18'd15),
    .LA        (18'd10),
    .XI        (18'd5)
)
beep_inst
(
    .sys_clk     (sys_clk),
    .sys_rst_n   (sys_rst_n),
    
    .beep        (beep)
);

endmodule
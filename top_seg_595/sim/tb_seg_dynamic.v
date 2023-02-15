`timescale 1ns/1ns
module  tb_seg_dynamic();

reg             sys_clk     ;
reg             sys_rst_n   ;
wire    [19:0]   data        ;
wire    [5:0]    point       ;
wire             sign        ;
wire             seg_en      ;
                    
wire    [7:0]   seg         ;
wire    [5:0]   sel         ;


initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;

    #20
    sys_rst_n <= 1'b1;

    
end

assign    seg_en = 1'b1;
assign    data = 20'd9876;
assign    point = 6'b000_000;
assign    sign = 1'b0;



always #10 sys_clk = ~sys_clk;

seg_dynamic
#(

    .CNT_1MS(16'd210)

)
seg_dynamic_inst
(
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .data        (data     ),
    .point       (point    ),
    .sign        (sign     ),
    .seg_en      (seg_en   ),
   
    .seg         (seg      ),
    .sel         (sel      )
);





endmodule
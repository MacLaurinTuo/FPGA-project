module non_blocking
(
    input   wire            sys_clk,
    input   wire            sys_rst,
    input   wire    [1:0]   in     ,

    output  reg     [1:0]   out

);

reg [1:0]   in_reg;

always@(posedge sys_clk or negedge sys_rst)
    if(sys_rst == 1'b0)
        begin
            in_reg  <= 2'b0;
            out     <= 2'b0;
        
        end
    else
        begin
            in_reg  <= in;
            out     <= in_reg;
        end
endmodule    
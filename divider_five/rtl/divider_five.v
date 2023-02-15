module divider_five
#(
    parameter   DID = 3'd5

)
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,

    output  wire    clk_out  
    // output  reg     clk_flag

);
reg [2:0]   cnt ;
reg         clk1;
reg         clk2;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt <= 3'b0;
    else if(cnt == DID - 1)
        cnt <= 3'b0;
    else
        cnt <= cnt + 1'b1;

//1.分频方法      
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        clk1 <= 1'b1;
    else if(cnt == DID / 2)
        clk1 <= 1'b0;
    else if(cnt == DID - 1)
        clk1 <= 1'b1;

 
always@(negedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        clk2 <= 1'b1;
    else if(cnt == DID / 2)
        clk2 <= 1'b0;
    else if(cnt == DID - 1)
        clk2 <= 1'b1; 
assign clk_out = (clk1 & clk2);

//2.实用的降频方法

/* always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        clk_flag <= 1'b0;
    else if(cnt == 3'd3)
        clk_flag <= 1'b1;
    else
        clk_flag <= 1'b0; */

endmodule
    
    
    
    
    
    
    
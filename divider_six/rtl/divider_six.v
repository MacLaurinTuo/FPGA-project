/* module divider_six
#(
    parameter   DID = 2'd2

)
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
   
    output  reg     clk_out     

);

reg [1:0] cnt;
reg cnt_flag;

always@(posedge sys_clk or negedge sys_rst_n)

    if(sys_rst_n == 1'b0)
        cnt <= 2'b0;
    else    if(cnt == DID)
        cnt <= 2'b0;
    else
        cnt <= cnt + 1'b1;
        

        
always@(posedge sys_clk or negedge sys_rst_n)
    
    if(sys_rst_n == 1'b0)
        clk_out <= 1'b0;
    else if(cnt == DID)
        clk_out <= ~clk_out;
    else
        clk_out <= clk_out;
        
endmodule  */  

module divider_six

(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
   
    output  reg     clk_flag     

);

reg [2:0] cnt;


always@(posedge sys_clk or negedge sys_rst_n)

    if(sys_rst_n == 1'b0)
        cnt <= 3'b0;
    else    if(cnt == 3'd5)
        cnt <= 3'b0;
    else
        cnt <= cnt + 1'b1;
        
        
always@(posedge sys_clk or negedge sys_rst_n)
    
    if(sys_rst_n == 1'b0)
        clk_flag <= 1'b0;
    else if(cnt == 3'd4)
        clk_flag <= 1'b1;
    else
        clk_flag <= 1'b0;
/* 
reg [3:0] a;
        
//使用低频脉冲
always@(posedge sys_clk or negedge sys_rst_n)

    if(sys_rst_n == 1'b0)
        a <= 4'b0;
    else if(clk_flag == 1'b0)
        a <= 4'd0;
    else
        a <= 4'd2; */
endmodule     
        
        
        
        
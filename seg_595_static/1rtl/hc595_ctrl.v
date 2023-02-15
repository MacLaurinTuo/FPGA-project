module  hc595_ctrl(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire    [5:0]   sel         ,
    input   wire    [7:0]   seg         ,
    
    output  reg             ds          ,
    output  reg             shcp        ,
    output  reg             stcp        ,
    output  reg             oe          

);

wire [13:0]  data;
reg [1:0]   cnt_clk;
reg [3:0]   cnt_bit;

assign  data = {seg[0],seg[1],seg[2],seg[3],seg[4],seg[5],seg[6],seg[7],sel};

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk <= 2'd0;
    else
        cnt_clk <= cnt_clk + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        cnt_bit <= 4'd0;
    else    if(cnt_bit == 4'd13 && cnt_clk == 2'd3)
        cnt_bit <= 4'd0;
    else    if(cnt_clk == 2'd3)
        cnt_bit <= cnt_bit + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        ds <= 1'b0;
    else    if(cnt_clk == 2'd0)
        ds <= data[cnt_bit];
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        shcp <= 1'b0;
    else    if(cnt_clk == 2'd2)
        shcp <= 1'b1;
    else    if(cnt_clk == 2'd0)
        shcp <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        stcp <= 1'b0;
    else    if(cnt_bit == 4'd13 && cnt_clk == 2'd3)
        stcp <= 1'b1;
    else
        stcp <= 1'b0;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        oe <= 1'b1;
    else
        oe <= 1'b0;        
        

endmodule
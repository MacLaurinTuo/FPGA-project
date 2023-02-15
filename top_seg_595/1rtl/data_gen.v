module  data_gen
#(
    parameter   CNT_WAIT_MAX = 23'd4999_999,
    parameter   NUM_MAX = 20'd999_999
                
)
(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,

    output  reg     [19:0]  data        ,
    output  wire    [5:0]   point       ,
    output  wire            sign        ,
    output  reg             seg_en      

);

reg     [22:0]  cnt_wait;
reg             cnt_flag;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_wait <= 23'd0;
    else    if(cnt_wait == CNT_WAIT_MAX)
        cnt_wait <= 23'd0;
    else
        cnt_wait <= cnt_wait + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_flag <= 1'b0;
    else    if(cnt_wait == CNT_WAIT_MAX - 1)    
        cnt_flag <= 1'b1;
    else
        cnt_flag <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data <= 20'd0;
    else    if(data == NUM_MAX && cnt_flag == 1'b1)
        data <= 20'd0;
    else    if(cnt_flag == 1'b1)
        data <= data + 1'b1;

assign sign = 1'b0;
assign point = 6'b000_000;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        seg_en <= 1'b0;
    else
        seg_en <= 1'b1;




endmodule
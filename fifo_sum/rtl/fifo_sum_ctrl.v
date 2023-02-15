module  fifi_sum_ctrl(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire            pi_flag     ,
    input   wire    [7:0]   pi_data     ,

    output  reg             po_flag     ,
    output  reg     [7:0]   po_data     

);

parameter   CNT_COL_MAX = 8'd4,
            CNT_ROW_MAX = 8'd5;

reg     [7:0]   cnt_col ;
reg     [7:0]   cnt_row ;
reg             wr_en1  ;
reg             wr_en1_reg  ;
reg             wr_en2  ;
reg             rd_en   ;
reg     [7:0]   wr_data1;
reg     [7:0]   wr_data2;
wire    [7:0]   rd_data1;
wire    [7:0]   rd_data2;
reg             sum_flag;



always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_col <= 8'd0;
    else    if(cnt_col == CNT_COL_MAX - 1 && pi_flag == 1'b1)
        cnt_col <= 8'd0;
    else    if(pi_flag == 1'b1)
        cnt_col <= cnt_col + 1'b1;
    else
        cnt_col <= cnt_col;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_row <= 8'd0;
    else    if(cnt_row == CNT_ROW_MAX - 1 && pi_flag == 1'b1 && cnt_col == CNT_COL_MAX - 1)
        cnt_row <= 8'd0;
    else    if(pi_flag == 1'b1 && cnt_col == CNT_COL_MAX - 1)
        cnt_row <= cnt_row + 1'b1;
    else
        cnt_row <= cnt_row;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_en1_reg <= 1'b0;
    else
        wr_en1_reg <= wr_en2 & rd_en;
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_en1 <= 1'b0;
    else    if(cnt_row == 8'd0 && pi_flag == 1'b1)
        wr_en1 <= 1'b1;
    else    if(wr_en1_reg == 1'b1)
        wr_en1 <= 1'b1;
    else
        wr_en1 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_data1 <= 8'd0;
    else    if(cnt_row == 8'd0 && pi_flag == 1'b1)
        wr_data1 <= pi_data;
    else    if(wr_en1_reg == 1'b1)
        wr_data1 <= rd_data2;
    else    
        wr_data1 <= wr_data1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_en2 <= 1'b0;
    else    if(cnt_row >= 8'd1 && cnt_row <= CNT_ROW_MAX - 1 && pi_flag == 1'b1)
        wr_en2 <= 1'b1;
    else    
        wr_en2 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_data2 <= 8'd0;
    else    if(cnt_row >= 8'd1 && cnt_row <= CNT_ROW_MAX - 1 && pi_flag == 1'b1)
        wr_data2 <= pi_data;
    else
        wr_data2 <= pi_data;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        rd_en <= 1'b0;
    else    if(cnt_row >= 8'd2 && pi_flag == 1'b1)
        rd_en <= 1'b1;
    else
        rd_en <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        sum_flag <= 1'b0;
    else
        sum_flag <= rd_en;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        po_data <= 8'd0;
    else    if(sum_flag)
        po_data <= pi_data + rd_data1 + rd_data2;
    else
        po_data <= po_data;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        po_flag <= 1'b0;
    else  
        po_flag <= sum_flag;

fifo1	fifo1_inst1 
(
	.clock ( sys_clk  ),
	.data  ( wr_data1 ),
	.rdreq ( rd_en    ),
	.wrreq ( wr_en1   ),
	.q     ( rd_data1 )
);

fifo1	fifo1_inst2 
(
	.clock ( sys_clk  ),
	.data  ( wr_data2 ),
	.rdreq ( rd_en    ),
	.wrreq ( wr_en2   ),
	.q     ( rd_data2 )
);


endmodule
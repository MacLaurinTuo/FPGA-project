module  sobel_ctrl(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire            pi_flag     ,
    input   wire    [7:0]   pi_data     ,

    output  reg             po_flag     ,
    output  reg     [15:0]  po_data     

);


parameter   CNT_COL_MAX = 8'd100,
            CNT_ROW_MAX = 8'd100;
            
parameter   VTH = 8'b0000_1100;

parameter   BLACK   = 8'h0000,
            WHITE   = 8'hFFFF;

reg     [7:0]   cnt_col ;
reg     [7:0]   cnt_row ;
reg             wr_en1  ;
reg             wr_rd_flag  ;
reg             wr_en2  ;
reg             rd_en   ;
reg     [7:0]   wr_data1;
reg     [7:0]   wr_data2;
wire    [7:0]   rd_data1;
wire    [7:0]   rd_data2;

reg             rd_en_reg1  ;
reg             rd_en_reg2  ;
reg             gx_gy_flag  ;
reg             gxy_flag    ;
reg             com_flag    ;  
  
reg     [7:0]   cnt_rd      ;
reg     [7:0]   rd_data1_reg;            
reg     [7:0]   rd_data2_reg;            
reg             pi_data_reg ;            
reg     [7:0]   a1;            
reg     [7:0]   a2;            
reg     [7:0]   a3;            
reg     [7:0]   b1;            
reg     [7:0]   b2;            
reg     [7:0]   b3;            
reg     [7:0]   c1;            
reg     [7:0]   c2;            
reg     [7:0]   c3; 

reg     [8:0]   gx;
reg     [8:0]   gy;
reg     [7:0]   gxy;

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
        wr_rd_flag <= 1'b0;
    else
        wr_rd_flag <= wr_en2 & rd_en;
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_en1 <= 1'b0;
    else    if(cnt_row == 8'd0 && pi_flag == 1'b1)
        wr_en1 <= 1'b1;
    else    if(wr_rd_flag == 1'b1)
        wr_en1 <= 1'b1;
    else
        wr_en1 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_data1 <= 8'd0;
    else    if(cnt_row == 8'd0 && pi_flag == 1'b1)
        wr_data1 <= pi_data;
    else    if(wr_rd_flag == 1'b1)
        wr_data1 <= rd_data2;
    else    
        wr_data1 <= wr_data1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_en2 <= 1'b0;
    else    if(cnt_row >= 8'd1 && cnt_row <= (CNT_ROW_MAX - 1'b1 - 1'b1) && pi_flag == 1'b1)
        wr_en2 <= 1'b1;
    else    
        wr_en2 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_data2 <= 8'd0;
    else    if(cnt_row >= 8'd1 && cnt_row <= (CNT_ROW_MAX - 1'b1 - 1'b1) && pi_flag == 1'b1)
        wr_data2 <= pi_data;
    else
        wr_data2 <= pi_data;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        rd_en <= 1'b0;
    else    if(cnt_row >= 8'd2 && pi_flag == 1'b1 && cnt_row <= CNT_ROW_MAX - 1'b1)
        rd_en <= 1'b1;
    else
        rd_en <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        cnt_rd <= 8'd0;
    else    if(cnt_rd == CNT_COL_MAX - 1 && rd_en == 1'b1)
        cnt_rd <= 8'd0;
    else    if(rd_en == 1'b1)
        cnt_rd <= cnt_rd + 1'b1;
    else
        cnt_rd <= cnt_rd;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        rd_en_reg1 <= 1'b0;
    else    if(rd_en == 1'b1)
        rd_en_reg1 <= 1'b1;
    else
        rd_en_reg1 <= 1'b0;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)         
        rd_data1_reg <= 8'd0;
    else    if(rd_en_reg1 == 1'b1)
        rd_data1_reg <= rd_data1;
    else
        rd_data1_reg <= rd_data1_reg;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)         
        rd_data2_reg <= 8'd0;
    else    if(rd_en_reg1 == 1'b1)
        rd_data2_reg <= rd_data2;
    else
        rd_data2_reg <= rd_data2_reg; 

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)         
        pi_data_reg <= 8'd0;
    else    if(rd_en_reg1 == 1'b1)
        pi_data_reg <= pi_data;
    else
        pi_data_reg <= pi_data_reg;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        rd_en_reg2 <= 1'b0;
    else    if(rd_en_reg1 == 1'b1)
        rd_en_reg2 <= 1'b1;
    else
        rd_en_reg2 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        begin
            a1 <= 8'd0;
            b1 <= 8'd0;    
            c1 <= 8'd0;
            a2 <= 8'd0;
            b2 <= 8'd0;
            c2 <= 8'd0;
            a3 <= 8'd0;
            b3 <= 8'd0;
            c3 <= 8'd0;
        end
    else    if(rd_en_reg2 == 1'b1) 
        begin      
            a1 <= a2;
            b1 <= b2;
            c1 <= c2;
            a2 <= a3;
            b2 <= b3;
            c2 <= c3;
            a3 <= rd_data1_reg;
            b3 <= rd_data2_reg;
            c3 <= pi_data_reg;              
        end
       
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        gx_gy_flag <= 1'b0;
    else    if((cnt_rd == 8'd0 || cnt_rd >= 8'd3) && (rd_en_reg2 == 1'b1))
        gx_gy_flag <= 1'b1;
    else
        gx_gy_flag <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        gx <= 9'd0;
    else    if(gx_gy_flag == 1'b1)
        gx  = (a3 - a1) + ((b3 - b1) << 1) + (c3 - c1);

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        gy <= 9'd0;
    else    if(gx_gy_flag == 1'b1)
        gy  = (a1 - c1) + ((a2 - c2) << 1) + (a3 - c3);

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        gxy_flag <= 1'b0;
    else    if(gx_gy_flag == 1'b1)
        gxy_flag <= 1'b1;
    else
        gxy_flag <= 1'b0;

//有符号寄存器，存储的是负数补码（补码 = 反码 + 1），原码 = 补码取反 + 1
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        gxy <= 8'd0;
    else    if(gxy_flag == 1'b1) begin 
        case({gx[8],gy[8]})
            2'b11 : gxy <= (~gx[7:0] + 1'b1) + (~gy[7:0] + 1'b1);
            2'b01 : gxy <= gx[7:0] + (~gy[7:0] + 1'b1);
            2'b10 : gxy <= (~gx[7:0] + 1'b1) + gy[7:0];
            2'b00 : gxy <= gx[7:0] + gy[7:0]; 
        endcase
    end
         

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        com_flag <= 1'b0;
    else    if(gxy_flag == 1'b1)
        com_flag <= 1'b1;
    else
        com_flag <= 1'b0;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)   
        po_data <= 15'd0;
    else    if((gxy > VTH) && (com_flag == 1'b1) )
        po_data <= BLACK;
    else    if(com_flag == 1'b1)
        po_data <= WHITE;
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        po_flag <= 1'b0;
    else    if(com_flag == 1'b1)
        po_flag <= 1'b1;
    else
        po_flag <= 1'b0;    
       
fifo_8x16384	fifo1_inst1 
(
	.clock ( sys_clk  ),
	.data  ( wr_data1 ),
	.rdreq ( rd_en    ),
	.wrreq ( wr_en1   ),
	.q     ( rd_data1 )
);

fifo_8x16384	fifo1_inst2 
(
	.clock ( sys_clk  ),
	.data  ( wr_data2 ),
	.rdreq ( rd_en    ),
	.wrreq ( wr_en2   ),
	.q     ( rd_data2 )
);


endmodule
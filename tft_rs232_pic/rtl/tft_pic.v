module  tft_pic
(
    input     wire              tft_clk     ,
    input     wire              sys_clk     ,
    input     wire              sys_rst_n   ,
    input     wire              pi_flag     ,
    input     wire     [7:0]    pi_data     ,
    input     wire     [9:0]    pix_x       ,
    input     wire     [9:0]    pix_y       ,
                       
    output    wire     [7:0]    pix_data    

);

parameter   H_VALID = 10'd480,
            V_VALID = 10'd272;
           
parameter   IMAGE_H = 10'd100,
            IMAGE_W = 10'd100,
            IMAGE_SIZE = 14'd10000;
            

parameter   RED   = 8'b1110_0000 , //红色
            GREEN = 8'b0001_1100 , //绿色
            BLUE  = 8'b0000_0011 , //蓝色
            BLACK = 8'b0000_0000 , //黑色
            WHITE = 8'b1111_1111 ; //白色

reg     [7:0]  pix_back_data;   
           

wire            rd_en       ;
reg             image_valid ;
wire    [7 :0]  image_data  ;
reg     [13:0]  wr_addr     ;
reg     [13:0]  rd_addr     ;


always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        wr_addr <= 14'd0;
    else    if(pi_flag == 1'b1 && wr_addr == 14'd9999)
        wr_addr <= 14'd0;
    else    if(pi_flag == 1'b1)    
        wr_addr <= wr_addr + 1'b1;
                         
always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        pix_back_data <= BLACK;
    else    if(pix_x < H_VALID/5)
        pix_back_data <= RED;                                       
    else    if(pix_x < H_VALID/5 * 2)
        pix_back_data <= GREEN;                     
    else    if(pix_x < H_VALID/5 * 3)
        pix_back_data <= BLUE;                                   
    else    if(pix_x < H_VALID/5 * 4)
        pix_back_data <= BLACK;        
    else    if(pix_x < H_VALID)
        pix_back_data <= WHITE;                                
    else
        pix_back_data <= BLACK;
        
assign  rd_en = ((pix_x >= ((H_VALID - IMAGE_W)/2) - 1'b1) && (pix_x < ((H_VALID - IMAGE_W)/2) - 1'b1 + IMAGE_W) 
                    && (pix_y >= ((V_VALID - IMAGE_H)/2)) && (pix_y < ((V_VALID - IMAGE_H)/2) + IMAGE_H));

always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        rd_addr <= 14'd0;
    else    if(rd_addr == IMAGE_SIZE - 1'b1)
        rd_addr <= 14'd0;
    else    if(rd_en == 1'b1)
        rd_addr <= rd_addr + 1'b1;


always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        image_valid <= 1'b0;
    else
        image_valid <= rd_en;
        
assign pix_data = (image_valid == 1'b1)? image_data : pix_back_data;
        

ram_pic	ram_pic_inst 
(
	.data       ( pi_data       ),
	.rdaddress  ( rd_addr       ),
	.rdclock    ( tft_clk       ),
	.rden       ( rd_en         ),
	.wraddress  ( wr_addr       ),
	.wrclock    ( sys_clk       ),
	.wren       ( pi_flag       ),
	.q          ( image_data    )
);

            
endmodule
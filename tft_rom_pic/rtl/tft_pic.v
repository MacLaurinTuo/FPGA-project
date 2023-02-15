module  tft_pic
(
    input     wire              tft_clk     ,
    input     wire              sys_rst_n   ,
    input     wire     [9:0]    pix_x       ,
    input     wire     [9:0]    pix_y       ,
                       
    output    wire     [15:0]   pix_data    

);

parameter   H_VALID = 10'd480,
            V_VALID = 10'd272;
           
parameter   IMAGE_H = 10'd100,
            IMAGE_W = 10'd100,
            IMAGE_SIZE = 14'd10000;
            
parameter   RED     = 16'hF800, 
            ORANGE  = 16'hFC00,
            YELLOW  = 16'hFFE0,
            GREEN   = 16'h07E0,
            CYAN    = 16'h07FF,
            BLUE    = 16'h001F,
            PUPPLE  = 16'hF81F,
            BLACK   = 16'h0000,
            WHITE   = 16'hFFFF,
            GRAY    = 16'hD69A;

reg      [15:0]   pix_back_data;   
           

wire    rd_en;
reg    image_valid;
wire    [15:0]  image_data;

reg     [13:0]  rom_addr;
            
always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        pix_back_data <= BLACK;
    else    if(pix_x < H_VALID/10)
        pix_back_data <= RED;        
    else    if(pix_x < H_VALID/10 * 2)
        pix_back_data <= ORANGE;                
    else    if(pix_x < H_VALID/10 * 3)
        pix_back_data <= YELLOW;                    
    else    if(pix_x < H_VALID/10 * 4)
        pix_back_data <= GREEN;        
    else    if(pix_x < H_VALID/10 * 5)
        pix_back_data <= CYAN;                
    else    if(pix_x < H_VALID/10 * 6)
        pix_back_data <= BLUE;                 
    else    if(pix_x < H_VALID/10 * 7)
        pix_back_data <= PUPPLE;                    
    else    if(pix_x < H_VALID/10 * 8)
        pix_back_data <= BLACK;        
    else    if(pix_x < H_VALID/10 * 9)
        pix_back_data <= WHITE;                
    else    if(pix_x < H_VALID)
        pix_back_data <= GRAY;                 
    else
        pix_back_data <= BLACK;
        
assign  rd_en = ((pix_x >= ((H_VALID - IMAGE_W)/2) - 1'b1) && (pix_x < ((H_VALID - IMAGE_W)/2) - 1'b1 + IMAGE_W) 
                    && (pix_y >= ((V_VALID - IMAGE_H)/2)) && (pix_y < ((V_VALID - IMAGE_H)/2) + IMAGE_H));

always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        rom_addr <= 14'd0;
    else    if(rom_addr == IMAGE_SIZE - 1'b1)
        rom_addr <= 14'd0;
    else    if(rd_en == 1'b1)
        rom_addr <= rom_addr + 1'b1;


always@(posedge tft_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        image_valid <= 1'b0;
    else
        image_valid <= rd_en;
        
assign pix_data = (image_valid == 1'b1)? image_data : pix_back_data;
        
   
rom_pic	rom_pic_inst 
(
	.address ( rom_addr    ),
	.clock   ( tft_clk     ),
	.rden    ( rd_en       ),
    
	.q       ( image_data  )
);
  
            
endmodule
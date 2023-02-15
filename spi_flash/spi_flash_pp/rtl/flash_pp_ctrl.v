module  flash_pp_ctrl
(

    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    input   wire    key         ,
                               
    output  reg     sck         ,
    output  reg     cs_n        ,
    output  reg     mosi        

);

parameter   IDEL    =   4'b0001,
            WR_EN   =   4'b0010,
            DELAY   =   4'b0100,
            PP      =   4'b1000;

parameter   WR_EN_ISNT  =   8'b0000_0110,
            PP_INST     =   8'b0000_0010;

parameter   S_ADDR      =   8'b0000_0000,
            P_ADDR      =   8'b0000_0100,
            B_ADDR      =   8'b0010_0101;
            
parameter   NUM_DATA    =   8'd100;            
                

reg     [4:0]   cnt_clk     ;
reg     [3:0]   state       ;
reg     [8:0]   cnt_byte    ; 
reg     [1:0]   cnt_sck     ;
reg     [2:0]   cnt_bit     ;
reg     [7:0]   data        ;    

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk <= 5'd0;
    else    if(state != IDEL)
        cnt_clk <= cnt_clk + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        state <= IDEL;
    else
        case(state)
            IDEL    :   if(key == 1'b1)
                            state <= WR_EN;
            WR_EN   :   if(cnt_byte == 9'd2 && cnt_clk == 5'd31)
                            state <= DELAY;
            DELAY   :   if(cnt_byte == 9'd3 && cnt_clk == 5'd31)
                            state <= PP;
            PP      :   if(cnt_byte == (NUM_DATA + 9'd9) && cnt_clk == 5'd31)
                            state <= IDEL;
            default :   state <= IDEL;
        
        endcase
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)          
        cnt_byte <= 9'd0;
    else    if(cnt_clk == 5'd31 && cnt_byte == (NUM_DATA + 9'd9))
        cnt_byte <= 9'd0;
    else    if(cnt_clk == 5'd31)
        cnt_byte <= cnt_byte + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        cnt_sck <= 2'd0;
    else    if((state == WR_EN && cnt_byte == 9'd1) || (state == PP && cnt_byte >= 9'd5 && cnt_byte <= (NUM_DATA + 9'd9 - 1)))
        cnt_sck <= cnt_sck + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_bit <= 3'd0;
    else    if(cnt_sck == 2'd3)
        cnt_bit <= cnt_bit + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cs_n <= 1'b1;
    else    if(key == 1'b1)
        cs_n <= 1'b0;
    else    if(state == WR_EN && cnt_byte == 9'b2 && cnt_clk == 5'd31)
        cs_n <= 1'b1;
    else    if(state == DELAY && cnt_byte == 9'b3 && cnt_clk == 5'd31)
        cs_n <= 1'b0;
    else    if(state == PP && cnt_byte == (NUM_DATA + 9'd9) && cnt_clk == 5'd31)
        cs_n <= 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        sck <= 1'b0;
    else    if(cnt_sck == 2'd2)
        sck <= 1'b1;
    else    if(cnt_sck == 2'd0)
        sck <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)   
        data <= 8'd0;
    else    if(state == PP && cnt_clk == 5'd31 && cnt_byte >= 9'd9 && cnt_byte <= (NUM_DATA + 9'd9 - 1))
        data <= data + 1'b1;


always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        mosi <= 1'b0;
    else    if(state == WR_EN && cnt_byte == 9'd2)
        mosi <= 1'b0;
    else    if(state == PP && cnt_byte == (NUM_DATA + 9'd9))
        mosi <= 1'b0;
    else    if(state == WR_EN && cnt_byte == 9'b1 && cnt_sck == 2'd0)
        mosi <= WR_EN_ISNT[7 - cnt_bit];
    else    if(state == PP && cnt_byte == 9'b5 && cnt_sck == 2'd0)
        mosi <= PP_INST[7 - cnt_bit];
    else    if(state == PP && cnt_byte == 9'b6 && cnt_sck == 2'd0)
        mosi <= S_ADDR[7 - cnt_bit];
    else    if(state == PP && cnt_byte == 9'b7 && cnt_sck == 2'd0)
        mosi <= P_ADDR[7 - cnt_bit];   
    else    if(state == PP && cnt_byte == 9'b8 && cnt_sck == 2'd0)
        mosi <= B_ADDR[7 - cnt_bit];   
    else    if(state == PP && cnt_byte >= 9'b9 && cnt_byte < (NUM_DATA + 9'd9) && cnt_sck == 2'd0)
        mosi <= data[7 - cnt_bit];



endmodule
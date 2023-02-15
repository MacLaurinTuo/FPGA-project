module  seg_static
#(
    parameter   CNT_WAIT_MAX = 25'd24_999_999   
)
(

    input   wire            sys_clk     ,        
    input   wire            sys_rst_n   ,        
    
    output  reg     [5:0]   sel         ,    
    output  reg     [7:0]   seg             

);

parameter   SEG_0 = 8'b1100_0000,   SEG_8 = 8'b1000_0000,
            SEG_1 = 8'b1111_1001,   SEG_9 = 8'b1001_0000,
            SEG_2 = 8'b1010_0100,   SEG_A = 8'b1000_1000,
            SEG_3 = 8'b1011_0000,   SEG_B = 8'b1000_0011,
            SEG_4 = 8'b1001_1001,   SEG_C = 8'b1100_0110,
            SEG_5 = 8'b1001_0010,   SEG_D = 8'b1010_0001,
            SEG_6 = 8'b1000_0010,   SEG_E = 8'b1000_0110,
            SEG_7 = 8'b1111_1000,   SEG_F = 8'b1000_1110;
parameter   IDEL  = 8'b1111_1111;        

reg     [24:0]  cnt_wait;
reg             add_flag;
reg     [3:0]   num;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_wait <= 25'd0;
    else    if(cnt_wait == CNT_WAIT_MAX)
        cnt_wait <= 25'd0;
    else
        cnt_wait <= cnt_wait + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        add_flag <= 1'b0;
    else    if(cnt_wait == CNT_WAIT_MAX-1)
        add_flag <= 1'b1;
    else
        add_flag <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        num <= 4'd0;
    else    if(add_flag == 1'b1)
        num <= num + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        seg <= IDEL;
    else    
        case(num)
            4'h0   :   seg <= SEG_0;
            4'h1   :   seg <= SEG_1;
            4'h2   :   seg <= SEG_2;
            4'h3   :   seg <= SEG_3;
            4'h4   :   seg <= SEG_4;
            4'h5   :   seg <= SEG_5;
            4'h6   :   seg <= SEG_6;
            4'h7   :   seg <= SEG_7;
            4'h8   :   seg <= SEG_8;
            4'h9   :   seg <= SEG_9;
            4'ha   :   seg <= SEG_A;
            4'hb   :   seg <= SEG_B;
            4'hc   :   seg <= SEG_C;
            4'hd   :   seg <= SEG_D;
            4'he   :   seg <= SEG_E;
            4'hf   :   seg <= SEG_F;
            
            default :  seg <= IDEL;      
        endcase
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        sel <= 6'b000_000;
    else
        sel <= 6'b111_111;
     
        

endmodule

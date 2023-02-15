module  seg_dynamic(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire    [19:0]  data        ,
    input   wire    [5:0]   point       ,
    input   wire            sign        ,
    input   wire            seg_en      ,
        
    output  reg     [5:0]   sel         ,
    output  reg     [7:0]   seg         
    
);

parameter   CNT_TIME_MAX = 16'd49_999;

parameter   SEG_0 = 7'b100_0000,   
            SEG_1 = 7'b111_1001,   
            SEG_2 = 7'b010_0100,   
            SEG_3 = 7'b011_0000,   
            SEG_4 = 7'b001_1001,   
            SEG_5 = 7'b001_0010,   
            SEG_6 = 7'b000_0010,   
            SEG_7 = 7'b111_1000,
            SEG_8 = 7'b000_0000,            
            SEG_9 = 7'b001_0000,
            SEG_S = 8'b1011_1111,
            SEG_X = 8'b1111_1111; 
   
wire     [3:0]   unit       ;
wire     [3:0]   ten        ;
wire     [3:0]   hun        ;
wire     [3:0]   tho        ;
wire     [3:0]   t_tho      ;
wire     [3:0]   h_hun      ;
reg     [3:0]   data_disp   ;
reg     [23:0]  data_reg    ;
reg     [15:0]  cnt_time    ;
reg             cnt_time_flag;
reg     [2:0]   cnt_sel     ;
reg     [5:0]   sel_reg     ;
reg             dot_disp    ;    

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_time <= 16'd0;
    else    if(cnt_time == CNT_TIME_MAX)
        cnt_time <= 16'd0;
    else
        cnt_time <= cnt_time + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_time_flag <= 1'b0;
    else    if(cnt_time == CNT_TIME_MAX - 1)
        cnt_time_flag <= 1'b1;
    else
        cnt_time_flag <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_sel <= 3'd0;
    else    if((cnt_time_flag == 1'b1) && (cnt_sel == 3'd5))
        cnt_sel <= 3'd0;
    else    if(cnt_time_flag == 1'b1)
        cnt_sel <= cnt_sel + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        sel_reg <= 6'b000_000;
    else    if((cnt_time_flag == 1'b1) && (cnt_sel == 3'd0))
        sel_reg <= 6'b000_001;
    else    if(cnt_time_flag == 1'b1)
        sel_reg <= sel_reg << 1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        sel <= 6'b000_000;
    else
        sel <= sel_reg;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data_reg <= 24'd0;
    else    if((h_hun) || (point[5]))
        data_reg <= {h_hun,t_tho,tho,hun,ten,unit};
    else    if(((t_tho) || (point[4])) && (sign == 1'b1))
        data_reg <= {4'd10,t_tho,tho,hun,ten,unit};
    else    if(((t_tho) || (point[4])) && (sign == 1'b0))
        data_reg <= {4'd11,t_tho,tho,hun,ten,unit};
    else    if(((tho) || (point[3])) && (sign == 1'b1))
        data_reg <= {4'd11,4'd10,tho,hun,ten,unit};
    else    if(((tho) || (point[3])) && (sign == 1'b0))
        data_reg <= {4'd11,4'd11,tho,hun,ten,unit};
    else    if(((hun) || (point[2])) && (sign == 1'b1))
        data_reg <= {4'd11,4'd11,4'd10,hun,ten,unit};
    else    if(((hun) || (point[2])) && (sign == 1'b0))
        data_reg <= {4'd11,4'd11,4'd11,hun,ten,unit};
    else    if(((ten) || (point[1])) && (sign == 1'b1))
        data_reg <= {4'd11,4'd11,4'd11,4'd10,ten,unit};
    else    if(((ten) || (point[1])) && (sign == 1'b0))
        data_reg <= {4'd11,4'd11,4'd11,4'd11,ten,unit};
    else    if(((unit) || (point[0])) && (sign == 1'b1))
        data_reg <= {4'd11,4'd11,4'd11,4'd11,4'd10,unit};
    else
        data_reg <= {4'd11,4'd11,4'd11,4'd11,4'd11,unit};

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data_disp <= 4'd0;
    else    if(cnt_time_flag)
        case(cnt_sel)
            3'd0   :   data_disp <= data_reg[3:0];
            3'd1   :   data_disp <= data_reg[7:4];
            3'd2   :   data_disp <= data_reg[11:8];
            3'd3   :   data_disp <= data_reg[15:12];
            3'd4   :   data_disp <= data_reg[19:16];
            3'd5   :   data_disp <= data_reg[23:20];
            default :  data_disp <=  4'd0;

        endcase

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        dot_disp <= 1'b1;
    else    if(cnt_time_flag == 1'b1)
        dot_disp <= ~point[cnt_sel];

        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        seg  <= SEG_X;
    else
        case(data_disp)
            4'd0   :   seg <= {dot_disp,SEG_0};
            4'd1   :   seg <= {dot_disp,SEG_1};
            4'd2   :   seg <= {dot_disp,SEG_2};
            4'd3   :   seg <= {dot_disp,SEG_3};
            4'd4   :   seg <= {dot_disp,SEG_4};
            4'd5   :   seg <= {dot_disp,SEG_5};
            4'd6   :   seg <= {dot_disp,SEG_6};
            4'd7   :   seg <= {dot_disp,SEG_7};
            4'd8   :   seg <= {dot_disp,SEG_8};
            4'd9   :   seg <= {dot_disp,SEG_9};
            4'd10  :   seg <= SEG_S;
            4'd11  :   seg <= SEG_X;
            default :  seg <= 8'b1100_0000;
        
        endcase



bcd_8421    bcd_8421_inst
(
 
    .sys_clk     (sys_clk  ),
    .sys_rst_n   (sys_rst_n),
    .data        (data     ),
   
    .unit        (unit     ),
    .ten         (ten      ),
    .hun         (hun      ),
    .tho         (tho      ),
    .t_tho       (t_tho    ),
    .h_hun       (h_hun    )

 );


endmodule
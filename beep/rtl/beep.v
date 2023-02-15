module beep
#(
    parameter   TIME_500MS = 25'd24_999_999,
    parameter   DO         = 18'd190839    ,
    parameter   RE         = 18'd170067    ,
    parameter   MI         = 18'd151514    ,
    parameter   FA         = 18'd143265    ,
    parameter   SO         = 18'd127550    ,
    parameter   LA         = 18'd113635    ,
    parameter   XI         = 18'd101213 

)
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
                                
    output  reg     beep        

);

reg     [24:0]  cnt_500ms;
reg     [2:0]   state_cnt;
reg     [17:0]  freq_cnt;
reg     [17:0]  freq_data;
wire    [16:0]  duty_data;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_500ms <= 25'b0;
    else if(cnt_500ms == TIME_500MS)
        cnt_500ms <= 25'b0;
    else
        cnt_500ms <= cnt_500ms + 25'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        state_cnt <= 3'b0;
    else if(cnt_500ms == TIME_500MS && state_cnt == 3'd6)//易错
        state_cnt <= 3'b0;
    else if(cnt_500ms == TIME_500MS)
        state_cnt <= state_cnt + 1'b1;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq_data <= DO;
    else 
        case(state_cnt)
            0   :   freq_data <= DO;
            1   :   freq_data <= RE;
            2   :   freq_data <= MI;
            3   :   freq_data <= FA;
            4   :   freq_data <= SO;
            5   :   freq_data <= LA;
            6   :   freq_data <= XI;
            default :   freq_data <= DO;
        endcase

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq_cnt <= 18'b0;
    else if(freq_cnt == freq_data || cnt_500ms == TIME_500MS)
        freq_cnt <= 18'b0;
    else
        freq_cnt <= freq_cnt + 18'b1;

assign  duty_data = freq_data >> 1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        beep <= 1'b0;
    else if(freq_cnt <= duty_data)
        beep <= 1'b0;
    else
        beep <= 1'b1;
        
        
        

endmodule       

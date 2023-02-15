module  sdram_init(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,

    output  reg     [3:0]   init_cmd    ,
    output  reg     [3:0]   init_ba     ,
    output  reg     [12:0]  init_addr   ,
    output  wire            init_end
);

parameter   T_POWER = 'd10_000;

parameter   INIT_IDEL = 3'b000,
            INIT_PRE  = 3'b001,
            INIT_TRP  = 3'b010,
            INIT_AR   = 3'b011,
            INIT_TRF  = 3'b100,
            INIT_MRS  = 3'b101,
            INIT_TMRD = 3'b110,
            INIT_END  = 3'b111;

parameter   TRP_CLK  = 3'd2,
            TRF_CLK  = 3'd7,
            TMRD_CLK = 3'd3;
            
parameter   PRECHARGE = 4'b0010,
            AUTO_REF  = 4'b0001,
            NOP       = 4'b0111,
            M_REG_SET = 4'b0000;

reg     [13:0]  cnt_200us;
wire            wait_end;
reg     [2:0]   init_state;
reg     [3:0]   cnt_clk;
reg             cnt_clk_rst;
wire            trp_end;
wire            trf_end;
wire            tmrd_end;
reg     [3:0]   cnt_init_aref;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b1)
        cnt_200us <= 14'd0;
    else    if(cnt_200us == T_POWER)
        cnt_200us <= T_POWER;
    else
        cnt_200us <= cnt_200us + 1'b1;

assign wait_end = (cnt_200us == T_POWER - 1)? 1'b1 : 1'b0;
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b1)
        cnt_clk <= 4'd0;
    else    if(cnt_clk_rst)
        cnt_clk <= 4'd0;
    else
        cnt_clk <= cnt_clk + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b1)
        cnt_init_aref <= 4'd0;
    else    if(init_state == INIT_IDEL)
        cnt_init_aref <= 4'd0;
    else    if(init_state == INIT_AR)
        cnt_init_aref <= cnt_init_aref + 1'b1;
    
assign trp_end = ((init_state == INIT_TRP) && (cnt_clk == TRP_CLK))? 1'b1 : 1'b0;

assign trf_end = ((init_state == INIT_TRF) && (cnt_clk == TRF_CLK))? 1'b1 : 1'b0;
    
assign tmrd_end = ((init_state == INIT_TMRD) && (cnt_clk == TMRD_CLK))? 1'b1 : 1'b0;    

//////////////////////////
always@(*)
    begin 
        case(init_state)
            INIT_IDEL   :   cnt_clk_rst <= 1'b1;
            INIT_TRP    :   cnt_clk_rst <= trp_end;
            INIT_TRF    :   cnt_clk_rst <= trf_end;
            INIT_TMRD   :   cnt_clk_rst <= tmrd_end;
            INIT_END    :   cnt_clk_rst <= 1'b1;
            default     :   cnt_clk_rst <= 1'b0;  
        endcase            
    end
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b1)   
        init_state <= INIT_IDEL;
    else
        case(init_state)
            INIT_IDEL:
                if(wait_end == 1'b1)
                    init_state <= INIT_PRE;
                else
                    init_state <= init_state;
            INIT_PRE:
                    init_state <= INIT_TRP;
            INIT_TRP:
                if(trp_end == 1'b1)
                    init_state <= INIT_AR;
                else
                    init_state <= init_state;
            INIT_AR:
                    init_state <= INIT_TRF;            
            INIT_TRF:
                if(trf_end == 1'b1)
                    init_state <= INIT_MRS;
                else
                    init_state <= init_state;                   
            INIT_MRS:
                    init_state <= INIT_TMRD;                    
            INIT_TMRD:
                if(tmrd_end == 1'b1)
                    init_state <= INIT_END;
                else
                    init_state <= init_state;               
            INIT_END:
                    init_state <= INIT_END;
            default :  init_state <= INIT_IDEL;
        endcase
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        begin
            init_cmd  <= NOP;
            init_ba   <= 2'b11;
            init_addr <= 13'h1ff;  
        end
    else
        case(init_state)
            INIT_IDEL, INIT_TRP, INIT_TRF, INIT_TMRD:
                begin
                    init_cmd  <= NOP;
                    init_ba   <= 2'b11;
                    init_addr <= 13'h1ff;             
                end
            INIT_PRE:
                begin
                    init_cmd  <= PRECHARGE;
                    init_ba   <= 2'b11;
                    init_addr <= 13'h1ff;   
                end
            INIT_AR:
                begin
                    init_cmd  <= AUTO_REF;
                    init_ba   <= 2'b11;
                    init_addr <= 13'h1ff; 
                end
            INIT_MRS:
                begin
                    init_cmd  <= M_REG_SET;
                    init_ba   <= 2'b00;
                    init_addr <= 
                    {
                     3'b000,    //A12-A10:预留
                     1'b0,      //A9=0, 突发读&突发写，1：突发读&单写
                     3'b00,     //{A8,A7}=00:标准模式，默认
                     3'b011,    //{A6,A5,A4}=011: CAS 潜伏期，010：2，011：3，其他：保留
                     1'b0,      //A3=3:突发传输方式，0：顺序，1：隔行
                     3'b111     //{A2,A1,A0}=111: 突发长度，000：单字节，001：2字节， 
                                //010：4字节，011：8字节，111：整页，其他：保留
                    };
                end
            INIT_END:
                begin
                    init_cmd  <= NOP;
                    init_ba   <= 2'b11;
                    init_addr <= 13'h1ff;  
                end
            default:
                begin
                    init_cmd  <= NOP;
                    init_ba   <= 2'b11;
                    init_addr <= 13'h1ff;  
                end               
            endcase

assign init_end = (init_state == INIT_END)? 1'b1 : 1'b0;
            
            
endmodule 
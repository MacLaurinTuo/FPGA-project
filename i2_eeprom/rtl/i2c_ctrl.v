module  i2c_ctrl
#(
    parameter   DEVICE_ADDR     =  7'd1010_011   ,
    parameter   SYS_CLK_FREQ    =   'd50_000_000,
    parameter   SCL_FREQ        =   'd250_000   

)
(

    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire            wr_en       ,
    input   wire            rd_en       ,
    input   wire            i2c_start   ,
    input   wire            addr_num    ,
    input   wire    [15:0]  byte_addr   ,
    input   wire    [7:0]   wr_data     ,
    
    output  reg             i2c_clk     ,
    output  reg             i2c_end     ,
    output  reg     [7:0]   rd_data     ,
    output  reg             i2c_scl     ,
    output  wire            i2c_sda

);

parameter   I2C_CLK_MAX    =   (SYS_CLK_FREQ/SCL_FREQ) >> 3;
parameter   IDEL            <=  4'd00,
            START_1         <=  4'd01,   
            SEND_D_ADDR     <=  4'd02,
            ACK_1           <=  4'd03,
            SEND_B_ADDR_H   <=  4'd04,
            ACK_2           <=  4'd05,
            SEND_B_ADDR_L   <=  4'd06,
            ACK_3           <=  4'd07,
            WR_DATA         <=  4'd08,
            ACK_4           <=  4'd09,
            START_2         <=  4'd10,
            SEND_RD_ADDR    <=  4'd11,
            ACK_5           <=  4'd12,
            RD_DATA         <=  4'd13,
            N_ACK           <=  4'd14,
            STOP            <=  4'd15;
 
wire                 sda_en         ;   //sda数据写入使能信号
wire                 sda_in         ;   //sda数据写入寄存


reg     [7:0]       cnt_clk         ;   //系统时钟计数器，生成工作时钟i2c_clk
reg     [3:0]       state           ;   
reg     [1:0]       cnt_i2c_clk     ;   //i2c_clk时钟计数器，用于生成cnt_bit信号
reg                 cnt_i2c_clk_en  ;   //i2c_clk时钟计数器使能信号
reg     [2:0]       cnt_bit         ;   //sda比特计数器
reg                 ack             ;   //应答信号
reg                 i2c_sda_reg     ;   //sda数据缓存
reg     [7:0]       rd_data_reg     ;   //自i2c设备读出数据

//cnt_clk：系统时钟计数器，控制生成工作时钟i2c_clk，1MHZ
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk <= 8'd0;
    else    if(cnt_clk == I2C_CLK_MAX - 1'b1)
        cnt_clk <= 8'd0;
    else
        cnt_clk <= cnt_clk + 1'b1;
        
//i2c_clk：i2c驱动时钟     
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        i2c_clk <= 1'b1;
    else    if(cnt_clk == I2C_CLK_MAX - 1)
        i2c_clk <= ~i2c_clk;

//Cnt_ic2_clk_en： 计数器使能信号       
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        cnt_i2c_clk_en <= 1'b0;
    else    if(state == STOP && cnt_i2c_clk == 2'd3 && cnt_bit == 3'd3) //STOP第三个时钟周期cnt_bit=3并且串行时钟计数器cnt_i2c_clk =3时拉低
        cnt_i2c_clk_en <= 1'b0;
    else    if(i2c_start == 1'b1)
        cnt_i2c_clk_en <= 1'b1;
   
//cnt_i2c_clk : i2c_clk时钟计数器, 控制生成cnt_bit信号   
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        cnt_i2c_clk <= 2'd0;
    else    if(cnt_i2c_clk_en == 1'b1)
        cnt_i2c_clk <= cnt_i2c_clk + 1'b1;   
        
//cnt_bit：比特位计数器，方便状态的转移   
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_bit <= 3'd0;
    else    if(state == IDEL || state == START_1 || state == ACK_1 || state == ACK_2
                || state == ACK_3 || state == ACK_3 || state == ACK_4 || state == START_2
                || state == ACK_5 || state == N_ACK)
        cnt_bit <= 3'd0;
    else    if(cnt_i2c_clk == 2'd3 && cnt_bit == 3'd7)
        cnt_bit <= 3'd0;
    else    if(cnt_i2c_clk == 2'd3 && cnt_bit == 3'd3 && state == STOP)
        cnt_bit <= 3'd0;
    else    if(cnt_i2c_clk == 2'd3)
        cnt_bit <= cnt_bit + 1'b1;
        

//state: 状态机状态跳转
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        state <= IDLE;
    else
        case(state)
            IDEL:   
                if(i2c_start == 1'b1)
                    state <= START_1;
                else
                    state <= state;
                        
            START_1:   
                if(cnt_i2c_clk == 2'd3)
                    state <= SEND_D_ADDR;
                else
                    state <= state;
                            
            SEND_D_ADDR: //控制命令写入状态 
                if(cnt_bit == 3'd7 && cnt_i2c_clk == 2'd3)
                    state <= ACK_1;
                else
                    state <= state;
                    
            ACK_1:
                if(ack == 1'b0 && cnt_i2c_clk == 2'd3)//响应信号为有效的低电平
                    begin
                        if(addr_num == 1'b0)
                            state <= SEND_B_ADDR_L;
                        else
                            state <= SEND_B_ADDR_H;
                    end
                else
                    state <= state;              
                
            SEND_B_ADDR_H:
                if(cnt_bit == 3'd7 && cnt_i2c_clk == 2'd3)
                    state <= ACK_2;
                else
                    state <= state;               
                
            ACK_2:
                if(ack == 1'b0 && cnt_i2c_clk == 2'd3)//响应信号为有效的低电平
                    state <= SEND_B_ADDR_L;
                else
                    state <= state; 
                  
            SEND_B_ADDR_L:
                if(cnt_bit == 3'd7 && cnt_i2c_clk == 2'd3)
                    state <= ACK_3;
                else
                    state <= state;   
              
            ACK_3:
                if(ack == 1'b0 && cnt_i2c_clk == 2'd3)
                    begin
                        if(wr_en == 1'b1)  
                            state <= WR_DATA;
                        else    if(rd_en == 1'b1)
                            state <= START_2;
                        else
                            state <= state;
                    end          
                else
                    state <= state;
            
            WR_DATA:
                if(cnt_bit == 3'd7 && cnt_i2c_clk == 2'd3)
                    state <= ACK_4;
                else
                    state <= state;  
                    
            ACK_4:
                if(ack == 1'b0 && cnt_i2c_clk == 2'd3)
                    state <= STOP;
                else
                    state <= state;
                
            START_2:
                if(cnt_i2c_clk == 2'd3)
                    state <= SEND_RD_ADDR;
                else
                    state <= state;
              
            SEND_RD_ADDR:
                if(cnt_bit == 3'd7 && cnt_i2c_clk == 2'd3)
                    state <= ACK_5;
                else
                    state <= state; 
            
            ACK_5:
                if(ack == 1'b0 && cnt_i2c_clk == 2'd3)
                    state <= RD_DATA;
                else
                    state <= state;
                                
            RD_DATA:
                if(cnt_bit == 3'd7 && cnt_i2c_clk == 2'd3)
                    state <= N_ACK;
                else
                    state <= state;                
                
            N_ACK:
                if(cnt_i2c_clk == 2'd3)
                    state <= STOP;
                else
                    state <= state;
           
            STOP:
                if(cnt_bit == 3'd3 && cnt_i2c_clk == 2'd3)
                    state <= IDLE;
                else
                    state <= state;

            default:    
                    state <= IDLE;
        endcase
 
//ack : 应答信号，组合逻辑电路
always @(*)
    case(state)
        ACK_1, ACK_2, ACK_3, ACK_4, ACK_5 :
            if(cnt_i2c_clk == 2'd0)
                ack <= sda_in;
            else
                ack <= ack;
        default : ack <= 1'b1;
    endcase

//i2c_scl： 输出至i2c设备的串行时钟信号scl，组合逻辑电路
always @(*)//scl为高电平采集sda数据写入从机设备，低电平时sda进行数据更新
    case(state)
        IDEL : 
            i2c_scl <= 1'b1;              
        START_1:   
            if(cnt_i2c_clk == 2'd3)
                i2c_scl <= 1'b0;
            else
                i2c_scl <= 1'b1;            
        SEND_D_ADDR,ACK_1,SEND_B_ADDR_H, ACK_2,SEND_B_ADDR_L,ACK_3,WR_DATA,ACK_4,START_2,SEND_RD_ADDR, ACK_5,RD_DATA,N_ACK:
            if(cnt_i2c_clk == 2'd1 || cnt_i2c_clk == 2'd2)
                i2c_scl <= 1'b1;
            else
                i2c_scl <= 1'b0;            
        STOP:
            if(cnt_bit == 3'd0 && cnt_i2c_clk <= 2'd0)
                i2c_scl <= 1'b0;
            else
                i2c_scl <= 1'b1;
        default:  
            i2c_scl <= 1'b1;  
    endcase  
    
//i2c_sda_reg : sda数据缓存(读数据缓存rd_data_reg)
always @(*)
    case(state)
        IDEL : 
            begin
                i2c_sda_reg <= 1'b1;   
                rd_data_reg <= 8'd0;
            end
        START_1:   
            if(cnt_i2c_clk == 2'd0)
                i2c_sda_reg <= 1'b1;
            else
                i2c_sda_reg <= 1'b0;          
        SEND_D_ADDR:
            if(cnt_bit <= 3'd6)
                i2c_sda_reg <= DEVICE_ADDR[6 - cnt_bit];
            else
                i2c_sda_reg <= 1'b0;
        ACK_1:
            i2c_sda_reg <= 1'b1;
        SEND_B_ADDR_H:
            i2c_sda_reg <= byte_addr[15-cnt_bit];            
        ACK_2:
            i2c_sda_reg <= 1'b1;            
        SEND_B_ADDR_L:
            i2c_sda_reg <= byte_addr[7-cnt_bit];
        ACK_3:
            i2c_sda_reg <= 1'b1;        
        WR_DATA:
            i2c_sda_reg <= wr_data[7-cnt_bit];
        ACK_4:
            i2c_sda_reg <= 1'b1;           
        START_2:
            if(cnt_i2c_clk <= 2'd1)
                i2c_sda_reg <= 1'b1;
            else
                i2c_sda_reg <= 1'b0;                
        SEND_RD_ADDR:
            if(cnt_bit <= 3'd6)
                i2c_sda_reg <= DEVICE_ADDR[6 - cnt_bit];
            else
                i2c_sda_reg <= 1'b1;                
        ACK_5:
            i2c_sda_reg <= 1'b1;            
        RD_DATA:
            if(cnt_i2c_clk == 2'd2)
                rd_data_reg[7-cnt_bit] <= sda_in;
            else    
                rd_data_reg <= rd_data_reg;
        N_ACK:
            i2c_sda_reg <= 1'b1;            
        STOP:
            if(cnt_bit == 3'd0 && cnt_i2c_clk <= 2'd2)
                i2c_sda_reg <= 1'b0;
            else
                i2c_sda_reg <= 1'b1;
        default:
            begin        
                i2c_sda_reg <= 1'b1;
                rd_data_reg <= rd_data_reg;
            end            

    endcase

//rd_data:自i2c设备读出数据
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        rd_data <= 8'd0;
    else    if(state == RD_DATA && cnt_bit == 3'd7 && cnt_i2c_clk <= 2'd3)
        rd_data <= rd_data_reg;
        
//i2c_end: 一次读写结束信号
always @(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        i2c_end <= 1'b0;
    else    if(state == STOP && cnt_bit == 3'd3 && cnt_i2c_clk <= 2'd3)
        i2c_end <= 1'b1;
    else
        i2c_end <= 1'b0;

//sda_in ： sda输入数据寄存
assign   sda_in = i2c_sda;      

//sda_en ： sda数据写入使能信号
assign  sda_en = (state == ACK_1 || state == ACK_2 || state == ACK_3 ||
                  state == ACK_4 || state == ACK_5 || state == RD_DATA)?  1'b0 : 1'b1;
     
//i2c_sda :输出至i2c设备的串行数据信号sda，组合逻辑电路   
assign   i2c_sda <= (sda_en == 1'b1) ? i2c_sda_reg : 1'bz;


    
  
endmodule
module  flash_read_ctrl
(
    input   wire              sys_clk     ,
    input   wire              sys_rst_n   ,
    input   wire              key         ,
    input   wire              miso        ,
                              
    output  reg               sck         ,
    output  reg               cs_n        ,
    output  reg               mosi        ,
    output  reg               tx_flag     ,
    output  wire    [7:0]     tx_data     

);

parameter   IDLE  = 3'b001,
            READ  = 3'b010,
            SEND  = 3'b100;

            
parameter   READ_INST  = 8'b0000_0011,//读数据地址
            S_ADDR     = 8'b0000_0000,
            P_ADDR     = 8'b0000_0100,
            B_ADDR     = 8'b0010_0101;
parameter   NUM_DATA   = 8'd2;

parameter   CNT_WAIT_MAX =  16'd59999;           

                   

reg     [4:0]   cnt_clk         ;//时钟计数器，一个计数周期为一个字节
reg     [2:0]   state           ;//状态机
reg     [7:0]   cnt_byte        ;//字节计数器
reg     [1:0]   cnt_sck         ;//四分频计数器
reg     [2:0]   cnt_bit         ;//比特计数器
reg             miso_falg       ;//主输入从输出有效标志信号
reg     [7:0]   data            ;//进行数据拼接，串转并
reg     [7:0]   data_reg        ;//数据寄存器，存储拼接后的数据
reg             flag_reg        ;//拼接完成标志信号，确定拼接完成的位置
reg             fifo_wr_req     ;//写请求信号，对拼接完成标志信号打一拍，将数据写入到fifo中
wire    [7:0]   fifo_data_num   ;//fifo中写入数据个数
reg     [15:0]  cnt_wait        ;//读数据等待时间
reg             fifo_rd_req     ;//读请求信号
reg     [7:0]   read_data_num   ;//读出数据计数器
reg             fifo_read_valid ;//fifo读有效信号，此信号有效时才可以进行读操作


always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk <= 5'd0;
    else    if(state == READ)
        cnt_clk <= cnt_clk + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_byte <= 8'd0;
    else    if((cnt_byte == NUM_DATA + 8'd3) && (cnt_clk == 5'd31))
        cnt_byte <= 8'd0;
    else    if(cnt_clk == 5'd31)
        cnt_byte <= cnt_byte + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        state <= IDLE;
    else
        case(state)
            IDLE    :   if(key == 1'b1)
                            state <= READ;
            READ    :   if((cnt_byte == NUM_DATA + 8'd3) && (cnt_clk == 5'd31))
                            state <= SEND;
            SEND    :   if(cnt_wait == CNT_WAIT_MAX && read_data_num == NUM_DATA)
                            state <= IDLE;
            default :   state <= IDLE;
        
        endcase
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)        
        cnt_sck <= 2'd0;
    else    if(state == READ)
        cnt_sck <= cnt_sck + 1'b1;


always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        sck <= 1'b0;
    else    if(cnt_sck == 2'd0)
        sck <= 1'b0;
    else    if(cnt_sck == 2'd2)    
        sck <= 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_bit <= 3'd0;
    else    if(cnt_sck == 2'd3)
        cnt_bit <= cnt_bit + 1'b1;
        
// assign  cs_n = (state == WR_EN || state == BE) ? 1'b0 : 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        cs_n <= 1'b1;
    else    if(key == 1'b1)
        cs_n <= 1'b0;
    else    if(cnt_byte == 8'd5 && cnt_clk == 5'd31)
        cs_n <= 1'b1;
    else
        cs_n <= cs_n;
         
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        mosi <= 1'b0;
    else    if(state == READ && cnt_byte == 8'd4)
        mosi <= 1'b0;                       
    else    if(state == READ && cnt_byte == 8'd0 && cnt_sck  == 2'd0)
        mosi <= READ_INST[7 - cnt_bit];     
    else    if(state == READ && cnt_byte == 8'd1 && cnt_sck  == 2'd0)
        mosi <= S_ADDR[7 - cnt_bit];        
    else    if(state == READ && cnt_byte == 8'd2 && cnt_sck  == 2'd0)
        mosi <= P_ADDR[7 - cnt_bit];        
    else    if(state == READ && cnt_byte == 8'd3 && cnt_sck  == 2'd0)
        mosi <= B_ADDR[7 - cnt_bit];

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        miso_falg <= 1'b0;
    else    if(cnt_byte >= 8'd4 && cnt_sck == 2'd1)
        miso_falg <= 1'b1;
    else
        miso_falg <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data <= 8'd0;
    else    if(miso_falg == 1'b1)
        data <= {data[6:0], miso};
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)    
        flag_reg <= 1'b0;
    else    if(cnt_bit == 3'd7 && miso_falg == 1'b1)
        flag_reg <= 1'b1;
    else
        flag_reg <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data_reg <= 8'd0;
    else    if(flag_reg == 1'b1)
        data_reg <= data;
    else    
        data_reg <= data_reg;
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        fifo_wr_req <= 1'b0;
    else
        fifo_wr_req <= flag_reg;
  
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)    
        fifo_read_valid <= 1'b0;
    else    if(fifo_data_num == NUM_DATA)
        fifo_read_valid <= 1'b1;
    else    if(read_data_num == NUM_DATA && cnt_wait == CNT_WAIT_MAX)
        fifo_read_valid <= 1'b0;
 
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        cnt_wait <= 16'd0;
    else    if(cnt_wait == CNT_WAIT_MAX)
        cnt_wait <= 16'd0;
    else    if(fifo_read_valid == 1'b1)
        cnt_wait <= cnt_wait + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        fifo_rd_req <= 1'b0;
    else    if(cnt_wait == CNT_WAIT_MAX && read_data_num < NUM_DATA)
        fifo_rd_req <= 1'b1;
    else    
        fifo_rd_req <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        read_data_num <= 8'd0;
    else    if(fifo_read_valid == 1'b0)
        read_data_num <= 8'd0;
    else    if(fifo_rd_req == 1'b1)
        read_data_num <= read_data_num + 1'b1;
    else
        read_data_num <= read_data_num;
    
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
       tx_flag <= 1'b0;
    else 
       tx_flag <= fifo_rd_req;


scfifo_256x8	scfifo_256x8_inst (
	.clock ( sys_clk       ),
	.data  ( data_reg      ),
	.rdreq ( fifo_rd_req   ),
	.wrreq ( fifo_wr_req   ),
           
	.q     ( tx_data       ),
	.usedw ( fifo_data_num )
	);     
    

endmodule    







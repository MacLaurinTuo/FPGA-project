module  freq_meter_ctrl
#(
    parameter   CNT_GATE_S_MAX = 28'd74_999_999,    //软件闸门计数器计数最大值
    parameter   CNT_RISE_MAX = 28'd12_500_000,      //软件闸门拉高计数值
    parameter   CLK_STAND_FREQ = 28'd100_000_001    //标准时钟频率
)
(
    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire            clk_test    ,
    
    output  reg     [31:0]  freq

);

wire            clk_stand;          //标准时钟
reg     [27:0]  cnt_gate_s;         //软件门闸计数器
reg             gate_s;             //软件闸门
reg             gate_a;             //实际闸门

reg     [31:0]  cnt_clk_test;       //实际闸门周期计数器(待测时钟下)
reg             gate_a_test;        //实际闸门打一拍（待测时钟下）
wire            gate_a_fall_test;   //实际闸门下降沿（待测时钟下）    
reg     [31:0]  cnt_clk_test_reg;   //实际闸门下待测时钟周期数

reg     [31:0]  cnt_clk_stand;      //实际闸门周期计数器(标准时钟下)
reg             gate_a_stand;       //实际闸门打一拍（标准时钟下）
wire            gate_a_fall_stand;  //实际闸门下降沿（标准时钟下）
reg     [31:0]  cnt_clk_stand_reg;  //实际闸门下标准时钟周期数

reg             calc_flag;          //计算标志信号
reg             calc_flag_reg;      //时钟频率输出标志信号
reg     [63:0]  freq_reg;           //待测时钟频率

wire            locked_sig;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_gate_s <= 28'd0;
    else if(cnt_gate_s == CNT_GATE_S_MAX)
        cnt_gate_s <= 28'd0;
    else
        cnt_gate_s <= cnt_gate_s + 1'b1;
        
// always@(posedge sys_clk or negedge sys_rst_n)
    // if(sys_rst_n == 1'b0)
        // gate_s <= 1'b0;
    // else    if(cnt_gate_s >= CNT_RISE_MAX-1 && 
               // cnt_gate_s < CNT_GATE_S_MAX - CNT_RISE_MAX)
        // gate_s <= 1'b1;
    // else
        // gate_s <= 1'b0;
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_s <= 1'b0;
    else    if(cnt_gate_s == CNT_RISE_MAX-1)
        gate_s <= 1'b1;
    else    if(cnt_gate_s == CNT_GATE_S_MAX - CNT_RISE_MAX)
        gate_s <= 1'b0;
    else
        gate_s <= gate_s;
        
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)       
        gate_a <= 1'b0;
    else
        gate_a <= gate_s;

always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        cnt_clk_test <= 32'd0;
    else    if(gate_a == 1'b0)
        cnt_clk_test <= 32'd0;
    else    if(gate_a == 1'b1)
        cnt_clk_test <= cnt_clk_test + 1'b1;

always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        gate_a_test <= 1'b0;
    else    
        gate_a_test <= gate_a;

assign gate_a_fall_test = (gate_a == 1'b0 && gate_a_test == 1'b1)? 1'b1 : 1'b0;

always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        cnt_clk_test_reg <= 32'd0;
    else    if(gate_a_fall_test == 1'b1)
        cnt_clk_test_reg <= cnt_clk_test;
    else
        cnt_clk_test_reg <= cnt_clk_test_reg;   
        
always@(posedge clk_stand or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)            
        cnt_clk_stand <= 32'd0;
    else    if(gate_a == 1'b0)
        cnt_clk_stand <= 32'd0;
    else    if(gate_a == 1'b1)
        cnt_clk_stand <= cnt_clk_stand + 1'b1;
        
always@(posedge clk_stand or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)          
        gate_a_stand <= 1'b0;
    else   
        gate_a_stand <= gate_a;

assign gate_a_fall_stand = (gate_a == 1'b0 && gate_a_stand == 1'b1)? 1'b1 : 1'b0;

always@(posedge clk_stand or negedge sys_rst_n)
    if(sys_rst_n == 1'b0) 
        cnt_clk_stand_reg <= 32'd0;
    else    if(gate_a_fall_stand == 1'b1)
        cnt_clk_stand_reg <= cnt_clk_stand;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)   
        calc_flag <= 1'b0;
    else    if(cnt_gate_s == CNT_GATE_S_MAX)
        calc_flag <= 1'b1;
    else    
        calc_flag <= 1'b0;
//freq_reg在计算过程中，位宽超过32位，应增加足够位宽的寄存器
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)      
        freq_reg <= 64'd0;
    else    if(calc_flag == 1'b1)
        freq_reg <= ( CLK_STAND_FREQ * cnt_clk_test_reg / cnt_clk_stand_reg );

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  
        calc_flag_reg <= 1'b0;
    else
        calc_flag_reg <= calc_flag;

always@(posedge sys_clk or negedge sys_rst_n)//
    if(sys_rst_n == 1'b0)  
        freq <= 32'd0;
    else    if(calc_flag_reg == 1'b1)
        freq <= freq_reg[31:0];
    

clk_stand_gen	clk_stand_gen_inst (
	.areset ( ~sys_rst_n ),
	.inclk0 ( sys_clk    ),
	.c0     ( clk_stand  ),
	.locked ( locked_sig )
	);

    
endmodule
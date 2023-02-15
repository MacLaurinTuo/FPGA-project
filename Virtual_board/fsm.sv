`default_nettype 
module  fsm(
    input   clk, acc, brake, reset,
    output  [1:0]   speed

);

enum{
    STOP   = 4'b0000,
    LOW    = 4'b0010,
    MEDIUM = 4'b0100,
    HIGH   = 4'b1000

}state, next_state;
//状态变换（时序）
always @(posedge clk or negedge reset) begin
    if(reset)   state <= STOP;
    else        state <= next_state;
end
//次态计算（组合）
always_comb begin
    case(state)
        STOP : 
            if(acc && !brake)
                next_state = LOW;
            else
                next_state = STOP;
        LOW  :
            if(acc && !brake)
                next_state = MEDIUM;
            else
                next_state = STOP;          
        MEDIUM :
            if(acc && !brake)
                next_state = HIGH;
            else
                next_state = LOW; 
        HIGH  :
            if(brake)
                next_state = MEDIUM;
            else
                next_state = HIGH;
    endcase
    
end
//输出逻辑（组合）

always @(state)
    case(state)
        STOP :   speed = 2'b00;
        LOW  :   speed = 2'b01;
        MEDIUM : speed = 2'b10;
        HIGH  :  speed = 2'b11;
    endcase


endmodule
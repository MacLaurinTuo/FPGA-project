module simple_fsm
(
    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    input   wire    pi_money    ,

    output  reg     po_cola     

);

reg     [2:0]   state;
parameter   
    IDLE    =   3'b001,
    ONE     =   3'b010,
    TWO     =   3'b100;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        state <= IDLE;
    else    
        case(state)
        
            IDLE    :   if(pi_money == 1'b1)
                            state <= ONE;
                        else
                            state <= IDLE;
                            
            ONE     :   if(pi_money == 1'b1)
                            state <= TWO;
                        else
                            state <= ONE;
                            
            TWO     :   if(pi_money == 1'b1) 
                            state <= IDLE;
                        else
                            state <= TWO;
            default :
                        state <= IDLE;
        endcase
        
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        po_cola <= 1'b0;                      
    else    if(pi_money == 1'b1 && state == TWO)
        po_cola <= 1'b1;
    else 
        po_cola <= 1'b0;
        
endmodule
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                            
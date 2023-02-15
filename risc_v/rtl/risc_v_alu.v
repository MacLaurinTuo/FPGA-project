module  risc_v_alu(

    input   wire    [3:0]   alu_ctl,
    input   wire    [63:0]  a      ,
    input   wire    [63:0]  b      ,
    
    output  reg     [63:0]  alu_out,
    output  wire            zero

);

always@(*)  begin
    case(alu_ctl)   begin
       4'b0000  :   alu_out <= a & b;
       4'b0001  :   alu_out <= a | b;
       4'b0010  :   alu_out <= a + b;
       4'b0110  :   alu_out <= a - b;
       4'b0111  :   alu_out <= (a < b)? 1 : 0;
       4'b1100  :   alu_out <= ~(a | b);
       default  :   alu_out <= 0;
    endcase
    end
        
end

assign  zero = (alu_out == 0);


endmodule
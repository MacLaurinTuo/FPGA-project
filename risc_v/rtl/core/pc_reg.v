`include "defines.v"

module pc_reg(

    input   wire    clk,
    input   wire    rst,

    input   wire    jump_flag_i,                    //跳转标志
    input   wire    [`InstAddrBus]   jump_addr_i,   //跳转地址
    input   wire    [`Hold_Flag_Bus] hold_flag_i,   //流水线暂停标志
    input   wire    jtag_reset_flag_i,              //复位标志

    output  reg     [`InstAddrBus]  pc_o            //pc指针

);

always @(posedge clk) begin
    //复位
    if(rst == `RstEnable || jtag_reset_flag_i == 1'b1)begin
        pc_o <= `CpuResetAddr;
    //跳转
    end else if(jump_flag_i == `JumpEnable)begin
        pc_o <= jump_addr_i;
    //暂停
    end else if(hold_flag_i >= `Hold_Pc)begin
        pc_o <= pc_o;
    //地址自加4
    end else begin
        pc_o <= pc_o + 4'h4;
    end
end
endmodule
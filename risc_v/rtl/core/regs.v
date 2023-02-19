`include "defines.v"
module regs (
    input   wire    clk,
    input   wire    rst,


    //from ex
    input   wire    we_i,                           //写寄存器标志   
    input   wire    [`RegAddrBus]   waddr_i,        //写寄存器地址
    input   wire    [`RegBus    ]   wdata_i,        //写寄存器数据

    //from jtag
    input   wire    jtag_we_i,                       //写寄存器标志   
    input   wire    [`RegAddrBus]   jtag_addr_i,     //读、写寄存器地址
    input   wire    [`RegBus    ]   jtag_data_i,     //写寄存器数据

    //from id
    input   wire    [`RegAddrBus]   raddr1_i,        //读寄存器1地址
    inout   wire    [`RegAddrBus]   raddr2_i,        //读寄存器2地址 

    //to id
    output  reg     [`RegBus    ]   rdata1_o,        //读寄存器1数据
    output  reg     [`RegBus    ]   rdata2_o,        //读寄存器2数据

    //to jtag
    output  reg     [`RegBus    ]   jtag_data_o      //读寄存器数据

);

reg     [`RegBus]   regs    [0 : `RegNum - 1];

//写寄存器
always @(posedge clk) begin

    if(rst == `RstDisable)begin
        //优先ex模块写操作
        if((we_i == `WriteEnable) && (waddr_i != `ZeroReg))begin
            regs[waddr_i] <= wdata_i;
        end else if((jtag_we_i == `WriteEnable) && (jtag_addr_i != `ZeroReg))begin
            regs[waddr_i] <= jtag_data_i;
        end
    end
end

//读寄存器1
always @(*)begin 
    //读寄存器0(x0)，直接返回0
    if(raddr1_i == `ZeroReg)begin
       rdata1_o =  `ZeroWord;
    //如果读地址等于写地址，并且正在写操作，则直接返回写数据(前递操作，处理数据冒险)
    end else if((waddr_i == raddr1_i) && (we_i == `WriteEnable))begin
        rdata1_o = wdata_i;
    end else begin
        rdata1_o = regs[raddr1_i];//异步读方式，给出读地址，马上得到读数据（占用逻辑资源）；
                                  //而FPGA专门的存储资源不支持异步访问，读出需要时钟(慢一拍)
    end
end

//读寄存器2
always @(*)begin 
    if(raddr2_i == `ZeroReg)begin
        rdata2_o = `ZeroWord;
    end else if((raddr2_i == waddr_i) && (we_i == `WriteEnable))begin
        rdata2_o = wdata_i;
    end else begin
        rdata2_o = regs[raddr2_i];
    end
end

//jtag读寄存器

always @(*)begin
    if(jtag_addr_i == `ZeroReg)begin
        jtag_data_o = `ZeroWord;
    end else begin
        jtag_data_o = regs[jtag_addr_i];
    end
end



    
endmodule
`include "defines.v"

//译码模块
//纯组合逻辑电路

module id (
    input   wire    rst,

    //from if_id
    input   wire    [`InstBus]  inst_i,             //指令内容
    input   wire    [`InstAddrBus]  inst_addr_i,    //指令地址

    //from regs 
    input   wire    [`RegBus]   reg1_rdata_i,       //通用寄存器1输入数据
    input   wire    [`RegBus]   reg2_rdata_i,       //通用寄存器2输入数据

    //from csc reg
    input   wire    [`RegBus]   csr_rdata_i,        //CSR寄存器输入数据

    //from ex
    input   wire    ex_jump_flag_i,                 //跳转标志

    //to regs 
    output  wire    [`RegAddrBus]   reg1_raddr_o,   //读通用寄存器1地址
    output  wire    [`RegAddrBus]   reg2_raddr_o,   //读通用寄存器2地址

    //to csr reg
    output  wire    [`MemAddrBus]   csr_raddr_o,    // 读CSR寄存器地址

    //to ex
    output  reg     [`MemAddrBus]   op1_o,          //从指令解析出来的操作数1
    output  reg     [`MemAddrBus]   op2_o,          //从指令解析出来的操作数1
    output  reg     [`MemAddrBus]   op1_jump_o,     //从指令解析出来的跳转地址1
    output  reg     [`MemAddrBus]   op2_jump_o,     //从指令解析出来的跳转地址2

    output  reg     [`InstBus]      inst_o,         //指令内容
    output  reg     [`InstAddrBus]  inst_addr_o,    //指令地址
    output  reg     [`RegBus]       reg1_rdata_o,   //通用寄存器1数据
    output  reg     [`RegBus]       reg2_rdata_o,   //通用寄存器2数据

    output  reg                     reg_we_o,       //写通用寄存器标志
    output  reg     [`RegAddrBus]   reg_waddr_o,    //写通用寄存器地址
    output  reg                     csr_we_o,       //写CSR寄存器标志
    output  reg     [`RegBus]       csr_rdata_o,    //CSR寄存器数据    
    output  reg     [`MemAddrBus]   csr_waddr_o     //写CSR寄存器地址

);
    

//将一条32位的指令分为6个部分，顺序如下
//funct7、rs2、rs1、funct3、rd、opcode
wire    [6:0]   funct7 = inst_i[31:25];             //功能2，由funct7和funct3共同确定一条具体的指令
wire    [4:0]   rs2    = inst_i[24:20];             //源寄存器2、立即数
wire    [4:0]   rs1    = inst_i[19:15];             //源寄存器1、立即数
wire    [2:0]   funct3 = inst_i[14:12];             //功能1，由funct7和funct3共同确定一条具体的指令
wire    [4:0]   rd     = inst_i[11: 7];             //目标寄存器、立即数
wire    [6:0]   opcode = inst_i[6 : 0];             //操作码，指出该指令需要完成操作的类型或性质

always @(*) begin
    inst_o       = inst_i;
    inst_addr_o  = inst_addr_i;
    reg1_rdata_o = reg1_rdata_i;
    reg2_rdata_o = reg2_rdata_i;
    csr_rdata_o  = csr_rdata_i;
    csr_raddr_o  = `ZeroWord;
    csr_waddr_o  = `ZeroWord;
    csr_we_o     = `WriteDisable;
    op1_o        = `ZeroWord;
    op2_o        = `ZeroWord;
    op1_jump_o   = `ZeroWord;
    op2_jump_o   = `ZeroWord;

    case (opcode)
        `INST_TYPE_I: begin
            case(funct3)
            //ADDI:将立即数和 rs1 相加并写入 rd 中；SLTI, SLTIU(无符号):rs1小于立即数则置 1，否者置 0；XORI：立即数异或，rs1 和立即数按位异或并写入 rd中；
            //ANDI：rs1 和立即数按位异或并写入 rd中；SLLI:立即数逻辑左移，rs1 左移 shamt 位，空位填 0 并写入 rd 中；SRI:逻辑右移，rs1 右移 rs2位，空位填 0 并写入 rd 中；
                `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ANDI, `INST_SLLI, `INST_SRI: begin
                    reg_we_o     = `WriteEnable;    //写通用寄存器标志
                    reg_waddr_o  = rd;              //目标寄存器（写通用寄存器地址）
                    reg1_raddr_o = rs1;             //源寄存器1的地址，去通用寄存器模块中取reg1_rdata_i数据。
                    reg2_raddr_o = `ZeroReg;
                    op1_o = reg1_rdata_i;           //rs1地址从reg中取回的数据。
                    op2_o = {{20{inst_i[31]}}, inst_i[31:20]}; //指令中的立即数
                end
                default: begin
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg;
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;
                end
            endcase
        end 
        `INST_TYPE_R_M: begin
            if((funct7 == 7'b0000000) || (funct7 == 7'b0100000))begin
                //ADD_SUB:  rs1和rs2相加(减)并写入rd中；SLL：逻辑左移，rs1左移rs2位，空位填0并写入rd中；SR:srl是逻辑右移，rs1右移rs2位，空位填0并写入rd中；
                //SLT/SLTU：有符号/无符号的比较指令，即rs1小于rs2则置1，否者置0；XOR/OR/AND:rs1和rs2按位异或/或/与并写入rd中；
                case(funct3)
                    `INST_ADD_SUB, `INST_SLL, `INST_SLT, `INST_SLTU, `INST_XOR, `INST_SR, `INST_OR, `INST_AND: begin
                        reg_we_o     = `WriteEnable;    //写通用寄存器标志
                        reg_waddr_o  = rd;              //目标寄存器（写通用寄存器地址）
                        reg1_raddr_o = rs1;             //源寄存器1的地址，去通用寄存器模块中取reg1_rdata_i数据。
                        reg2_raddr_o = rs2;
                        op1_o = reg1_rdata_i;           //rs1地址从reg中取回的数据。
                        op2_o = reg2_rdata_i; //指令中的立即数
                    end
                    default: begin
                        reg_we_o     = `WriteDisable;
                        reg_waddr_o  = `ZeroReg;
                        reg1_raddr_o = `ZeroReg;
                        reg2_raddr_o = `ZeroReg;
                    end
                endcase
            end else if(funct7 == 7'b0000001)begin      
                case(funct3)
                //MUL:乘法取低位；MULHU/MULH：全无符号/全有符号乘法取高位；MULHSU：一个无符号一个有符号乘法取高位
                    `INST_MUL, `INST_MULHU, `INST_MULH, `INST_MULHSU: begin
                        reg_we_o     = `WriteEnable;    //写通用寄存器标志
                        reg_waddr_o  = rd;              //目标寄存器（写通用寄存器地址）
                        reg1_raddr_o = rs1;             //源寄存器1的地址，去通用寄存器模块中取reg1_rdata_i数据。
                        reg2_raddr_o = rs2;
                        op1_o = reg1_rdata_i;           //rs1地址从reg中取回的数据。
                        op2_o = reg2_rdata_i; //指令中的立即数
                   end
                //DIV 除有符号数32位数字；DIVU：除无符号数32位数字；REM：对有符号数32位除法取余；REMU：对无符号数32位除法取余；
                    `INST_DIV, `INST_DIVU, `INST_REM, `INST_REMU: begin
                        reg_we_o     = `WriteDisable;    
                        reg_waddr_o  = rd;            
                        reg1_raddr_o = rs1;           
                        reg2_raddr_o = rs2;
                        op1_o = reg1_rdata_i;        
                        op2_o = reg2_rdata_i;
                        op1_jump_o = inst_addr_i;       //？？？？？？？？？？？
                        op2_jump_o = 32'h4;             //？？？？？？？？？？？
                    end
                    default: begin
                        reg_we_o     = `WriteDisable;
                        reg_waddr_o  = `ZeroReg;
                        reg1_raddr_o = `ZeroReg;
                        reg2_raddr_o = `ZeroReg;
                    end
                endcase
            end else begin
                reg_we_o     = `WriteDisable;
                reg_waddr_o  = `ZeroReg;
                reg1_raddr_o = `ZeroReg;
                reg2_raddr_o = `ZeroReg;
            end
        end
        `INST_TYPE_L: begin
            case (funct3)   
                //LB:取字节；LH：取半字；LW：取字；LBU：取无符号字节；LHU：取无符号半字 到寄存器
                `INST_LB, `INST_LH, `INST_LW, `INST_LBU, `INST_LHU: begin
                    reg1_raddr_o = rs1;
                    reg2_raddr_o = `ZeroReg;
                    reg_we_o     = `WriteEnable;
                    reg_waddr_o  = rd;
                    op1_o        = reg1_rdata_i;
                    op2_o        = {{20{inst_i[31]}}, inst_i[31:20]};
                end 
                default: begin
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;                    
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg; 
                end
            endcase
        end

        `INST_TYPE_S: begin
            case(funct3)
            //sb 是存字节，把 rs2 的低位一字节存入地址 rs1+立即数中；sh 是存半字，把 rs2的低位两字节存入地址 rs1+立即数中；
            //sw 是存字，把 rs2 的低位四字节存入地址 rs1+立即数中。
                `INST_SB, `INST_SW, `INST_SH: begin
                    reg1_raddr_o = rs1;
                    reg2_raddr_o = rs2;                    
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg;
                    op1_o        = reg1_rdata_i;
                    op2_o        = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
                end
                default: begin
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;                    
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg; 
                end               
            endcase
        end
        `INST_TYPE_B: begin
            case(funct3)
            //beq 是相等条件分支，rs1 和 rs2 的值相等时，把 pc 的值设置成当前值+偏移值；
            // bne 是不等条件分支，rs1 和 rs2 的值不等时，把 pc 的值设置成当前值+偏移值；
            // blt 是小于条件分支，rs1 小于 rs2 的值时，把 pc 的值设置成当前值+偏移值；
            // bge是大于等于条件分支，rs1 大于等于 rs2 的值时，把 pc 的值设置成当前值+偏移值；
            // bltu 是无符号小于条件分支；
            // bgeu 是无符号大于等于条件分支；
            // jal 是跳转并链接，把 pc 设置成当前值+偏移值，然后将 pc+4 当做下一条指令的地址存入 rd 中；
            // jalr 跳转并链接，把 pc 设置成 rs1+偏移值，然后将 pc+4 写入 rd 中。
                `INST_BEQ, `INST_BNE, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU: begin    
                    reg1_raddr_o = rs1;
                    reg2_raddr_o = rs2;                    
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg;
                    op1_o        = reg1_rdata_i;
                    op2_o        = reg2_rdata_i;
                    op1_jump_o   = inst_addr_i;
                    //12位立即数地址字段进行符号扩展，在左移一位
                    op2_jump_o   = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                end        
                default: begin
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;                    
                    reg_we_o     = `WriteDisable;
                    reg_waddr_o  = `ZeroReg; 
                end    
            endcase
        end
        //无条件跳转指令，jal跳转并链接(jal x1, 100) x1 = pc + 4; go to pc + 100   PC相对过程调用
        //可在jal x1, 100命令后利用jalr x0, 0(x1)将控制返还给调用者x0硬连线为0，效果是丢弃返还地址。
        `INST_JAL: begin
            reg_we_o = `WriteEnable;
            reg_waddr_o = rd;
            reg1_raddr_o = `ZeroReg;
            reg2_raddr_o = `ZeroReg;         
            op1_o        = inst_addr_i;
            op2_o        = 32'h4;
            op1_jump_o   = inst_addr_i;
            op2_jump_o   = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
        end
        //jalr跳转并连接到寄存器所指位置(jalr x1, 100(x5)) x1 = pc + 4; go to x5 + 100  过程返回，间接调用
        `INST_JALR: begin
            reg_we_o     = `WriteEnable;
            reg1_raddr_o = rs1;
            reg2_raddr_o = `ZeroReg;
            reg_waddr_o  = rd;
            op1_o        = inst_addr_i;
            op2_o        = 32'h4;
            op1_jump_o   = reg1_rdata_i;
            op2_jump_o   = {20{inst_i[31]}, inst_i[31:20]};

        end
        //取立即数高位，取左移12位后的20位立即数
        `INST_LUI: begin
            reg_we_o     = `WriteEnable;
            reg_waddr_o  = rd;
            reg1_raddr_o = `ZeroReg;
            reg2_raddr_o = `ZeroReg;  
            op1_o        = inst_addr_i;
            op2_o        = {inst_i[31:12], 12'b0};
        end
        //auipc x5, 0x12345, x5 = pc + 0x12345000加立即数高位到PC，用作程序计数器相对寻址
        `INST_AUIPC: begin
            reg_we_o = `WriteEnable;
            reg_waddr_o = rd;
            reg1_raddr_o = `ZeroReg;
            reg2_raddr_o = `ZeroReg;
            op1_o        = inst_addr_i;
            op2_o        = {inst_i[31:12], 12'b0};
        end
        `INST_NOP_OP: begin
            reg_we_o     = `WriteDisable;
            reg_waddr_o  = `ZeroReg;
            reg1_raddr_o = `ZeroReg;
            reg2_raddr_o = `ZeroReg;                       
        end
        `INST_FENCE: begin
            reg_we_o     = `WriteDisable;
            reg_waddr_o  = `ZeroReg;
            reg1_raddr_o = `ZeroReg;
            reg2_raddr_o = `ZeroReg;
            op1_jump_o   = inst_addr_i;
            op2_jump_o   = 32'h4;
        end

        `INST_CSR: begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            reg1_raddr_o = `ZeroReg;
            reg2_raddr_o = `ZeroReg;
            csr_raddr_o = {20'h0, inst_i[31:20]};
            csr_waddr_o = {20'h0, inst_i[31:20]};
            case (funct3)
            //csrrw rd, csr, zimm[4:0] t = CSRs[csr]; CSRs[csr] = x[rs1]; x[rd] = t
            //读后写控制状态寄存器,I-type,记控制状态寄存器 csr 中的值为 t。把寄存器 x[rs1]的值写入 csr，再把 t 写入 x[rd]。
            //csrrs rd, csr, rs1 t = CSRs[csr]; CSRs[csr] = t | x[rs1]; x[rd] = t
            //读后置位控制状态寄存器I-type,记控制状态寄存器 csr 中的值为 t。把 t 和寄存器 x[rs1]按位或的结果写入 csr，再把 t 写入x[rd]。
            // csrrc rd, csr, rs1 t = CSRs[csr]; CSRs[csr] = t &~x[rs1]; x[rd] = t
            // 读后清除控制状态寄存器 I-type,记控制状态寄存器 csr 中的值为 t。把 t 和寄存器 x[rs1]按位与的结果写入 csr，再把 t 写入x[rd]。
                `INST_CSRRW, `INST_CSRRS, `INST_CSRRC: begin
                    reg1_raddr_o = rs1;
                    reg2_raddr_o = `ZeroReg;
                    reg_we_o = `WriteEnable;
                    reg_waddr_o = rd;
                    csr_we_o = `WriteEnable;
                end
            //csrrwi rd, csr, zimm[4:0] x[rd] = CSRs[csr]; CSRs[csr] = zimm
            // 立即数读后写控制状态寄存器  I-type, 把控制状态寄存器 csr 中的值拷贝到 x[rd]中，再把五位的零扩展的立即数 zimm 的值写入csr。

                `INST_CSRRWI, `INST_CSRRSI, `INST_CSRRCI: begin
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;
                    reg_we_o = `WriteEnable;
                    reg_waddr_o = rd;
                    csr_we_o = `WriteEnable;
                end
                default: begin
                    reg_we_o = `WriteDisable;
                    reg_waddr_o = `ZeroReg;
                    reg1_raddr_o = `ZeroReg;
                    reg2_raddr_o = `ZeroReg;
                    csr_we_o = `WriteDisable;
                end
            endcase
        end

        default: begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            reg1_raddr_o = `ZeroReg;
            reg2_raddr_o = `ZeroReg;
        end
    endcase
   
end


endmodule
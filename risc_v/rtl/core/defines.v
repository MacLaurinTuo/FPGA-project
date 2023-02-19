

`define CpuResetAddr 32'h0


`define RstEnable 1'b0
`define RstDisable 1'b1
`define ZeroWord 32'h0
`define ZeroReg 5'h0
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define JumpEnable 1'b1
`define JumpDisable 1'b0

`define INT_BUS 7:0
`define INT_NONE 8'h0
`define INT_RET 8'hff
`define INT_TIMER0 8'b00000001
`define INT_TIMER0_ENTRY_ADDR 32'h4

`define Hold_Flag_Bus   2:0
`define Hold_None 3'b000
`define Hold_Pc   3'b001
`define Hold_If   3'b010
`define Hold_Id   3'b011


`define InstBus 31:0
`define InstAddrBus 31:0

//common regs

`define RegAddrBus 4:0
`define RegBus 31:0
`define RegNum 32  


// CSR reg addr

`define InstAddrBus 31:0
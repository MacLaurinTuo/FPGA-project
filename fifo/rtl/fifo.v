module  fifo
(
    input   wire            sys_clk     ,
    input   wire            wr_reg      ,
    input   wire            rd_reg      ,
    input   wire    [7:0]   pi_data     ,

    output  wire            full        ,      
    output  wire            empty       ,      
    output  wire    [7:0]   usedw       ,      
    output  wire    [7:0]   po_data           

);


scfifo_8x256	scfifo_8x256_inst 
(
	.clock ( sys_clk   ),
	.data  ( pi_data   ),
	.rdreq ( rd_reg    ),
	.wrreq ( wr_reg    ),
	.empty ( empty     ),
	.full  ( full      ),
	.q     ( po_data   ),
	.usedw ( usedw     )
);


endmodule
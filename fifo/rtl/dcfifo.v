module  dcfifo
(
    input   wire            wr_clk      ,
    input   wire            wr_req      ,
    input   wire    [7:0]   wr_data     ,
    input   wire            rd_clk      ,
    input   wire            rd_req      ,
                          
    output  wire            wr_full     ,
    output  wire            wr_empty    ,
    output  wire    [9:0]   wr_usedw    ,
    output  wire            rd_full     ,
    output  wire            rd_empty    ,
    output  wire    [8:0]   rd_usedw    ,
    output  wire    [15:0]  rd_data     


);


dcfifo_8x256to16x128	dcfifo_8x256to16x128_inst 
(
	.data    ( wr_data ),
	.rdclk   ( rd_clk ),
	.rdreq   ( rd_req ),
	.wrclk   ( wr_clk ),
	.wrreq   ( wr_req ),
	.q       ( rd_data ),
	.rdempty ( rd_empty ),
	.rdfull  ( rd_full ),
	.rdusedw ( rd_usedw ),
	.wrempty ( wr_empty ),
	.wrfull  ( wr_full ),
	.wrusedw ( wr_usedw )
);

endmodule
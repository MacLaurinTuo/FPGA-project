module  pingpang(

    input   wire    sys_clk     ,
    input   wire    sys_rst_n   ,
    
    output  wire    [15:0]  data_out
);


wire    clk_25m;
wire    clk_50m;
wire    locked;
wire    rst_n = locked && sys_rst_n;
wire    data_en;
wire    [7:0]   data_in;

wire    [15:0]    ram1_rd_data;
wire    [15:0]    ram2_rd_data;                  
wire              ram1_wr_en  ;
wire    [6:0]     ram1_wr_addr;
wire    [7:0]     ram1_wr_data;
wire              ram2_wr_en  ;
wire    [6:0]     ram2_wr_addr;
wire    [7:0]     ram2_wr_data;
wire              ram1_rd_en  ;
wire    [5:0]     ram1_rd_addr;
wire              ram2_rd_en  ;
wire    [5:0]     ram2_rd_addr;


clk_gen	clk_gen_inst 
(
	.areset ( ~sys_rst_n ),
	.inclk0 ( sys_clk    ),
	.c0     ( clk_25m    ),
	.c1     ( clk_50m    ),
	.locked ( locked     )
);

data_gen    data_gen_inst
(
    .clk_50m (clk_50m),   
    .rst_n   (rst_n  ),   
   
    .data_en (data_en),
    .data_in (data_in)

);   

ram_ctrl    ram_ctrl_inst
(
    .clk_25m     (clk_25m     ),
    .clk_50m     (clk_50m     ),
    .rst_n       (rst_n       ),
    .data_en     (data_en     ),
    .data_in     (data_in     ),
    .ram1_rd_data(ram1_rd_data),
    .ram2_rd_data(ram2_rd_data),
   
    .ram1_wr_en  (ram1_wr_en  ),
    .ram1_wr_addr(ram1_wr_addr),
    .ram1_wr_data(ram1_wr_data),
    .ram2_wr_en  (ram2_wr_en  ),
    .ram2_wr_addr(ram2_wr_addr),
    .ram2_wr_data(ram2_wr_data),
    .ram1_rd_en  (ram1_rd_en  ),
    .ram1_rd_addr(ram1_rd_addr),   
    .ram2_rd_en  (ram2_rd_en  ),
    .ram2_rd_addr(ram2_rd_addr),   
    .data_out    (data_out    )   
);

ram	    ram_inst1 
(
	.data      ( ram1_wr_data ),
	.rdaddress ( ram1_rd_addr ),
	.rdclock   ( clk_25m      ),
	.rden      ( ram1_rd_en   ),
	.wraddress ( ram1_wr_addr ),
	.wrclock   ( clk_50m      ),
	.wren      ( ram1_wr_en   ),
	.q         ( ram1_rd_data )
);

ram	    ram_inst2 
(
	.data      ( ram2_wr_data ),
	.rdaddress ( ram2_rd_addr ),
	.rdclock   ( clk_25m      ),
	.rden      ( ram2_rd_en   ),
	.wraddress ( ram2_wr_addr ),
	.wrclock   ( clk_50m      ),
	.wren      ( ram2_wr_en   ),
	.q         ( ram2_rd_data )
);

endmodule
module  par_to_ser(

    input   wire            clk_5x      ,
    input   wire    [9:0]   par_data    ,
                                        
    output  wire            ser_data_p  ,
    output  wire            ser_data_n  

);


wire     [4:0]   data_rise = {par_data[8], par_data[6], par_data[4], par_data[2], par_data[0]};
wire     [4:0]   data_fall = {par_data[9], par_data[7], par_data[5], par_data[3], par_data[1]};
         
reg      [4:0]   data_rise_s = 0; //无复位信号，需给定初值 
reg      [4:0]   data_fall_s = 0;
reg      [2:0]   cnt = 0;

always@(posedge clk_5x)
    begin
        cnt <= (cnt[2]) ? 3'd0 : (cnt + 1'b1); // cnt达到最大值4时，跳转为0重新计数
        data_rise_s <= (cnt[2]) ? data_rise : data_rise_s[4:1]; // cnt达到最大值4时，更新data_rise_s的值，其余情况进行移位操作
        data_fall_s <= (cnt[2]) ? data_fall : data_fall_s[4:1];
     
    end

DDR	DDR_inst1 
(
	.datain_h ( data_rise_s[0] ),
	.datain_l ( data_fall_s[0] ),
	.outclock ( ~clk_5x        ),
	.dataout  ( ser_data_p     )
);

DDR	DDR_inst2 
(
	.datain_h ( ~data_rise_s[0] ),
	.datain_l ( ~data_fall_s[0] ),
	.outclock ( ~clk_5x        ),
	.dataout  ( ser_data_n     )
);

endmodule
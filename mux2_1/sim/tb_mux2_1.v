`timescale 1ns/1ns 

module tb_mux2_1();
reg [1:0] in1;
reg [1:0] in2;
reg sel;

wire [1:0] out;

initial
    begin
        in1 <= 2'b0;
        in2 <= 2'b0;
        sel <= 1'b0;
    end
always #10 in1 <= {$random} % 4;
//因为always结构是重复执行的，如果在此例中没有延时控制，
//所以过程语句将在0时刻无限循环取值0和1。这种always结构体内的语句，
//在执行时必须带有某种延时控制，不然不会达到所希望的效果。
always #10 in2 <= {$random} % 4;
always #10 sel <= {$random} % 2;

initial 
    begin
        $timeformat(-9, 0, "ns", 6);
        //-9纳秒，0小数后零位，6时间位宽位6位
        $monitor("@time %t:in1=%b in2=%b sel=%b out=%b", $time, in1, in2, sel, out);
                
    end
mux2_1 mu2_1_inst
(
    .in1(in1),
    .in2(in2),
    .sel(sel),
    .out(out)
);
endmodule

    




`timescale 1ns/1ns
module tb_decoder3_8();
//①定义模拟输入输出变量，输入为reg类型，输出为wire类型
reg in1;
reg in2;
reg in3;

wire [7:0] out;

//②初始化，不赋值仿真会显示不定态（红色波形）
initial 
    begin
        in1 <= 1'b0;
        in2 <= 1'b0;
        in3 <= 1'b0;
    end

//③确定输入信号
always #10 in1 <= {$random} % 2;
always #10 in2 <= {$random} % 2;
always #10 in3 <= {$random} % 2;

//④输出信息，可有可无
initial
    begin
        $timeformat(-9, 0, "ns", 6);
        $monitor("@time:%t in1=%b in2=%b in3=%b out=%b", $time, in1, in2, in3, out);
    end

//⑤实例化
decoder3_8 decoder3_8_inst
(
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .out(out)
);
endmodule







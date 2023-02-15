clc; %清理命令行窗口
clear all; %清理工作区

for i=1:256
    imgdata(i)=i-1;
end

%打开或生成 txt 文件,将格式转换完成的数据写入 txt 文件
fidc=fopen('data_test.txt','w+');
for i =1:256
    fprintf(fidc,'%02x ',imgdata(i));
end
fclose(fidc);

